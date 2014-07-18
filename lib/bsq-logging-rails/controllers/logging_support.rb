require 'active_support/concern'
require 'scrolls'

module BlackSquareLoggingRails
  module Controllers
    module LoggingSupport
      extend ActiveSupport::Concern

      included do
        around_filter :set_scrolls_context
      end

      protected

      # Sets the current request id into the payload used by Rails' LogSubscriber. This is used by the
      # lograge gem to tame the default Rails logging
      def append_info_to_payload(payload)
        super
        request_logging_context_data.each do |key, value|
          payload[key] = BlackSquareLoggingRails.format_value(value)
        end

        # Add request parameters to lograge output when the logger is in DEBUG mode
        if BlackSquareLoggingRails.enable_request_parameter_logging
          parameters = request.filtered_parameters.except(*ActionController::LogSubscriber::INTERNAL_PARAMS)
          payload[:request_params] = BlackSquareLoggingRails.format_value(parameters) if parameters.any?
        end
      end

      # Sets the current request id into the context used by the Scrolls logging gem
      def set_scrolls_context
        ::Scrolls.context(request_logging_context_data) do
          yield
        end
      end

      def request_logging_context_data
        @request_logging_context_data ||= gather_request_logging_context_data
      end

      def gather_request_logging_context_data
        {
            host: BlackSquareLoggingRails.format_value(request_host_name),
            remote_ip: BlackSquareLoggingRails.format_value(remote_ip_address),
            request_id: BlackSquareLoggingRails.format_value(request_id)
        }
      end

      # Returns the request identifier
      def request_id
        request.uuid
      end

      def request_host_name
        request.host
      end

      def remote_ip_address
        if env
          env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
        else
          request.remote_ip
        end
      end
    end
  end
end