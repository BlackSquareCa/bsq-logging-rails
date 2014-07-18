class Logger::SimpleFormatter
  def call(severity, time, progname, message)
    key_value_pair_log_formatter.call(severity, time, progname, message)
  end

  def key_value_pair_log_formatter
    @key_value_pair_log_formatter ||= BlackSquareLoggingRails::KeyValuePairLogger.new
  end
end