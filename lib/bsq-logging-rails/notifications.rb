event_pattern = Regexp.new("\\A#{Regexp.quote(BlackSquareLoggingRails.business_event_prefix)}")

ActiveSupport::Notifications.subscribe event_pattern do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  name = event.name
  duration = event.duration
  payload = event.payload

  log_entry = {measure: BlackSquareLoggingRails.format_value(name)}
  # only record duration if it is meaningful - duration is in milliseconds
  log_entry.merge!({elapsed: BlackSquareLoggingRails.format_value(duration)}) if duration >= 1
  log_entry.merge! payload

  ::Scrolls.log(log_entry)
end