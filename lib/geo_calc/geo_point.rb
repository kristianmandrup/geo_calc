require 'geo_calc/calculations'

 #  Sample usage:                                                                                 
 #    p1 = GeoPoint.new(51.5136, -0.0983)                                                      
 #    p2 = GeoPoint.new(51.4778, -0.0015)                                                      
 #    dist = p1.distance_to(p2)          # in km                                             
 #    brng = p1.bearing_to(p2)           # in degrees clockwise from north                   
 #    ... etc                                                                                     
 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #                                                                                                
 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #  Note that minimal error checking is performed in this example code!                           
 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

class GeoPoint
  include GeoCalc
  # Creates a point on the earth's surface at the supplied latitude / longitude
  # 
  # Constructor
  # - Numeric lat: latitude in numeric degrees
  # - Numeric lon: longitude in numeric degrees
  # - Numeric [rad=6371]: radius of earth if different value is required from standard 6,371km

  attr_reader :lat, :lon, :unit, :radius
  
  (Symbol.lng_symbols - [:lon]).each do |sym|
    class_eval %{
      alias_method :#{sym}, :lon
    }
  end    

  (Symbol.lat_symbols - [:lat]).each do |sym|
    class_eval %{
      alias_method :#{sym}, :lat
    }
  end    


  def initialize *args
    rad = args.delete(args.size) if is_numeric?(args.last) && args.last.is_between?(6350, 6380)
    rad ||= 6371 # default
    case args.size
    when 1
      create_from_one *args, rad
    when 2
      create_from_two *args, rad
    else
      raise "GeoPoint must be initialized with either one or to arguments defining the (latitude, longitude) coordinate on the map"
    end
  end

  def to_arr
    a = [lat, lng]
    a.reverse if reverse_arr?
  end

  def reverse_arr?
    @reverse_arr
  end

  def reverse_arr!
    @reverse_arr = true
  end

  def normal_arr!
    @reverse_arr = false
  end
  
  protected

  include NumericCheckExt
  
  def create_from_one points, rad = 6371
    create_from_two *points.to_lat_lng, rad
  end
  
  def create_from_two lat, lon, rad = 6371  
    rad ||= 6371  # earth's mean radius in km
    @lat    = lat.to_lat
    @lon    = lon.to_lng
    @radius = rad
    @unit = :degrees
  end  
end

