#require "./cl_station"
class Route
  attr_accessor :substation, :route_list, :route_name

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @route_list = [start_station, end_station]
  end

  def add_station_after(substation_before, substation)
    index_before = @route_list.index(substation_before)
    @route_list.insert(index_before+1, substation)
  end

  def del_station_from_route(substation)
    @route_list.delete(substation)
  end

  def display
    "route = #{@route_list}"
    puts "route = #{@route_list}"
    @route_list
  end

  def start_station
    @route_list[0]
  end

  def last_station
    @route_list[-1]
  end

  def route_name(route_list)
    @route_name = route_name
  end

  def name # для определения маршрута по имени в формате first-last
    @name = route_list.first + "-" + route_list.last
    puts "name = #{@name}"
  end

end
=begin
route1 = Route.new('Irkutsk', 'Moscow')
route1.display
route1.add_station_after('Irkutsk', 'Yurga')
route1.display
route1.add_station_after('Yurga', 'Novosib')
route1.display
route1.add_station_after('Novosib', 'Kazan')
route1.display
route1.del_station_from_route('Kazan')
route1.display
route1.name
=end
