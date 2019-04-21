require "./route.rb"
require_relative "./carriage.rb"

class CargoCarriage < Carriage # грузовой вагон
  # cargo_type - тип платформа, цистерна, крытый (tank, platform, box)
  # filling - заполнение, полный или пустой 
  attr_accessor :filling

  def filling # пустой или заполненный
    self.filling = 1
  end
  
  def eco_danger # опасный груз или нет 
    eco_danger = 1
  end

end

cargo1 = CargoCarriage.new('tank', 1)
cargo1.eco_danger
cargo1.carriage_display_info

