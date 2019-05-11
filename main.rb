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

   def test_data # пункт 15 - создать тестовые данные
    # создаем станции
    @stations << st1 = Station.new('fir')  
    @stations << st2 = Station.new('sec')
    @stations << st3 = Station.new('thr')
    @stations << st4 = Station.new('fou')
    @stations << st5 = Station.new('fif')

    # создаем поезда
    @trains << ps1 = PassTrain.new('165-ps')
    @trains << cr1 = CargoTrain.new('77777')
   
    # назначаем поездам производителя
    cr1.man_assign = 'CargoFacture'
    ps1.man_assign = 'PassMan'
   
    # создаем вагончики (2 для грузового поезда)
    carriage1 = CargoCarriage.new
    carriage2 = CargoCarriage.new
    
    # добавляем вагончики поезду (груз)
    cr1.carriage_add(carriage1)
    cr1.carriage_add(carriage2)
    
    # создаем вагончики (2 для пассажирского поезда)  
    carriage3 = PassengerCarriage.new
    carriage4 = PassengerCarriage.new
    
    # добавляем вагончики поезду (пасс)
    ps1.carriage_add(carriage3)
    ps1.carriage_add(carriage4)

    # заполняем вагончики грузом и людьми
    carriage1.volume = 20
    carriage2.volume = 30
    carriage3.places = 70
    carriage4.places = 50  
    
    # создаем маршрут
    @routes << r1 = Route.new('fir', 'fif')
    r1.add_station_after('fir', 'sec')
    r1.add_station_after('sec', 'thr')
    r1.add_station_after('thr', 'fou')
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
    @stations.each.with_index(1) { |station, i| puts "Station #{i} - #{station.station_name}"}
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.route_name} "}
    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} is #{train.train_type}. Train has #{train.carriage_count} carriages. Manufacturer is #{train.man_assign}"} 
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
  
  def create_route # для пункта 3 - создание маршрута. 
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
  end

  def change_route # для пункта 4 изменение маршрута
    if @routes.size > 0 
    @routes.each_with_index { |route_list, i| puts "Existing route #{i+1} is #{route_list.display_route}" } if @routes.size > 0 # выводим имеющиеся маршруты
    puts "Select route name (first station-last station)"
    assign_route = gets.chomp
    selected_route = find_route_by_name(assign_route)
    loop do # подменю для добавления, удаления, отображения маршрута (методы из роут)
      puts "" 
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
          selected_route.add_station_after(before_station, substation)
        rescue StandardError => err # если ошибка, то пишем что в ошибке (в классе Route, что станция существует уже)
            error_message err
        retry
        end
      when "del"
        begin 
          puts selected_route.display_route
          print "Enter name of station to delete: "
          del_station = gets.chomp
          selected_route.del_station_from_route(del_station)
        rescue StandardError => err # если ошибка, то пишем что в ошибке (в классе Route, что станция существует уже)
          error_message err
          retry
        end
      when "display"
        @routes.each_with_index { |route, i| puts "Route #{i+1} - #{route.route_list}"} # вывод полного маршрута с изменениями
      end 
    end
    else
      puts "List of routes is empty, please create route first"
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
    

    set_stat = find_station(selected_train.position[0]) # находим станцию по имени в маршруте и определяем прибытие на эту станцию.

    set_stat.train_arrived(selected_train) # поезд прибыл на первую станцию. (это нужно для заполнения массива train_on_station)

    puts "route (position list) of train is #{ selected_train.position}"
    puts "position start = #{selected_train.position[0]}"
    puts "position end = #{selected_train.position[-1]}"
  end

  def move_train_on_assigned_route
    puts "Enter train number to move"
    number_train = gets.chomp
    move_train = find_train_number(number_train)
   # loop do
    puts "Train #{move_train.number} now on station #{move_train.position[move_train.train_pos_now]}"
    puts "Enter 'next' for move train to next station or 'prev' for move train to previos station, or Enter 'stop' for stop move: "
    choice_move = gets.chomp
      #break if choice_move == "stop"
    if choice_move == "next" && move_train.position[move_train.train_pos_now+1] != nil
      move_train.train_go_to_next(number_train, move_train.position)
    end

    if choice_move == "prev" && move_train.train_pos_now > 0
      move_train.train_go_to_previous(number_train, move_train.position)
    end

    puts "Train #{move_train.number} now on station #{move_train.position[move_train.train_pos_now]}"
    if move_train.position[move_train.train_pos_now+1] == nil
      puts "Train on last station" 
      puts "Previos station is #{ move_train.position[move_train.train_pos_now-1]}"
    elsif  move_train.train_pos_now == 0
      puts "Train on start station" 
      puts "Next station is #{ move_train.position[move_train.train_pos_now+1]}" 
    else
      puts "Next station is #{ move_train.position[move_train.train_pos_now+1]}"
      puts "Previos station is #{ move_train.position[move_train.train_pos_now-1]}"
    end
  end
 

  def carriage_add_to_train # для пункта 6 - добавляем вагон, методы создать вагон и добавить вагон описаны в трэйн (в нем сравнить)
    puts "Enter number of train to add carriage"
    number_train = gets.chomp
    train = find_train_number(number_train) # метод поиска поезда по номеру find_train_number, поезд к которому хотим добавить вагон
    puts train
    puts train.speed
    puts train.type
    if train.speed != 0 
      puts "Carriage cannot be added! Speed = #{@speed}"
    elsif train.type == 'cargo'
      puts "Enter volume of carriage"
      vol = gets.chomp.to_i 
      carriage = CargoCarriage.new
      carriage.volume = vol
      train.carriage_add(carriage)
      puts "Train #{train.train_number(train)} has #{train.carriage_count} carriages"
    elsif train.type == 'pass'
      puts "Enter count of places in carriage"
      count_places = gets.chomp.to_i 
      carriage.places = count_places
      train.carriage_add(carriage)
      carriage = PassengerCarriage.new
      train.carriage_add(carriage)
      puts "Train #{train.train_number(train)} has #{train.carriage_count} carriages"
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

 def carriage_view_info
    #puts "Enter number of train to delete carriage"
    #number_train = gets.chomp
    #train = find_train_number(number_train)
    @trains.each {|train| 
    puts "Train #{train.train_number(train)} has this carriages: " 
    train.carriages_view(train)
    }
  end

  # def view_trains_on_station
    #@stations.each { |station| 
     # puts "On station #{station.station_name} train is:"
     # station.trains_view(station)
    #}
  #end
  def view_trains_on_station
    @stations.each do |station|
      puts "Station #{station.station_name} has this trains: "
      station.trains_view do |train|
        puts "Train number #{train.number} witn #{train.carriages_in_train.size} carrriages.  "
      end
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
      puts "5 - change route" #  Назначать маршрут поезду
      puts "6 - add carriages to train" #  Добавлять вагоны к поезду
      puts "7 - delete carriages of train" #  Отцеплять вагоны от поезда
      puts "8 - move train on route"      #  Перемещать поезд по маршруту вперед и назад
      puts "9 - display stations and trains on station" #  Просматривать список станций и список поездов на станции
      puts "10 - display stations objects" #  Отобразить станции объектами
      puts "11 - find train by number " # Возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.
      puts "12 - View carriages in trains"
      puts "13 - View trains on stations"
      puts "15 - create test data - trains, carriages, stations and routes"
      puts "0 - EXIT"
      choice = gets.chomp
      break if choice == "0"
      case choice
        when "1" # Создавать станции -----------------------------------
          create_new_station
        when "2" #  Создавать поезда -----------------------------------
          create_new_train
        when "3" #  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
          create_route
        when "4" #  Назначать маршрут поезду ---------------------------
          set_routes_trains #set_route_to_train
        when "5" #  Изменять маршрут --------------------------
          change_route 
        when "6" #  Добавлять вагоны к поезду --------------------------
          carriage_add_to_train     
        when "7" #  Отцеплять вагоны от поезда -------------------------
          carriage_delete_from_train
        when "8" #  Перемещать поезд по маршруту вперед и назад --------
          move_train_on_assigned_route
        when "9" #  Просматривать список станций и список поездов на станции
          view_stations_routes_and_trains  
        when "10" #  Отобразить станции объектами
          stations_all
        when "11"
          find_train            
        when "12"
          carriage_view_info
        when "13"
          view_trains_on_station
        when "15"
          self.test_data
          
        end
      end  
  end
  
  def error_message(err)
    puts "Error: #{err.message}"
  end


  
end

menu = MainMenu.new
#menu.test_data  
menu.list
