module Manufacturer

attr_accessor :man_assign

  def man_assign(manufacturer_name)
    @man_assign = manufacturer_name
  end
 
  def manufacturer_name_display
    puts "fm Manufacturer is #{@man_assign}"
  end

end

class Man
  include Manufacturer
end

=begin
  
manufacturer2 = Man.new
manufacturer2.man_assign('Loko')
#manufacturer1 = Man.new

manufacturer2.manufacturer_name_display
#manufacturer2.manufacturer_name_display
=end
