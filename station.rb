require './train.rb'
require './cargo_train.rb'
require './instance_counter'

class Station
  @@existing_stations = []

  include InstanceCounter

  # class method all,  in main case 9
  def self.all
    puts @@existing_stations.size
    @@existing_stations
  end

  # create station name
  def initialize(name)
    @name = name
    validate!
    # puts "validate = #{validate?}" for test validate
    @train_on_station = []
    register_instance # from InstanceCounter
    @@existing_stations << self
  end

  def validate?
    validate!
  rescue StandardError
    false
    retry
  end

  def station_name
    @name
  end

  def train_arrived(train)
    #  puts "Train arrived on the station #{@name}"
    @train_on_station << train
    #  puts "Trains on the station now is #{@train_on_station}"
  end

  def train_departure(train)
    @train_on_station.delete(train)
    #  puts "Train #{train} departed from #{@name}"
    #  puts "Trains on the station now is #{@train_on_station}"
  end

  # from array @train_on_station each train send to block train
  def trains_view
    @train_on_station.each { |train| yield(train) } if block_given?
  end

  protected

  def validate!
    raise "Station name can't be nil" if station_name.to_s.size < 3
    true
  end
end
