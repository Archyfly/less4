require_relative './station.rb'
require_relative './route.rb'
require_relative './train'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './carriage'
require_relative './passenger_carriage'
require_relative './cargo_carriage'
require_relative './manufacturer'
require_relative './instance_counter'
# require_relative './validate'

class MainMenu
  include Manufacturer
  include InstanceCounter
  # include Validate

  attr_accessor :stations, :trains, :routes, :num_cargo_carriage, :num_pass_carriage

  # @@num_cargo_carriage = 0
  # @@num_pass_carriage = 0

  def initialize
    @stations = []  # save objects stations @stations << station
    @trains = []    # save objects trains @trains << new_train
    @routes = []    # save objects routes from new_route
    @num_cargo_carriage = 0
    @num_pass_carriage = 0
  end

  # create test data
  def create_test_stations
    # create stations
    @stations << Station.new('fir')
    @stations << Station.new('sec')
    @stations << Station.new('thr')
    @stations << Station.new('fou')
    @stations << Station.new('fif')
  end

  # create trains
  def create_test_trains
    @trains << @ps1 = PassTrain.new('165-ps')
    @trains << @cr1 = CargoTrain.new('77777')
    # assign manufacturer
    @cr1.man_assign = 'CargoFacture'
    @ps1.man_assign = 'PassMan'
  end

  # create cargo carriages
  def create_test_carriages
    @num_cargo_carriage += 1
    @carriage1 = CargoCarriage.new(@num_cargo_carriage, 250)
    @num_cargo_carriage += 1
    @carriage2 = CargoCarriage.new(@num_cargo_carriage, 230)
    @carriage1.occupy_places(132)
    @carriage2.occupy_places(178)
    @num_pass_carriage += 1
    @carriage3 = PassengerCarriage.new(@num_pass_carriage, 65)
    @num_pass_carriage += 1
    @carriage4 = PassengerCarriage.new(@num_pass_carriage, 70)
  end

  # add test carriages
  def add_test_carriages
    @cr1.carriage_add(@carriage1)
    @cr1.carriage_add(@carriage2)
    # create pass carriages
    @carriage3.occupy_places(18)
    @carriage4.occupy_places(17)
    # add carriages to pass train
    @ps1.carriage_add(@carriage3)
    @ps1.carriage_add(@carriage4)
  end

  # create new route
  def create_test_routes
    @routes << r1 = Route.new('fir', 'fif')
    r1.add_station_after('fir', 'sec')
    r1.add_station_after('sec', 'thr')
    r1.add_station_after('thr', 'fou')
  end

  def test_data
    create_test_stations
    create_test_trains
    create_test_carriages
    add_test_carriages
    create_test_routes
    puts 'Test data created.'
  end

  def find_train
    puts 'Enter number of train: '
    number_train = gets.chomp
    puts "Train found: #{Train.find(number_train)}"
  end

  # case 1
  def create_new_station
    begin
      puts 'Enter name of new station: '
      new_station_name = gets.chomp
      station = Station.new(new_station_name)
    rescue RuntimeError
      puts 'Enter CORRECT! station name (should be at least 3 symbols/digits)'
      retry
    end
    @stations << station
  end

  # case 8
  def view_stations_routes_and_trains
    @stations.each.with_index(1) { |station, i| puts "Station #{i} - #{station.station_name}" }
    @routes.each.with_index(1) { |route, i| puts "#{i} route - #{route.route_name} " }
    @trains.each.with_index(1) do |train, i|
      puts "#{i} - Train number #{train.number} is #{train.train_type}."
      puts "Train has #{train.carriage_count} carriages."
      puts " Manufacturer is #{train.man_assign}"
    end
  end

  def stations_all
    puts Station.all
  end

  # case 2
  def create_new_train
    begin
      puts 'Enter number of train. Format of number should be xxxxx or xxx-xx'
      number_train = gets.chomp
      puts 'Enter type of train (cargo or pass): '
      train_type = gets.chomp
      puts 'Enter Manufacturer of train : '
      manufacturer_name = gets.chomp
      if train_type == 'cargo'
        new_train = CargoTrain.new(number_train)
      elsif train_type == 'pass'
        new_train = PassTrain.new(number_train)
      else
        puts 'Unknown type of train'
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

  # case 3
  def create_route
    # view existing routes
    @routes.each_with_index { |route_list, i| puts "Existing route #{i + 1} is #{route_list.display_route}" } unless @routes.empty?
    puts 'Enter start station of route: '
    start_station = gets.chomp
    puts 'Enter last station of route: '
    end_station = gets.chomp
    new_route = Route.new(start_station, end_station)
    @routes << new_route
    puts "@routes = #{@routes}"
    puts "@routes.route_list = #{new_route.display_route}"
    puts new_route.start_station
    puts new_route.last_station
  end

  # case 5
  def change_route
    if !@routes.empty?
      @routes.each_with_index { |route_list, i| puts "Existing route #{i + 1} is #{route_list.display_route}" } unless @routes.empty?
      selected_route = select_route
      loop do
        puts ''
        puts "Type 'add' for add substation."
        puts "Type 'del' for delete substation"
        puts "Type 'display' for display full route"
        puts "Type 'exit' for return to MainMenu"
        choice_route = gets.chomp
        break if choice_route == 'exit'
        case choice_route
        when 'add' then add_station_in_route
        when 'del' then del_station_in_route
        when 'display' then @routes.each_with_index { |route, i| puts "Route #{i + 1} - #{route.route_list}" }
        end
      end
    else
      puts 'List of routes is empty, please create route first'
    end
  end

  def add_station_in_route
    print 'Enter name of station before: '
    before_station = gets.chomp
    print 'Enter substation : '
    substation = gets.chomp
    selected_route.add_station_after(before_station, substation)
  rescue StandardError => err # error about existing station
    error_message err
    retry
  end

  def del_station_in_route
    puts selected_route.display_route
    print 'Enter name of station to delete: '
    del_station = gets.chomp
    selected_route.del_station_from_route(del_station)
  rescue StandardError => err # # error about existing station
    error_message err
    retry
  end

  # case 4
  def set_routes_trains
    selected_train = select_train
    puts 'Enter route name (first station-last station) for assign to train: '
    @routes.each_with_index { |route, i| puts "Route #{i + 1} - #{route.route_name}" }
    selected_route = select_route
    puts "Selected train = #{selected_train}"
    puts "Selected route = #{selected_route}"

    selected_train.train_on_route(selected_train, selected_route.route_list)

    set_stat = find_station(selected_train.position[0]) # train set at position 0

    set_stat.train_arrived(selected_train) # train arrived on first station. (for array train_on_station)

    puts "route (position list) of train is #{selected_train.position}"
    puts "position start = #{selected_train.position[0]}"
    puts "position end = #{selected_train.position[-1]}"
  end

  def move_train_on_route
    selected_train = select_train
    # loop do
    puts "Train #{selected_train.number} now on station #{selected_train.position[selected_train.train_pos_now]}"
    puts "Enter 'next' - move train to next station."
    puts "Enter 'prev' for move train to previos station"
    puts "Enter 'stop' for stop move: "
    choice_move = gets.chomp
    # break if choice_move == "stop"
    if choice_move == 'next' && !selected_train.position[selected_train.train_pos_now + 1].nil?
      selected_train.train_go_to_next(number_train, selected_train.position)
    end

    selected_train.train_go_to_previous(number_train, selected_train.position) if choice_move == 'prev' && selected_train.train_pos_now > 0

    puts "Train #{selected_train.number} now on station #{selected_train.position[selected_train.train_pos_now]}"
    if selected_train.position[selected_train.train_pos_now + 1].nil?
      puts 'Train on last station'
      puts "Previos station is #{selected_train.position[selected_train.train_pos_now - 1]}"
    elsif  selected_train.train_pos_now.zero?
      puts 'Train on start station'
      puts "Next station is #{selected_train.position[selected_train.train_pos_now + 1]}"
    else
      puts "Next station is #{selected_train.position[selected_train.train_pos_now + 1]}"
      puts "Previos station is #{selected_train.position[selected_train.train_pos_now - 1]}"
    end
  end

  # case 6 - add carriage, methods from Train
  def carriage_add_to_train
    select_train
    if selected_train.speed != 0
      puts "Carriage cannot be added! Speed = #{@speed}"
    elsif selected_train.type == 'cargo'
      puts 'Enter volume of carriage'
      vol = gets.chomp.to_i
      @num_cargo_carriage += 1
      carriage = CargoCarriage.new(@num_cargo_carriage, vol)
      selected_train.carriage_add(carriage)
      puts "Train #{selected_train.train_number(train)} has #{selected_train.carriage_count} carriages"
    elsif selected_train.type == 'pass'
      puts 'Enter count of places in carriage'
      place = gets.chomp.to_i
      @num_pass_carriage += 1
      carriage = PassengerCarriage.new(@num_pass_carriage, place)
      selected_train.carriage_add(carriage)
      puts "Train #{selected_train.train_number(train)} has #{selected_train.carriage_count} carriages"
    else
      puts 'Train not found!'
    end
  end

  # case 7
  def carriage_delete_from_train
    select_train
    if selected_train.speed != 0
      puts "Train on route. Speed = #{selected_train.speed}"
    elsif selected_train.carriage_count > 0
      selected_train.carriage_del
      puts "Carriage has been deleted. Train has #{selected_train.carriage_count} railway_carriages now."
    else
      puts "Carriage hasn't railway_carriages."
    end
  end

  # case 12 (demonstrates work through blocks.)
  def carriage_view_info
    @trains.each do |train|
      puts "Train #{train.train_number(train)} has this carriages: "
      if train.type == 'cargo'
        train.each_carriage do |carriage|
          puts "Carriage num: #{carriage.num}."
          puts "Carriage has #{carriage.places} volume and #{carriage.occupied_places} occupied volume"
        end
      end
      next unless train.type == 'pass'
      train.each_carriage do |carriage|
        puts "Carriage num: #{carriage.num}."
        puts " Carriage has #{carriage.places} places and #{carriage.occupied_places} occupied places"
      end
    end
  end

  def carriage_occupy_places
    carriage_view_info
    selected_train = select_train
    puts 'Select number of carriage to occupy volume/places in carriages:'
    carriage_index = gets.chomp.to_i
    selected_carriage = selected_train.carriages_in_train[carriage_index - 1]

    if selected_train.type == 'cargo'
      puts 'Enter volume to occupy carriage:'
      volume = gets.chomp.to_i
      if volume > selected_carriage.places - selected_carriage.occupied_places
        puts 'Not enough free volume in this carriage.'
        puts "Selected carriage has #{selected_carriage.free_places} free volume"
      else
        selected_carriage.occupy_places(volume)
      end
    end
    if selected_train.type == 'pass'
      if selected_carriage.occupied_places == selected_carriage.places
        puts 'Carriage full. Select another carriage'
      else
        selected_carriage.occupy_places(1)
      end
    end
  end

  # case 13
  def view_trains_on_station
    @stations.each do |station|
      puts "Station #{station.station_name} has this trains: "
      station.trains_view do |train|
        puts "Train number #{train.number} type: #{train.type} with #{train.carriages_in_train.size} carriages."
      end
    end
  end

  # method for search train by number
  # (user enter the number of train - find object train in @trains)
  def find_train_number(number_train)
    @trains.find { |train| train.number == number_train }
    # puts @trains.find { |train| train.number == number_train }
  end

  def find_station(station_name)
    @stations.find { |station| station.station_name == station_name }
  end

  def find_route_by_name(route_name)
    @routes.find { |route| route.route_name == route_name }
  end

  def select_train
    puts 'Select number of train:'
    train = gets.chomp
    selected_train = find_train_number(train)
  end

  def select_route
    puts 'Select route name (first station-last station)'
    assign_route = gets.chomp
    selected_route = find_route_by_name(assign_route)
  end

  # list for case
  def list
    puts '===================Programm Railway Manage================='
    puts '------Enter your choice from MENU: --------'
    puts '1 - create the station'
    puts '2 - create the train'
    puts '3 - create the route'
    puts '4 - set route to train'
    puts '5 - change route'
    puts '6 - add carriages to train'
    puts '7 - delete carriages of train'
    puts '8 - move train on route'
    puts '9 - display stations and trains on station'
    puts '10 - display stations objects'
    puts '11 - find train by number'
    puts '12 - View carriages in trains'
    puts '13 - View trains on stations'
    puts '14 - Occupy carriage'
    puts '15 - create test data - trains, carriages, stations and routes'
    puts '0 - EXIT'
    puts '=========================================================='
  end

  def user(choice)
    case choice
    when '1' then create_new_station
    when '2' then create_new_train
    when '3' then create_route
    when '4' then set_routes_trains # set_route_to_train
    when '5' then change_route
    when '6' then carriage_add_to_train
    when '7' then carriage_delete_from_train
    when '8' then move_train_on_route
    when '9' then view_stations_routes_and_trains
    when '10' then stations_all
    when '11' then find_train
    when '12' then carriage_view_info
    when '13' then view_trains_on_station
    when '14' then carriage_occupy_places
    when '15' then test_data
    end
  end

  def view_menu
    loop do
      list
      choice = gets.chomp
      break if choice.nil?
      user(choice)
    end
  end

  def error_message(err)
    puts "Error: #{err.message}"
  end
end

menu = MainMenu.new
menu.view_menu
