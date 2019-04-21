require "./route.rb"
class Carriage # класс вагон
attr_accessor :type_carriage, :places
  
  def carriage_display_info
    puts "carriage type = #{@type_carriage}" # тип вагончика
    puts "carriage places = #{@places}" # места (для пассажирского - одно значение, для грузового - другое значение)
  end
end


