require "./route.rb"
require "./carriage.rb"

class PassengerCarriage < Carriage # пассажирский вагон - потомок класса вагон
  
  def initialize
    super
    @type_carriage = 'pass'
    @places = 46
   end

private

  def change_places
    @places = 72 
  end

end
#тест
=begin
vagon = PassengerCarriage.new()
puts vagon.pass
puts vagon.plackart
puts vagon.kupe
=end
