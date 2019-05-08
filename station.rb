require "./train.rb"
require "./cargo_train.rb"
require "./instance_counter"
class Station
  
  @@count = 0
  @@existing_stations = []  # который возвращает все станции (объекты), созданные на данный момент (хотя эти экземпляры уже собраны в main.rb @stations)

  include InstanceCounter

  def self.all # метод класс all, для него в main пункт 9 
    puts "Count of stations: #{@@count}"  
    @@existing_stations #  который возвращает все станции (объекты), созданные на данный момент  
  end

  def initialize(name) # Создаем станцию name
    @name = name
    validate!
    #puts "validate = #{validate?}" для проверки валидности
    @train_on_station = [] # задаем пустой массив поездов на станции - сюда передавать будем
    register_instance #из InstanceCounter 
    @@count += 1
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
  
  #def display_trains_on_station
  #	puts "Train on station now is: #{@train_on_station}"
  #end
  
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

  protected

  def validate!
    raise "Station name can't be nil" if station_name.to_s.size < 3
    true
  end

end

#station1 = Station.new('M2')
#station2 = Station.new('Depo')
#station2.train_arrived(2)
#station2.display_trains_on_station
