require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон
 
  def initialize
    super
    @type_carriage = 'cargo'
    @places = 20
  end

  def change # вызываем приватный метод, позволяющий менять число мест
    change_places 
  end

private

  def change_places
    @places = 40 
  end

end

cargo1 = CargoCarriage.new
cargo1.carriage_display_info
cargo1.change
cargo1.carriage_display_info
