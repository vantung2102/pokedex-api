module APIError
  class RecordInvalidError < StandardError
    def initialize(errors = [])
      super(
        status: 422,
        errors:,
        title: 'Unprocessable Entity'
      )
    end

    def serializer_hash
      {
        title:,
        status:,
        errors: serializable_errors(errors)
      }
    end

    private

    def serializable_errors(errors)
      errors.each_with_object([]) do |error, memo|
        memo << {
          field: error.attribute,
          message: error.full_message
        }
      end
    end
  end
end
