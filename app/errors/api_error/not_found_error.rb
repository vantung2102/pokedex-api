module APIError
  class NotFoundError < StandardError
    def initialize(message = nil)
      super(
        status: 404,
        title: 'Not Found',
        message: message || 'The finding resource can not be found'
      )
    end
  end
end
