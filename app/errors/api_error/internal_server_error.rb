module APIError
  class InternalServerError < StandardError
    def initialize(message = nil)
      super(
        status: 500,
        title: 'Internal Server Error',
        message: message || 'Something went wrong'
      )
    end
  end
end
