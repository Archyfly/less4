require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон

attr_reader :volume
attr_accessor :occupy_volume 

  def initialize
    super
    @type_carriage = 'cargo'
    @volume = 350
    @occupy_volume = 0
  end

  def change # вызываем приватный метод, позволяющий менять обьем (не пригодился)
    change_volume! 
  end

  def occupy(vol) # занятие переданного обьема vol
    if @occupy_volume + vol < @volume
      @occupy_volume = @occupy_volume + vol   
    else
      puts "cargo carriage hasn't enough volume!"
    end
  end

private

  def change_volume!
    @volume = 200 
  end

end

=begin
cargo1 = CargoCarriage.new
cargo1.carriage_display_info
cargo1.change
cargo1.carriage_display_info
=end
