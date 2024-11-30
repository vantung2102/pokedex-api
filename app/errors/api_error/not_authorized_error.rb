module APIError
  class NotAuthorizedError < StandardError
    def initialize(message = nil)
      super(
        status: 403,
        title: 'Forbidden',
        message: message || 'Permission Denied'
      )
    end
  end
end
