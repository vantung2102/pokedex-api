class SupportsController < ApplicationController
  def home
    render json: {
      version: '0.0.1',
      app: 'pokemon-rails-api'
    }
  end
end
