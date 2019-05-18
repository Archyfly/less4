require './train.rb'
# define subclass cargo train
class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = 'cargo'
  end
end
