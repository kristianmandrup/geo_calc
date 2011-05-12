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

  def initializer *args, rad = 6371
    case args.size
    when 1
      create_from_one *args, rad
    when 2
      create_from_two *args, rad
    else
      raise "GeoPoint must be initialized with either one or to arguments defining the (latitude, longitude) coordinate on the map"
    end
  end
  
  protected
  
  def create_from_one points, rad = 6371
    create_from_two *extract_lat_lng(points), rad
  end
  
  def create_from_two lat, lon, rad = 6371  
    rad ||= 6371  # earth's mean radius in km
    # only accept numbers or valid numeric strings
    @lat    = lat.to_lat
    @lon    = lon.to_lng
    @radius = rad
  end
  
  def extract_lat_lng points
    case points
    when String
      points.to_lat_lng 
    when Array
      points.to_lat_lng
    when Hash
    end
  end
end

module NumericLatLngExt
  def to_lat { self }
  def to_lng { self }
end

class Fixnum
  include NumericLatLngExt
end

class Float
  include NumericLatLngExt
end

class Array
  def to_lat_lng
    raise "Array must contain at least two elements to be converted to latitude and longitude" if !size >= 2
    [first.to_lat, self[1].to_lng]
  end
end

class Hash
  def to_lat_lng
    [self.to_lat, self.to_lng]
  end
  
  def to_lat
    [:lat, :latitude].each do |key|
      return self[key] if self.respond_to? key
    end
    raise "Hash must contain either of the keys: [:lat, :latitude] to be converted to a latitude"
  end

  def to_lng
    [:lon, :long, :lng, :longitude].each do |key|
      return self[key] if self.respond_to? key
    end
    raise "Hash must contain either of the keys: [:lon, :long, :lng, :longitude] to be converted to a longitude"
  end
end  

class String
  def to_lat_lng  
    self.split(',').to_lat_lng
  end
  
  def to_lat
  end

  def to_lng
  end
end

