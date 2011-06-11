require 'geo_calc/geo_point/shared'

class GeoPoint
  module ClassMethods
    def earth_radius_km  
      @earth_radius_km ||= 6371
    end    

    def coord_mode  
      @coord_mode ||= :lat_lng
    end    
           
    include Shared
  end
end