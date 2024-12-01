class GatherPokemonService < ApplicationService
  include Pagination

  attr_reader :collection, :filters, :orders

  def initialize(collection, filters, orders)
    @collection = collection
    @filters = filters
    @orders = orders
  end

  def call
    collection
  end

  private

  def default_filters
    filters
  end

  def default_orders
    @default_orders ||= {
      order_by: orders[:order_by] || 'id',
      order_direction: orders[:order_direction] || 'desc'
    }
  end
end
