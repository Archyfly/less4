require "./train.rb"
class PassTrain < Train
  def initialize(number)
    super
    @type = 'pass'
  end
end
