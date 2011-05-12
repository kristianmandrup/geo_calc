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

  def initializer lat, lon, rad = 6371
    rad ||= 6371  # earth's mean radius in km
    # only accept numbers or valid numeric strings
    @lat    = lat
    @lon    = lon
    @radius = rad
  end
end
