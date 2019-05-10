require "./train.rb"
class CargoTrain < Train # определяем потомка Грузовой поезд
  
  attr_reader :type
  
  def initialize(number)
    super
    @type = 'cargo'
  end
end
