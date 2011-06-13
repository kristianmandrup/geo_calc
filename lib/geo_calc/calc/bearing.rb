module GeoCalc
  module Bearing
    def bearing_to point
      GeoCalc::Calc::Bearing.bearing_to self, point
    end

    # Returns the (initial) bearing from this point to the supplied point, in degrees
    #   see http:#williams.best.vwh.net/avform.htm#Crs
    # 
    # - Point point: Latitude/longitude of destination point
    # 
    # Returns -  Numeric: Initial bearing in degrees from North

    def self.bearing_to base_point, point
      lat1 = base_point.lat.to_rad
      lat2 = point.lat.to_rad
      dlon = (point.lon - base_point.lon).to_rad

      y = Math.sin(dlon) * Math.cos(lat2)
      x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dlon)
      bearing = Math.atan2(y, x)

      (bearing.to_deg + 360) % 360
    end

    def final_bearing_to point
      GeoCalc::Calc::Bearing.final_bearing_to self, point
    end

    # Returns final bearing arriving at supplied destination point from this point; the final bearing 
    # will differ from the initial bearing by varying degrees according to distance and latitude
    # 
    # - GeoPoint point: Latitude/longitude of destination point
    #
    # Returns Numeric: Final bearing in degrees from North

    def self.final_bearing_to base_point, point
      # get initial bearing from supplied point back to this point...
      lat1 = point.lat.to_rad
      lat2 = base_point.lat.to_rad
      dlon = (base_point.lon - point.lon).to_rad

      y = Math.sin(dlon) * Math.cos(lat2)
      x = Math.cos(lat1)*Math.sin(lat2) - Math.sin(lat1)*Math.cos(lat2)*Math.cos(dlon)
      bearing = Math.atan2(y, x)

      # ... & reverse it by adding 180°
      (bearing.to_deg+180) % 360
    end 
  end
end
