class ApplicationSerializer < Blueprinter::Base
  identifier :id

  # field :created_at do |object|
  #   object.created_at&.to_i
  # end

  # field :updated_at do |object|
  #   object.updated_at&.to_i
  # end

  def self.url_for(object)
    return unless object.present?

    Rails.application.routes.url_helpers.url_for(object)
  end
end
