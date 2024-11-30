module APIError
  class UnprocessableEntityError < StandardError
    def initialize(message: nil, errors: [])
      super(
        status: 422
        errors: errors,
        message: message || 'Unprocessable entity'
      )
    end
  end
end
