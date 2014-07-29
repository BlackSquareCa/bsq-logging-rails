require 'bsq-logging-rails/key_value_pair_logger'
require 'rails/railtie'
require 'lograge'
require 'scrolls'

module BlackSquareLoggingRails
  class Railtie < Rails::Railtie

    config.before_initialize do
      require 'bsq-logging-rails/notifications'
    end

    config.after_initialize do
      ::Scrolls.init(
          global_context: BlackSquareLoggingRails.global_logging_context_data,
          exceptions: 'single',
          time_unit: 'ms'
      )
    end

    initializer :bsq_logging_lograge, :before => :lograge do |app|
      app.config.lograge.enabled = true
      app.config.lograge.formatter = ->(data) { ::Scrolls.log(data) }

      # Compile a list of all the logging attributes we want to slice from the event payload
      # and include in lograge log lines. They are added to the payload in the append_info_to_payload
      # method in logging_support.rb
      payload_params = BlackSquareLoggingRails.global_logging_context_data.keys
      payload_params << :host
      payload_params << :remote_ip
      payload_params << :request_id
      payload_params << :session_id
      payload_params << :request_params

      app.config.lograge.custom_options = -> (event) do
        event.payload.slice(*payload_params)
      end
    end

    initializer :bsq_logging_controllers do
      ActiveSupport.on_load(:action_controller) do
        include BlackSquareLoggingRails::Controllers::LoggingSupport
      end
    end
  end
end