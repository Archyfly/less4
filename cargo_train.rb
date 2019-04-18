require "./train.rb"
class CargoTrain < Train # определяем потомка Грузовой поезд
  def initialize(number)
    super
    @type = 'cargo'
  end
end
