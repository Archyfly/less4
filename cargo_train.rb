require "./train.rb"
class CargoTrain < Train # определяем потомка Грузовой поезд
  
  def initialize(number)
    super
    @train_type = 'cargo'
  end
end
