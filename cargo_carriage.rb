require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон

attr_reader :volume
attr_accessor :occupy_volume 

  def initialize
    super
    @type_carriage = 'cargo'
    @volume = 20
    @occupy_volume = 0
  end

  def change # вызываем приватный метод, позволяющий менять число мест
    change_volume! 
  end

  def occupy
    if @occupy_volume < @volume
      @occupy_volume += 1   
    else
      @occupy_volume
    end
  end

private

  def change_volume!
    @volume = 40 
  end

end

=begin
cargo1 = CargoCarriage.new
cargo1.carriage_display_info
cargo1.change
cargo1.carriage_display_info
=end
