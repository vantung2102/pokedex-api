module Resourceable
  extend ActiveSupport::Concern

  included do
    before_action :prepare_collection, only: %i[index]
    before_action :prepare_new_object, only: %i[create]
    before_action :prepare_object, only: %i[show update destroy]

    assign_resource_class_accessors
  end

  module ClassMethods
    attr_accessor :resource_class,
                  :resource_pagy_variable,
                  :resource_collection_variable,
                  :resource_object_variable,
                  :resource_collection_includes,
                  :resource_object_includes,
                  :resource_collection_serializer,
                  :resource_object_serializer

    def resource_with(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:class,
                                :collection_variable,
                                :object_variable,
                                :collection_includes,
                                :object_includes,
                                :collection_serializer,
                                :object_serializer
                               )
      assign_resource_class_accessors(options)
    end

    def resource_actions(*only_actions)
      all_actions = %i[index show create update destroy]
      except_actions = all_actions - only_actions

      except_actions.each do |action|
        undef_method(action)
      end
    end

    private

    def assign_resource_class_accessors(options = {})
      self.resource_class = options.fetch(:class, (name.split('::').last.sub(/Controller$/, '').singularize.constantize rescue nil)) # rubocop:disable Style/RescueModifier
      self.resource_collection_variable = options.fetch(:collection_variable, :@collection).to_sym
      self.resource_object_variable = options.fetch(:object_variable, :@object).to_sym
      self.resource_collection_includes = options.fetch(:collection_includes, [])
      self.resource_object_includes = options.fetch(:object_includes, [])
      self.resource_collection_serializer = options.fetch(:collection_serializer, nil)
      self.resource_object_serializer = options.fetch(:object_serializer, nil)
      self.resource_pagy_variable = :@pagy
    end
  end

  def index
    pagy, collection = paginate(instance_variable_get(self.class.resource_collection_variable))
    instance_variable_set(self.class.resource_pagy_variable, pagy)
    instance_variable_set(self.class.resource_collection_variable, collection)
    render_resource_collection(collection, each_serializer: self.class.resource_collection_serializer,
                                           include: self.class.resource_collection_includes,
                                           pagy:,
                                           status: :ok
    )
  end

  def show
    object = instance_variable_get(self.class.resource_object_variable)
    render_resource(object, serializer: self.class.resource_object_serializer,
                            include: self.class.resource_object_includes,
                            status: :ok
    )
  end

  def create
    object = instance_variable_get(self.class.resource_object_variable)
    object.assign_attributes(resource_permitted_params)
    object.save!

    render_resource(object, serializer: self.class.resource_object_serializer,
                            include: self.class.resource_object_includes,
                            status: :created
    )
  end

  def update
    object = instance_variable_get(self.class.resource_object_variable)
    object.update!(resource_permitted_params)

    render_resource(object, serializer: self.class.resource_object_serializer,
                            include: self.class.resource_object_includes,
                            status: :ok
    )
  end

  def destroy
    object = instance_variable_get(self.class.resource_object_variable)
    object.destroy!
    head(:ok)
  end

  private

  def resource_permitted_params
    raise NotImplementedError, "You must define `resource_permitted_params` as instance method in #{self.class.name} class"
  end

  def resource_base_scope
    policy_scope(self.class.resource_class)
  end

  def prepare_collection
    collection = resource_base_scope.includes(self.class.resource_collection_includes)
    instance_variable_set(self.class.resource_collection_variable, collection)
    authorize(collection)
  end

  def prepare_new_object
    object = self.class.resource_class.new
    instance_variable_set(self.class.resource_object_variable, object)
    authorize(object)
  end

  def prepare_object
    object = resource_base_scope.includes(self.class.resource_object_includes).find(params[:id])
    instance_variable_set(self.class.resource_object_variable, object)
    authorize(object)
  end

  def collection
    instance_variable_get(self.class.resource_collection_variable)
  end

  def object
    instance_variable_get(self.class.resource_object_variable)
  end
end
