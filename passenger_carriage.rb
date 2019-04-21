require "./route.rb"
class PassengerCarriage # пассажирский вагон
# тип плацкарт, купэ, сидячий
# количество мест
  def pass
    50  
  end
  def plackart
    80
  end



  def kupe
    32  
  end
end

#тест
=begin
vagon = PassengerCarriage.new()
puts vagon.pass
puts vagon.plackart
puts vagon.kupe
=end
