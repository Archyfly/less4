require "./train.rb"
class PassTrain < Train
  #include Manufacturer
  def initialize(number)
    super
    @train_type = 'pass'
  end

end

#train1 = PassTrain.new(12)
