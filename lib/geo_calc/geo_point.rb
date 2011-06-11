require 'sugar-high/arguments'
require 'geo_calc/calc'
require 'geo_calc/extensions'

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
  include GeoCalc::Calc::All
  # Creates a point on the earth's surface at the supplied latitude / longitude
  # 
  # Constructor
  # - Numeric lat: latitude in numeric degrees
  # - Numeric lon: longitude in numeric degrees
  # - Numeric [rad=6371]: radius of earth if different value is required from standard 6,371km

  autoload :ClassMethods,   'geo_calc/geo_point/class_methods'
  autoload :Shared,         'geo_calc/geo_point/shared'
  autoload :CoreExtension,  'geo_calc/geo_point/core_extension'

  attr_reader   :lat, :lon  
  
  def initialize *args
    options = args.is_a?(GeoPoint) ? {} : args.last_option
    earth_radius_km = options[:radius]
    coord_mode = options[:mode]
    
    case args.size
    when 1
      create_from_one args
    when 2
      create_from_two *args
    else
      raise "GeoPoint must be initialized with either one or to arguments defining the (latitude, longitude) coordinate on the map"
    end
  end

  extend ClassMethods
  include Shared

  def coord_mode
    @coord_mode ||= GeoPoint.coord_mode
  end

  def earth_radius_km  
    @earth_radius_km ||= GeoPoint.earth_radius_km  # default
  end

  def lat= value 
    @lat = value.to_lat
  end

  def lon= value
    @lon = value.to_lng
  end

  (Symbol.lng_symbols - [:lon]).each do |sym|
    class_eval %{
      alias_method :#{sym}, :lon
      alias_method :#{sym}=, :lon=
    }
  end    
  alias_method :to_lng, :lng

  (Symbol.lat_symbols - [:lat]).each do |sym|
    class_eval %{
      alias_method :#{sym}, :lat
      alias_method :#{sym}=, :lat=
    }
  end
  alias_method :to_lat, :lat

  def [] key
    case key
    when Fixnum   
      raise ArgumentError, "Index must be 0 or 1" if !(0..1).cover?(key)
      to_a[key] 
    when String, Symbol
      send(key) if respond_to? key
    else
      raise ArgumentError, "Key must be a Fixnum (index) or a method name"  
    end    
  end

  alias_method :to_dms, :to_s

  def reverse_point!
    self.lat = lat * -1
    self.lng = lng * -1
    self    
  end

  def reverse_point
    self.dup.reverse_point!
  end

  def to_lat_lng
    [lat, lng]
  end

  def to_lng_lat
    to_lat_lng.reverse
  end

  def to_a
    send(:"to_#{coord_mode}")
  end
  
  protected

  include ::GeoCalc::NumericCheckExt

  def to_coords points
    points.send(:"to_#{coord_mode}")
  end
  
  def create_from_one args
    args = args.first
    create_from_two *to_coords(args)
  end
  
  def create_from_two lat, lon
    @lat    = lat.to_lat
    @lon    = lon.to_lng
  end  
end

