require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон

attr_reader :num, :free_places, :occupied_places

  def initialize(num, free_places)
    super
    @type_carriage = 'cargo'
    @occupied_places = 0
  end
  
end

=begin
cargo1 = CargoCarriage.new(1, 13)
cargo1.carriage_display_info
cargo1.occupy_places(2)
cargo1.carriage_display_info
=end

