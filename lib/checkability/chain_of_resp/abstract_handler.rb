# frozen_string_literal: true

require_relative 'handler'

module ChainOfResp
  # @abstract
  class AbstractHandler < ChainOfResp::Handler
    # @return [Handler]
    attr_reader :stop_process_on_failure, :stop_process_on_success
    attr_accessor :handler, :result

    def initialize(opts = {})
      @stop_process_on_failure = opts[:stop_process_on_failure] || false
      @stop_process_on_success = opts[:stop_process_on_success] || false
      @next_handler = nil
      post_initialize(opts) # implemented in subclass
    end

    # @param [Handler] handler
    #
    # @return [Handler]
    def next_handler(handler)
      @handler = handler if handler

      handler
    end

    # @abstract
    #
    # @param [String] request
    #
    # @return [Boolean, nil]
    def handle(request)
      check = check_value(request) # imlemented in subclass
      return true  if check && stop_process_on_success

      return false if !check && stop_process_on_failure

      handler&.handle(request)
    end
  end
end
