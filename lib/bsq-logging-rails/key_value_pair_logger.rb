module BlackSquareLoggingRails
  class KeyValuePairLogger
    def call(severity, time, progname, message)
      message.strip!
      return nil if message.blank?

      line_prefix = "now=#{BlackSquareLoggingRails.format_value(Time.now.utc)} "
      line_prefix << BlackSquareLoggingRails.global_logging_context_data.map do |key, value|
        "#{key}=#{BlackSquareLoggingRails.format_value(value)}"
      end.join(' ')
      line_prefix << " level=#{BlackSquareLoggingRails.format_value(severity.downcase)}"

      "#{line_prefix} message=#{BlackSquareLoggingRails.format_value(message)}\n"
    end
  end
end
