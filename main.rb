# подключаем все классы
require_relative "./station.rb"
require_relative "./route.rb"
require_relative './train'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './carriage' 
require_relative './passenger_carriage' 
require_relative './cargo_carriage'
require_relative './manufacturer' 
require_relative './instance_counter'
#require_relative './validate'

class MainMenu
  include Manufacturer
  include InstanceCounter
  #include Validate
  

  attr_accessor :stations, :trains, :routes

  def initialize
    @stations = []  # хранит обьекты станции @stations << station
    @trains = []    # хранит обьекты поезда @trains << new_train
    @routes = []    # хранит обьекты маршрут из new_route
    @number_train
  end

  def test_data
    @stations << Station.new('first')
    @stations << Station.new('second')
    @stations << Station.new('third')
    @stations << Station.new('fourth')
    @stations << Station.new('fifth')
    @stations << Station.new('six')
    @stations << Station.new('seven')

    @trains << ps1 = PassTrain.new('165-ps')
    @trains << ps2 = PassTrain.new('185-ps')
    @trains << ps3 = PassTrain.new('205-ps')
    @trains << cr1 = CargoTrain.new('700-cr')
    @trains << cr2 = CargoTrain.new('800-cr')
    cr1.man_assign = 'CargoFacture'
    cr2.man_assign = 'LVRZ'
    ps1.man_assign = 'PassMan'
    ps2.man_assign = 'GovRails'
    ps3.man_assign = 'GovRails'
    
    @routes << Route.new('a', 'c')
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.route_name} "}
    @routes[0].add_station_after('a', 'b')
    @routes[0].display_route

    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} at #{train.position}. " }
  end

  def find_train
    puts "Enter number of train: "
    number_train = gets.chomp
    puts "Train found: #{Train.find(number_train)}"
  end
  
  def create_new_station # для пункта 1, создание станции
    begin
      puts "Enter name of new station: "
      new_station_name = gets.chomp
      station = Station.new(new_station_name)
    rescue RuntimeError
      puts "Enter CORRECT! station name (should be at least 3 symbols/digits)"
    retry
    end
    @stations << station
  end
  
  def view_stations_routes_and_trains # для пункта 8, отображение всего что наделано
    puts "----- Stations-----"
    @stations.each.with_index(1) { |station, i| puts "Station #{i} - #{station.station_name}"}
    puts "----- Routes-----"
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.route_name} "}
    puts "----- Trains-----"
    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} is #{train.train_type}. Train has #{train.carriage_count} carriages. Manufacturer is #{train.man_assign}.  "} 
    puts "----- Trains on Stations now-----"
    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} at #{train.position}. " }
  end
  
  def stations_all
    puts Station.all
  end

  def create_new_train
    begin
      puts "Enter number of train. Format of number should be xxxxx or xxx-xx"
      number_train = gets.chomp
      puts "Enter type of train (cargo or pass): "
      train_type = gets.chomp
      puts "Enter Manufacturer of train : "
      manufacturer_name = gets.chomp
      if train_type == "cargo"  
        new_train = CargoTrain.new(number_train)
      elsif train_type == "pass"
        new_train = PassTrain.new(number_train)
      else
        puts "Unknown type of train"
      end
      rescue StandardError => err
        error_message err
      retry
    end
    new_train.train_type = train_type
    new_train.man_assign = manufacturer_name
    @trains << new_train
    puts "New #{train_type} train number: #{number_train} was created!"
  end
  
  def create_change_route # для пункта 3 - создание, изменение маршрута. 
    @routes.each_with_index { |route_list, i| puts "Existing route #{i+1} is #{route_list.display_route}" } if @routes.size > 0 # выводим имеющиеся маршруты
    puts "Enter start station of route: "
    start_station = gets.chomp
    puts "Enter last station of route: "
    end_station = gets.chomp
    new_route = Route.new(start_station, end_station) # создаем на основе класса роут новый маршрут.
    @routes << new_route # записываем его в массив маршрутов 
    puts "@routes = #{@routes}"
    puts "@routes.route_list = #{new_route.display_route}"
    puts new_route.start_station
    puts new_route.last_station

    #@routes.each_with_index { |route, i| route_list[i+1] = route.display_route }
    #@routes.each_with_index { |route, i| puts "#{i+1} - #{@route_display}"} 
    # проверка
  
    loop do # подменю для добавления, удаления, отображения маршрута (методы из роут)
      puts "Continue with route? " 
      puts "Type 'add' for add substation."
      puts "Type 'del' for delete substation"
      puts "Type 'display' for display full route"
      puts "Type 'exit' for return to MainMenu"
      choice_route = gets.chomp
      break if choice_route == "exit"
      case choice_route
        when "add"
          begin
            print "Enter name of station before: "
            before_station = gets.chomp
            print "Enter substation : "
            substation = gets.chomp
            new_route.add_station_after(before_station, substation)
            rescue StandardError => err # если ошибка, то пишем что в ошибке (в классе Route, что станция существует уже)
            error_message err
            retry
          end
        when "del"
          begin 
          puts new_route.display_route
          print "Enter name of station to delete: "
          del_station = gets.chomp
          new_route.del_station_from_route(del_station)
            rescue StandardError => err # если ошибка, то пишем что в ошибке (в классе Route, что станция существует уже)
            error_message err
            retry
          end
        when "display"
          @routes.each_with_index { |route, i| puts "Route #{i+1} - #{route.route_name}"}
          #@routes.each_with_index { |route, i| @routes_list[i+1] = route.display_route}
          #puts @routes
      end 
    end
  end
  
   def set_routes_trains # для пункта 4 - назначаем маршрут поезду
    puts "Enter number of train to assign route: " 
    assign_train = gets.chomp
    puts "Enter route name (first station-last station) for assign to train: "
    #puts @routes_list
    @routes.each_with_index { |route, i| puts "Route #{i+1} - #{route.route_name}"}
    assign_route = gets.chomp
    
    selected_train = find_train_number(assign_train) # ищем поезд по номеру
    selected_route = find_route_by_name(assign_route) # ищем маршрут по номеру

    puts "Selected train = #{selected_train}"
    puts "Selected route = #{selected_route}"

    selected_train.train_on_route(assign_train, selected_route.route_list)
    puts "route (position list) of train is #{ selected_train.position}"
    puts "position start = #{selected_train.position[0]}"
    puts "position end = #{selected_train.position[-1]}"
    selected_train.position.delete_at(0)
  end
  
  def move_train_on_assigned_route
    
    puts "Enter train number to move"
    number_train = gets.chomp
    
    move_train = find_train_number(number_train)
    loop do
      puts "Enter 'next' for move train to next station or 'prev' for move train to previos station, or Enter 'stop' for stop move: "
      choice_move = gets.chomp
      break if choice_move == "stop"
      if choice_move == "next"
        move_train.train_go_to_next(number_train, move_train.position)
      end
      if choice_move == "prev"
        move_train.train_go_to_previous(number_train, move_train.position)
      end
    end
  end
 

  def carriage_add_to_train # для пункта 5 - добавляем вагон, методы создать вагон и добавить вагон описаны в трэйн (в нем сравнить)
    puts "Enter number of train to add carriage"
    train_number = gets.chomp
    train = find_train_number(train_number) # метод поиска поезда по номеру find_train_number, поезд к которому хотим добавить вагон
    if train.speed != 0 
      puts "Carriage cannot be added! Speed = #{@speed}"
      elsif train.train_type == 'cargo' 
        carriage = CargoCarriage.new
        train.carriage_add(carriage)
        puts "Train #{train_number} has #{train.carriage_count} carriages"
      elsif train.train_type == 'pass'
        carriage = PassengerCarriage.new
        train.carriage_add(carriage)
        puts "Train #{train_number} has #{train.carriage_count} carriages"
      else
      puts "Train not found!"
    end
  end
  
  def carriage_delete_from_train # для пункта 6 - убрать вагон из состава поезда
    puts "Enter number of train to delete carriage"
    number_train = gets.chomp
    train = find_train_number(number_train) # метод поиска поезда по номеру find_train_number, поезд у которого убираем вагон, добавить проверку количества вагонов carriage_count
    if train.speed != 0 
      puts "Train on route. Speed = #{train.speed}"  
      elsif train.carriage_count > 0
      train.carriage_del
      puts "Carriage has been deleted. Train has #{train.carriage_count} railway_carriages now."         
      else          
      puts "Carriage hasn't railway_carriages."         
    end
  end  
     
  def find_train_number(number_train) # вспомогательный метод, часто
    @trains.find { |train| train.number == number_train }
    #puts @trains.find { |train| train.number == number_train } 
  end
  
  def find_station(station_name) # ищем станцию по имени
    @stations.find { |station| station.station_name == station_name }
  end
  
  def find_route_by_name(route_name)
    @routes.find { |route| route.route_name == route_name }
  end

  def list # список пунктов меню с методами, определенными выше
    loop do
      puts "===================Programm Railway Manage================="
      puts "------Enter your choice from MENU: --------"
      puts "1 - create the station" # Создавать станции
      puts "2 - create the train" #  Создавать поезда
      puts "3 - create the route" #  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
      puts "4 - set route to train" #  Назначать маршрут поезду
      puts "5 - add carriages to train" #  Добавлять вагоны к поезду
      puts "6 - delete carriages of train" #  Отцеплять вагоны от поезда
      puts "7 - move train on route"      #  Перемещать поезд по маршруту вперед и назад
      puts "8 - display stations and trains on station" #  Просматривать список станций и список поездов на станции
      puts "9 - display stations objects" #  Отобразить станции объектами
      puts "10 - find train by number " # Возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.
      puts "0 - EXIT"
      choice = gets.chomp
      break if choice == "0"
      case choice
        when "1" # Создавать станции -----------------------------------
          create_new_station
        when "2" #  Создавать поезда -----------------------------------
          create_new_train
        when "3" #  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
          create_change_route
        when "4" #  Назначать маршрут поезду ---------------------------
          set_routes_trains #set_route_to_train
        when "5" #  Добавлять вагоны к поезду --------------------------
          carriage_add_to_train     
        when "6" #  Отцеплять вагоны от поезда -------------------------
          carriage_delete_from_train
        when "7" #  Перемещать поезд по маршруту вперед и назад --------
          move_train_on_assigned_route
        when "8" #  Просматривать список станций и список поездов на станции
          view_stations_routes_and_trains  
        when "9" #  Отобразить станции объектами
          stations_all
        when "10"
          find_train            
        end
      end  
  end
  
  def error_message(err)
    puts "Error: #{err.message}"
  end
end





menu = MainMenu.new  
menu.test_data
menu.list


