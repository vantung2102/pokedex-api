class ApplicationController < ActionController::API
  include Pagy::Backend
  include JSONAPIRender
  include ExceptionFilter
  include Pundit::Authorization

  private

  def filter_params
    params[:filter]&.permit! || {}
  end

  def order_params
    params[:order]&.permit! || {}
  end
end
