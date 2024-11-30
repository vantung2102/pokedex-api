module APIError
  class ParamMissingError < StandardError
    def initialize(param = nil)
      super(
        status: 400,
        title: 'Bad Request',
        deatil: "Param '#{param}' is msissing or the value is empty."
      )
    end
  end
end
