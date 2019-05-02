require './manufacturer.rb'
require './instance_counter.rb'
class Train
  
  NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i
  TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/

  include Manufacturer
  include InstanceCounter
  
  @@existing_trains = {} # сюда записываем созданные экземпляры поездов
  
  attr_accessor :number, :carriage_count, :carriages_in_train, :speed, :train_type, :type_carriage
  
  def self.find(number_train)
    @@existing_trains[number_train]
  end

  def initialize(number, speed = 0, train_pos_now = 'Depo')
    @number = number # Номер поезда
    @train_type = train_type # Тип поезда
    validate!
    @speed = speed # Скорость поезда
    @position = [] # для движения по маршруту
    @train_pos_now = train_pos_now # хранение текущей позиции
    @carriages_in_train = [] # массив получаемый из вагончиков
    @carriage_count = 0 # более понятная переменная для числа вагончиков
    @type_carriage = type_carriage # тип вагончика. 
    @train_pos_now = train_pos_now # хранение текущей позиции
    @@existing_trains[number] = self # отправка экземпляра
    register_instance
  end
 
  #def display_train_info# общие параметры отображения class Train 
  #  puts "Train #{@number}. Type of train: #{@train_type}. Train has speed #{@speed}"
  #end

  def brake # общее торможение поезда
    @speed = 0
  #	puts "Train stopped!"
  end

  def train_number(number)
    @number
  end

  def speed_up(speed_up) # общее набор скорости
  	@speed += speed_up
  end

  def carriage_add(carriage) # получаем тип вагона и количество мест
    #if @speed != 0 
  #    puts "Carriage cannot be added! Speed = #{@speed}"
    #else
    #  puts carriage 
      @carriages_in_train << carriage.type_carriage # передаем в хэш значения вагона тип => наполненость
    #  puts "Carriage = #{carriage.type_carriage} "
  #    puts "#{carriage.type_carriage} carriage with has been added with  places = #{carriage.places}."
      @carriage_count += 1 
    #  puts @carriage_count #проверка что число добавлено
    
  end

  def position 
    @position
  end
  
  def carriage_del 
    @carriage_count = @carriage_count - 1
  end

  def train_on_route(number, station) # получаем маршрут - массив из route
    station.each { |stat| @position << stat } # переписываем маршрут в position для дальнейшей работы
    #puts "Train #{@number} arrived at #{@position[0]}"
    self.brake
    @train_pos_now = 0
    #puts "position of train is #{ @position[@train_pos_now]}" # фиксируем точку маршрута
    @position
  end
  
  def train_go_to_next(number, station) #поезд перемещается на следующую станцию, выводим куда пеерместился.
    if @position[@train_pos_now] != @position[-1]
      @train_pos_now += 1
      puts "Location of train is #{ @position[@train_pos_now]}"
      next_stat = @position[@train_pos_now+1] #смотрим следующую станцию
      prev_stat = @position[@train_pos_now-1] #смотрим предыдущую станцию
      puts "Next station is #{next_stat}"
      puts "Previous station is #{prev_stat}"
    else 
      puts "Train on last station!"
    end
  end
    
  def train_go_to_previous(number, station) #поезд перемещается на предыдущую станцию, выводим куда пеерместился.
    if @train_pos_now > 0
      @train_pos_now -= 1
      puts "Location of train is  #{ @position[@train_pos_now]}"
      next_stat = @position[@train_pos_now+1] #смотрим следующую станцию
      prev_stat = @position[@train_pos_now-1] #смотрим предыдущую станцию
      puts "Next station is #{next_stat}"
      puts "Previous station is #{prev_stat}"
    else 
      puts "Train at the start of route!"
    end
  end


  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
      raise "Number can't be nil" if @number.nil?
      raise "Number should be at least 6 symbols" if @number.to_s.size < 5 
      raise "Number has invalid format" if @number !~ NUMBER_FORMAT
    true
  end
end



#train1 = Train.new('122wwww')
#Train.find(12)



