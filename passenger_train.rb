require_relative './train'
# subclass PassTrain
class PassTrain < Train
  # include Manufacturer
  attr_reader :type

  def initialize(number)
    super
    @type = 'pass'
  end
end

# train1 = PassTrain.new(12)
