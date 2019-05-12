require "./route.rb"
require "./manufacturer.rb"

class Carriage # класс вагон
include Manufacturer
attr_accessor :type_carriage, :num, :occupied_places
  
  def initialize(num, free_places)
    @num = num
    @free_places = free_places # мест в вагоне
    @occupied_places = 0 # занятые места
  end
  
  def occupy_places(places) # занять количество мест из free_places
    @free_places = @free_places - places
    @occupied_places = @occupied_places + places
  end
  
  def occupied_places
    @occupied_places
  end

  def carriage_display_info
    puts "carriage type = #{@type_carriage}" # тип вагончика
    puts "carriage places = #{@free_places}" # места (для пассажирского - одно значение, для грузового - другое значение)
    puts "Free places after occupy  = #{@free_places}" # места (для пассажирского - одно значение, для грузового - другое значение)
    
  end

end

=begin
carri1 = Carriage.new(1, 20)
carri1.carriage_display_info
carri1.occupy_places(12)
#carri1.assign_man
carri1.carriage_display_info
=end
