require './route.rb'
require './carriage.rb'

# define subclass passenger carriage
class PassengerCarriage < Carriage
  attr_reader :num, :places, :occupied_places

  def initialize(num, places)
    super
    @type_carriage = 'pass'
  end
end

# vagon = PassengerCarriage.new(1, 65)
# vagon.carriage_display_info
# vagon.occupy_places(1)
# vagon.carriage_display_info
