# подключаем все классы
require_relative "./station.rb"
require_relative "./route.rb"
require_relative './train.rb'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './carriage'
#require_relative './main.rb' 

NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i
include Manufacturer
include InstanceCounter
  #include Validate
  
Class test
  attr_accessor :stations, :trains, :routes

  def initialize
    @stations = []  # хранит обьекты станции @stations << station
    @trains = []    # хранит обьекты поезда @trains << new_train
    @routes = []    # хранит обьекты маршрут из new_route
    @number_train
  end
def view_stations_routes_and_trains # для пункта 8, отображение всего что наделано
    @stations.each.with_index(1) { |station, i| puts "Station #{i} - #{station.station_name}"}
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.route_name} "}
    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} is #{train.train_type}. Train has #{train.carriage_count} carriages. Manufacturer is #{train.man_assign}"} 
  end

station1 = Station.new('Elovka')

train1 = PassTrain.new('23333')
view_stations_routes_and_trains
