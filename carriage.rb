require "./route.rb"
class Carriage # класс вагон
attr_accessor :type_carriage, :places
  def carriage_display_info
    puts "carriage type = #{@type_carriage}" # тип вагончика
    puts "carriage places = #{@places}" # места (для пассажирского - одно значение, для грузового - другое значение)
  end
end

class PassengerCarriage < Carriage # пассажирский вагон - потомок класса вагон
  def initialize
    @type_carriage = 'pass'
    @places = 46
   end
end

class CargoCarriage < Carriage # грузовой вагон - потомок класса вагон
  def initialize
    @type_carriage = 'cargo'
    @places = 30 
   end
end


#тест
=begin
cargo1 = CargoCarriage.new
cargo1.carriage_display_info
cargo1.places


pass1 = PassengerCarriage.new
pass1.carriage_display_info
pass1.places
=end
