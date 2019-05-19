module Validate
  NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i.freeze
  TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/.freeze

  def valid_number(number)
    raise "Number can't be nil" if number.nil?
    raise 'Number should be at least 6 symbols' if number.to_s.size < 5
    raise 'Number has invalid format' if number !~ NUMBER_FORMAT
  end

  def valid_type(type)
    raise "Type of train is only 'pass' or 'cargo'" if type !~ TYPE_TRAIN_FORMAT
  end

  def valid_station(station_name)
    raise "Station name can't be nil" if station_name.size < 3
  end
end
