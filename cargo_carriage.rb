require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон
 
  def initialize
    super
    @type_carriage = 'cargo'
    @places = 20
   end

private

  def change_places
    @places = 40 
  end

end

cargo1 = CargoCarriage.new('tank', 1)
cargo1.eco_danger
cargo1.carriage_display_info

