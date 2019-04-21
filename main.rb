# подключаем все классы
require_relative "./station.rb"
require_relative "./route.rb"
require_relative './train'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './carriage' 
require_relative './passenger_carriage' 
require_relative './cargo_carriage' 


class MainMenu

  attr_accessor :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = [] # хранит обьекты маршрут из new_route
    @routes_list = {} # хранит хэш имя маршрута - маршрут
    @routes_trains = {} # хранит хэш поезд - маршрут

  end

  def create_new_station # для пункта 1, создание станции
    print "Enter name of new station: "
    station_name = gets.chomp
    station = Station.new(station_name)
    @stations << station_name
    puts "Station #{station_name} was created!"
  end
  
  def view_stations_routes_and_trains # для пункта 8, отображение всего что наделано
    @stations.each.with_index(1) { |station, i| puts "Station #{i} - #{station}"}
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.display}"}
    @trains.each.with_index(1) { |train, i| puts "#{i} - Train number #{train.number} is #{train.train_type}. Train has #{train.carriage_count} carriages"}
  end
  
  def create_new_train # для пункта 2, создание поезда
    print "Enter number of train: "
    number_train = gets.chomp
    print "Enter type of train (cargo or pass): "
    train_type = gets.chomp
    if train_type == "cargo"  
      new_train = CargoTrain.new(number_train)
    elsif train_type == "pass"
      new_train = PassTrain.new(number_train)
    else
      puts "Unknown type of train"
    end
    new_train.train_type = train_type
    @trains << new_train
    puts "New #{train_type} train number: #{number_train} was created!"
  end

  def create_change_route # для пункта 3 - создание, изменение маршрута. 
    puts "@routes = #{@routes}"
   
    print "Enter start station of route: "
    start_station = gets.chomp
    print "Enter last station of route: "
    last_station = gets.chomp
    new_route = Route.new(start_station, last_station) # создаем на основе класса роут новый маршрут.
    
    @routes << new_route # записываем его в массив. 
    puts "@routes = #{@routes}"
    puts "@routes.route_list = #{@routes.display}"
    puts  new_route.start_station
    puts new_route.last_station
    @routes.each_with_index { |route, i| @routes_list[i+1] = route.display }
    #@routes.each_with_index { |route, i| puts "#{i+1} - #{@route_list.display}"} 
    # проверка
    loop do # подменю для добавления, удаления, отображения маршрута (методы из роут)
      puts "Continue with route? " 
      puts "Type '1' for add substation."
      puts "Type '2' for delete substation"
      puts "Type '3' for display full route"
      puts "Type '0' for return to MainMenu"
      choice_route = gets.chomp
      break if choice_route == '0'
      case 
        when choice_route == '1'
          print "Enter name of station before: "
          before_station = gets.chomp
          print "Enter substation : "
          substation = gets.chomp
          new_route.add_station_after(before_station, substation)
        when choice_route == '2'
          puts new_route.display
          print "Enter name of station to delete: "
          del_station = gets.chomp
          new_route.del_station_from_route(del_station)
          when choice_route == '3'
          @routes.each_with_index { |route, i| puts "#{i+1} - #{route.display}"}
          @routes.each_with_index { |route, i| @routes_list[i+1] = route.display}
          puts @routes
      end 
    end
  end
  
  

  def move_train_on_assigned_route
    puts "Enter train number to move"
    number_train = gets.chomp
    assigned_route = @routes_trains[number_train]
=begin проверка
    puts "assigned_route = #{assigned_route}"
    puts "assigned_route[0] = #{assigned_route[0]}"
    puts "assigned_route[-1] = #{assigned_route[-1]}"
=end
    puts "Train on station: #{assigned_route[@train_pos_now]}" 
    puts "Enter 'next' for move train to next station or 'prev' for move train to previos station: "
    choice = gets.chomp
      if choice == "next"
          if @train_pos_now != -1
          @train_pos_now += 1
          puts "Location of train is #{ assigned_route[@train_pos_now]}"
          next_stat = assigned_route[@train_pos_now+1] #смотрим следующую станцию
          prev_stat = assigned_route[@train_pos_now-1] #смотрим предыдущую станцию
          if next_stat 
            puts "Next station is #{next_stat}"
            puts "Previous station is #{prev_stat}" 
          else
            puts "Train at the end of route!"
          end    
        end
        if choice == "prev"
          if @train_pos_now > 0 
            @train_pos_now -= 1
            puts "Location of train is #{ assigned_route[@train_pos_now]}"
            next_stat = assigned_route[@train_pos_now+1] #смотрим следующую станцию
            prev_stat = assigned_route[@train_pos_now-1] #смотрим предыдущую станцию
            puts "Next station is #{next_stat}" if next_stat
            puts "Previos station is #{prev_stat}" if train_pos_now > 0 
          else
            puts "Train at the start of route!"
          end    
        end
      end  
  end

  def carriage_add_to_train # для пункта 5 - добавляем вагон, методы создать вагон и добавить вагон описаны в трэйн (в нем сравнить)
    puts "Enter number of train to add carriage"
    train_number = gets.chomp
    train = find_train_number(train_number) # метод поиска поезда по номеру find_train_number, поезд к которому хотим добавить вагон
    if train.train_type == 'cargo' 
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
    train.carriage_del
    puts "Train #{number_train} has #{train.carriage_count} carriages"
  end  
     
  def find_train_number(number_train) # вспомогательный метод, часто
    @trains.find { |train| train.number == number_train }
  end
  
  def find_station(station_name) # ищем станцию по имени
    @stations.find { |station| station.name == station_name }
  end

    def set_routes_trains # для пункта 4 - назначаем маршрут поезду
      puts "Select route for assign to train: "
      puts @routes_list
      select_route = gets.chomp.to_i
      puts "For enter number of train: " 
      number_train = gets.chomp
      puts @routes_list[select_route] # из списка по имени маршрута отображаем выбранный маршрут (для более понятного представления пользователю) 
      @routes_trains[number_train] = @routes_list[select_route] # составляем хэш поезд: маршрут
      puts @routes_trains # итого имеем хэш - номер поезда: маршрут. Нужно добавить при обработке новой станции на маршруте поиск маршрута
      #теперь для пунка 7 надо вернуть сопоставление, и поставить поезд на 1 станцию маршрута
      @routes_list[select_route]
      assigned_route = @routes_trains[number_train] # присваем массиву маршрут поезда
      puts "Assigned route is #{assigned_route}" # проверяем
      @train_pos_now = 0 # устанавливаем переменную на первую станцию
      puts "Train on station: #{@train_pos_now}" 
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
      puts "0 - EXIT"
      choice = gets.chomp
      break if choice == "0"
      case 
        when choice == "1" # Создавать станции -----------------------------------
          create_new_station
        when choice == "2" #  Создавать поезда -----------------------------------
          create_new_train
        when choice == "3" #  Создавать маршруты и управлять станциями в нем (добавлять, удалять)
          create_change_route
        when choice == "4" #  Назначать маршрут поезду ---------------------------
          set_routes_trains #set_route_to_train
        when choice == "5" #  Добавлять вагоны к поезду --------------------------
          carriage_add_to_train     
        when choice == "6" #  Отцеплять вагоны от поезда -------------------------
          carriage_delete_from_train
        when choice == "7" #  Перемещать поезд по маршруту вперед и назад --------
          move_train_on_assigned_route
        when choice == "8" #  Просматривать список станций и список поездов на станции
        view_stations_routes_and_trains  
        end
      end  


  end
end

menu = MainMenu.new  
menu.list
