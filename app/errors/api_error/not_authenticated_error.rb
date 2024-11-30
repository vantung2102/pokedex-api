module APIError
  class NotAuthenticatedError < StandardError
    def initialize(message = nil)
      super(
        status: 401,
        title: 'Unauthorized',
        message: message || 'You are not authenticated'
      )
    end
  end
end
