require './manufacturer.rb'
require './instance_counter.rb'
class Train
  
  NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i
  TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/

  include Manufacturer
  include InstanceCounter
  
  @@existing_trains = {} # сюда записываем созданные экземпляры поездов
  
  attr_accessor :number, :carriage_count, :carriages_in_train, :speed, :train_type, :type_carriage
  attr_reader :train_pos_now, :train_type

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
    if @speed != 0 
      puts "Carriage cannot be added! Speed = #{@speed}"
    else
      @carriages_in_train << carriage # передаем в массив значения вагона тип => наполненость
      @carriage_count += 1 
    end
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
    @train_pos_now += 1
    #puts "station: #{station}"
    #self.position[train_pos_now]
    #puts "@train_pos_now += 1 = #{ @train_pos_now}"
    #puts "@position[train_pos_now] = #{@position[@train_pos_now]}"
  end
    
  def train_go_to_previous(number, station) #поезд перемещается на предыдущую станцию, выводим куда пеерместился.
    @train_pos_now -= 1
    #puts "station: #{station}"
    #self.position[train_pos_now]
    #puts "@train_pos_now -= 1 = #{ @train_pos_now}"
    #puts "@position[train_pos_now] = #{@position[@train_pos_now]}"
  end
  
  def carriages_in_train
    @carriages_in_train
  end

  def valid?
    validate!
  rescue
    false
  end

  def carriages_view(train) # блок проходит по вагонам и смотрит тип и место в вагоне
    @carriages_in_train.each.with_index(1) do |carriage, i| 
      puts "Type of carriage #{carriage.type_carriage}. " 
      if carriage.type_carriage == 'pass'
         puts "Carriage #{i} has #{carriage.places} with #{carriage.occupy_places} occupied places"
      elsif carriage.type_carriage == 'cargo'
        puts "Carriage #{i} has #{carriage.volume} volume with #{carriage.occupy_volume} occupied volume"
      else
      puts "Train #{train_number(train)} hasn't carriages"      
      end
    end  
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



