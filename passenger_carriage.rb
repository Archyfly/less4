require "./route.rb"
require "./carriage.rb"

class PassengerCarriage < Carriage # пассажирский вагон - потомок класса вагон
  attr_reader :places
  attr_accessor :occupy_places
  def initialize
    super
    @type_carriage = 'pass'
    @places = 100
    @occupy_places = 0
  end

  def change # вызываем приватный метод, позволяющий менять число мест
    change_places 
  end

  
  def occupy(place)
    if @occupy_places + place < @places
    @occupy_places = @occupy_places + place    
    else
      @occupy_places
    end
  end

private

  def change_places # метод, изменяющий число мест в вагоне. Написан ранее, когда предполагалось поделить на купе, плацкарт и общий вагон.
    @places = 72 
  end

end
#тест
=begin
vagon = PassengerCarriage.new
vagon.carriage_display_info
vagon.change
vagon.carriage_display_info
=end
