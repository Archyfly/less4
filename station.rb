require "./train.rb"
require "./cargo_train.rb"
require "./instance_counter"
class Station
  
  @@count = 0
  include InstanceCounter

  def self.all
    puts "Количество станций (созданных экзэмпляров) #{@@count}"  
  end

  def initialize(name) # Создаем станцию name
    @name = name
    puts "New station created. Name of station: #{name}"
    @train_on_station = [] # задаем пустой массив поездов на станции - сюда передавать будем
    @@count += 1
    
  end
  
  def station_name
    @name
  end
  
  def display_trains_on_station
  	puts "Train on station now is: #{@train_on_station}"
  end
  
  def train_arrived(train)
    puts "Train arrived on the station #{@name}"
    @train_on_station << train
    puts "Trains on the station now is #{@train_on_station}"
  end

  def train_departure(train)
  	@train_on_station.delete(train)
  	puts "Train #{train} departed from #{@name}"
    puts "Trains on the station now is #{@train_on_station}"
  end

end
=begin
train1 = CargoTrain.new(185)
train1.train_type = 'Cargo'
station1 = Station.new('Elovka')
station1.train_arrived(train1.number)
train2 = CargoTrain.new(11)
train2.train_type = 'Cargo'
station1.train_arrived(train2.number)
station1.train_departure(train1.number)
=end
#station1 = Station.new('Elovka')
#station2 = Station.new('Pihtovka')
#station3 = Station.new('Kedrovka')
#station4 = Station.new('Sosnovka')
#Station.all




