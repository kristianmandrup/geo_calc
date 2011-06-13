module GeoCalc
  module Midpoint
    def midpoint_to point
      GeoCalc::Calc::Midpoint.midpoint_to self, point
    end

    # Returns the midpoint between this point and the supplied point.
    # see(http:#mathforum.org/library/drmath/view/51822.html for derivation)
    # 
    # @param [GeoPoint] base_point: Starting point (latitude, longitude)
    # @param [GeoPoint] point: Destination point (latitude, longitude)
    # @return [Array] Midpoint between this point and the supplied point
    #
    def self.midpoint_to base_point, point
      lat1 = base_point.lat.to_rad
      lon1 = base_point.lon.to_rad;
      lat2 = point.lat.to_rad
      dlon = (point.lon - base_point.lon).to_rad

      bx = Math.cos(lat2) * Math.cos(dlon)
      by = Math.cos(lat2) * Math.sin(dlon)

      lat3 = Math.atan2(Math.sin(lat1)+Math.sin(lat2), Math.sqrt( (Math.cos(lat1)+bx)*(Math.cos(lat1)+bx) + by*by) )

      lon3 = lon1 + Math.atan2(by, Math.cos(lat1) + bx)

      [lat3.to_deg, lon3.to_deg]
      # GeoPoint.new 
    end    
  end
end
