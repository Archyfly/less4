require './route.rb'
require './manufacturer.rb'

# define class Carriage
class Carriage
  include Manufacturer
  attr_accessor :type_carriage, :num, :places
  attr_reader :occupied_places

  def initialize(num, places)
    @num = num
    @places = places
    @occupied_places = 0
  end

  def occupy_places(n)
    # @places = @places - places
    @occupied_places += n if @occupied_places + n <= @places
  end

  def free_places
    @places - @occupied_places
  end

  def carriage_display_info
    puts "carriage type = #{@type_carriage}"
    puts "carriage places = #{@places}"
    puts "Free places after occupy  = #{free_places}"
  end
end

# carri1 = Carriage.new(1, 20)
# carri1.carriage_display_info
# carri1.occupy_places(12)
# carri1.assign_man
# carri1.carriage_display_info
