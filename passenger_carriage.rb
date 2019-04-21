require "./route.rb"
require "./carriage.rb"

class PassengerCarriage < Carriage # пассажирский вагон - потомок класса вагон
  
  def initialize
    super
    @type_carriage = 'pass'
    @places = 46
  end

  def change # вызываем приватный метод, позволяющий менять число мест
    change_places 
  end

private

  def change_places
    @places = 72 
  end

end
#тест
#=begin
vagon = PassengerCarriage.new
vagon.carriage_display_info
vagon.change
vagon.carriage_display_info
#=end
