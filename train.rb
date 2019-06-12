require './manufacturer.rb'
require './instance_counter.rb'
require './validation.rb'

class Train
  NUMBER_FORMAT = /^\w{3}\-?\w{2}$/i.freeze
  TYPE_TRAIN_FORMAT = /(?i)(\W|^)(pass|cargo)(\W|$)/.freeze

  include Manufacturer
  include InstanceCounter
  include Validation
  # write created trains
  @@existing_trains = {}

  attr_accessor :number, :carriage_count, :carriages_in_train,
                :speed, :train_type, :type_carriage

  attr_reader :train_pos_now

  validate :number, :format, NUMBER_FORMAT 

  def self.find(number_train)
    @@existing_trains[number_train]
  end

  def initialize(number, speed = 0, train_pos_now = 'Depo')
    @number = number
    @train_type = train_type
    validate!
    @speed = speed
    @position = []
    @train_pos_now = train_pos_now
    @carriages_in_train = []
    @carriage_count = 0
    @type_carriage = type_carriage
    @@existing_trains[number] = self
    register_instance
  end

  # train brake
  def brake
    @speed = 0
  end

  def train_number(_number)
    @number
  end

  def speed_up(speed_up)
    @speed += speed_up
  end

  # add carriage to train
  def carriage_add(carriage)
    if @speed != 0
      puts "Carriage cannot be added! Speed = #{@speed}"
    else
      @carriages_in_train << carriage # create array of carriages
      @carriage_count += 1
    end
  end

  attr_reader :position

  def carriage_del
    @carriage_count -= 1
  end

  def train_on_route(_number, station)
    station.each { |stat| @position << stat } # send route to position for work
    brake
    @train_pos_now = 0
    @position
  end

  def train_go_to_next(_number, _station)
    @train_pos_now += 1
    # puts "station: #{station}"
    # self.position[train_pos_now]
    # puts "@train_pos_now += 1 = #{ @train_pos_now}"
    # puts "@position[train_pos_now] = #{@position[@train_pos_now]}"
  end

  def train_go_to_previous(_number, _station)
    @train_pos_now -= 1
    # puts "station: #{station}"
    # self.position[train_pos_now]
    # puts "@train_pos_now -= 1 = #{ @train_pos_now}"
    # puts "@position[train_pos_now] = #{@position[@train_pos_now]}"
  end

  # view carriages from carrige_in_train
  def each_carriage
    @carriages_in_train.each { |carriage| yield(carriage) } if block_given?
  end

  
  #def valid?
  #  validate!
  #rescue StandardError
  #  false
  #end

  #protected

  #def validate!
  #  raise "Number can't be nil" if @number.nil?
  #  raise 'Number should be at least 6 symbols' if @number.to_s.size < 5
  #  raise 'Number has invalid format' if @number !~ NUMBER_FORMAT

  #  true
  #end
  end
