module Checkability
  # Checks if postcode exists in Storage
  #
  class StorageChecker
    attr_reader :storage_class

    def initialize(conf = {})
      @storage_class = conf[:storage_class]
    end

    def check_value(checkable)
      value = checkable.value.upcase
      result = _present_in_storage(value)
      checkable.messages << (result ? _message('Found') : _message('Not found'))
      result
    end

    def _present_in_storage(value)
      storage_class.where(value: value)
                   .or(storage_class.where(value: value.strip))
                   .or(storage_class.where(value: value.delete(' ')))
                   .present?
    end

    def _message(str)
      "Allowed #{storage_class}s list: #{str}."
    end
  end
end
