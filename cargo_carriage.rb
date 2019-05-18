require './route.rb'
require_relative './carriage.rb'

# define subclass cargo carriage
class CargoCarriage < Carriage
  attr_reader :num, :places, :occupied_places

  def initialize(num, places)
    super
    @type_carriage = 'cargo'
  end
end

# cargo1 = CargoCarriage.new(1, 13)
# cargo1.carriage_display_info
# cargo1.occupy_places(2)
# cargo1.carriage_display_info
