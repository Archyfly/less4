module Manufacturer
  #attr_accessor :manufacturer
  attr_accessor :man_name
  def manuf_name(man)
    self.man_name = man
  end

  def manuf_name_display
    puts self.man_name
  end

  def assign_man
   man_assign = gets.chomp
   self.manuf_name(man_assign)
  #protected
end

end

