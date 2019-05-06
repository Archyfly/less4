#require "./cl_station"
require_relative './instance_counter'

class Route

  include InstanceCounter
  attr_accessor :substation, :route_list, :route_name

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @route_list = [start_station, end_station]
    register_instance
  end

  def display_route
    "route = #{@route_list}"
     @route_list
  end

  def start_station
    @route_list[0]
  end

  def last_station
    @route_list[-1]
  end

  def add_station_after(substation_before, substation)
    raise "Station #{substation} exist!" if @route_list.include?(substation)
    index_before = @route_list.index(substation_before)
    @route_list.insert(index_before+1, substation)
  end

  def del_station_from_route(substation)
    raise "You can't remove this station." if substation == @route_list[-1] || substation == @route_list[0]
    @route_list.delete(substation)
  end

  def route_name # для определения маршрута по имени в формате first-last
    #@name = route_list.first.name + "-" + route_list.last
    @name = start_station.station_name + "-" + last_station.station_name
  end

end

