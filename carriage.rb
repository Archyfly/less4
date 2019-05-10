require "./route.rb"
require "./manufacturer.rb"

class Carriage # класс вагон
include Manufacturer
attr_accessor :type_carriage, :places, :volume
  
  def carriage_display_info
    puts "carriage type = #{@type_carriage}" # тип вагончика
    puts "carriage places = #{@places}" # места (для пассажирского - одно значение, для грузового - другое значение)
    #puts "Manufacturer = #{man_name}"
  end
end

=begin
carri1 = Carriage.new
carri1.assign_man
carri1.carriage_display_info
=end
