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

  @@num_cargo_carriage = 0
  @@num_pass_carriage = 0 
  
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
    @@num_cargo_carriage += 1
    carriage1 = CargoCarriage.new(@@num_cargo_carriage, 250)
    @@num_cargo_carriage += 1
    carriage2 = CargoCarriage.new(@@num_cargo_carriage, 230)
    carriage1.occupy_places(132)
    carriage2.occupy_places(178)
    # добавляем вагончики поезду (груз)
    cr1.carriage_add(carriage1)
    cr1.carriage_add(carriage2)
    
    # создаем вагончики (2 для пассажирского поезда)  
    @@num_pass_carriage += 1
    carriage3 = PassengerCarriage.new(@@num_pass_carriage, 65)
    @@num_pass_carriage += 1
    carriage4 = PassengerCarriage.new(@@num_pass_carriage, 70)

    carriage3.occupy_places(18)
    carriage4.occupy_places(17)
    
    # добавляем вагончики поезду (пасс)
    ps1.carriage_add(carriage3)
    ps1.carriage_add(carriage4)

    # создаем маршрут
    @routes << r1 = Route.new('fir', 'fif')
    r1.add_station_after('fir', 'sec')
    r1.add_station_after('sec', 'thr')
    r1.add_station_after('thr', 'fou')

    puts "Test data created."
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
      @@num_cargo_carriage = @@num_cargo_carriage + 1
      carriage = CargoCarriage.new(@@num_cargo_carriage, vol)
      #carriage.volume = vol
      train.carriage_add(carriage)
      puts "Train #{train.train_number(train)} has #{train.carriage_count} carriages"
    elsif train.type == 'pass'
      puts "Enter count of places in carriage"
      place = gets.chomp.to_i 
      @@num_pass_carriage = @@num_pass_carriage + 1
      carriage = PassengerCarriage.new(@@num_pass_carriage, place)
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
    @trains.each do |train| 
      puts "Train #{train.train_number(train)} has this carriages: " 
      if train.type == 'cargo' 
        train.each_carriage do |carriage|
        puts "Carriage num: #{carriage.num}. Carriage type: #{carriage.type_carriage} carriage. Carriage has #{carriage.places} volume and #{carriage.occupied_places} occupied volume  "
        end
      end
      if train.type == 'pass' 
        train.each_carriage do |carriage|
        puts "Carriage num: #{carriage.num}. Carriage type: #{carriage.type_carriage} carriage. Carriage has #{carriage.places} places and #{carriage.occupied_places} occupied places  "
        end
      end
    end
  end

  def carriage_occupy_places
    carriage_view_info
    puts "Select number of train to occupy volume/places in carriages:"
    train = gets.chomp
    selected_train = find_train_number(train)
    puts "Select number of carriage to occupy volume/places in carriages:"
    carriage_index = gets.chomp.to_i
    selected_carriage = selected_train.carriages_in_train[carriage_index-1]
    
    #puts "train = #{train}"
    puts "selected_train = #{selected_train}"
    puts "selected_train.train_number = #{selected_train.train_number(train)}"
    puts "selected_train.train_type = #{selected_train.type}"
    
    puts "selected_carriage = #{selected_carriage}"
    
    if selected_train.type == "cargo"
      puts "Enter volume to occupy carriage:"
        volume = gets.chomp.to_i
        if volume > selected_carriage.places - selected_carriage.occupied_places  
          puts "Not enough free volume in this carriage. Selected carriage has #{selected_carriage.places - selected_carriage.occupied_places} free volume "
        else
          selected_carriage.occupy_places(volume)
        end
    end
    if selected_train.type == "pass"
        if selected_carriage.occupied_places == selected_carriage.places
          puts "Carriage full. Select another carriage"
        else
          selected_carriage.occupy_places(1)
        end 
    end 
    #carriage.
    #selected_train.carriages_in_train

  end

  def view_trains_on_station
    @stations.each do |station|
      puts "Station #{station.station_name} has this trains: "
      station.trains_view do |train|
        puts "Train number #{train.number} type: #{train.type} with #{train.carriages_in_train.size} carriages.  "
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
      puts "14 - Occupy carriage"
      puts "15 - create test data - trains, carriages, stations and routes"
      puts "0 - EXIT"
      puts "=========================================================="
      
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
        when "14"
          carriage_occupy_places
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
