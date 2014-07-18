module BlackSquareLoggingRails
  module Controllers
    autoload :LoggingSupport, 'bsq-logging-rails/controllers/logging_support'
  end

  # The default way to set up this logging infrastructure is via an initializer.
  def self.setup
    yield self
  end

  # True if we should log request parameters, false otherwise
  mattr_accessor :enable_request_parameter_logging
  @@enable_request_parameter_logging = true

  # The name of the current application
  mattr_reader :logging_schema_version
  @@logging_schema_version = '1'

  # The name of the current application
  mattr_accessor :application_version
  @@application_version = nil

  # The name of the current application
  mattr_accessor :application_name
  @@application_name = nil

  # The name of the current application
  mattr_accessor :environment
  @@environment = Rails.env

  # The name of the current application
  mattr_accessor :log_source
  @@log_source = nil

  # The name of the current application
  mattr_accessor :business_event_prefix
  @@business_event_prefix = 'bsq.'

  def self.global_logging_context_data
    {
        log_ver: BlackSquareLoggingRails.logging_schema_version,
        app: BlackSquareLoggingRails.application_name,
        app_ver: BlackSquareLoggingRails.application_version,
        source: BlackSquareLoggingRails.log_source,
        deploy: formatted_environment
    }
  end

  def self.format_value(message)
    case message
      when Float
        '%.2f' % message
      when Array
        message
      when Hash
        message
      when Integer
        message
      when Time
        "\"#{message.iso8601}\""
      when String
        format_string(message)
      else
        format_string(message.inspect)
    end
  end

  def self.format_string(string)
    has_single_quote = string.index("'")
    has_double_quote = string.index('"')

    if string =~ /[ =:,]/
      if has_single_quote && has_double_quote
        '"' + string.gsub(/\\|"/) { |c| "\\#{c}" } + '"'
      elsif has_double_quote
        "'" + string.gsub('\\', '\\\\\\') + "'"
      else
        '"' + string.gsub('\\', '\\\\\\') + '"'
      end
    else
      string
    end
  end

  def self.formatted_environment
    if BlackSquareLoggingRails.environment == 'production'
      'prod'
    elsif BlackSquareLoggingRails.environment == 'staging'
      'stg'
    elsif BlackSquareLoggingRails.environment == 'development'
      'dev'
    else
      BlackSquareLoggingRails.environment
    end
  end

  require 'bsq-logging-rails/railtie' if defined? ::Rails::Railtie
  require 'bsq-logging-rails/rails4_log_formatter' if defined? ActiveSupport::Logger::SimpleFormatter
  require 'bsq-logging-rails/rails32_log_formatter' if defined? Logger::SimpleFormatter
end