module GeoCalc
  module Destination
    def destination_point brng, dist
      GeoCalc::Destination.destination_point self, brng, dist
    end

    # Returns the destination point from this point having travelled the given distance (in km) on the 
    # given initial bearing (bearing may vary before destination is reached)
    # 
    # see(http:#williams.best.vwh.net/avform.htm#LL)
    # 
    # @param [Numeric] Initial bearing in degrees
    # @param [Numeric] Distance in km
    # @return [Array] Destination point

    def self.destination_point base_point, brng, dist
      dist = dist / base_point.earth_radius_km  # convert dist to angular distance in radians
      brng = brng.to_rad 
      lat1 = base_point.lat.to_rad
      lon1 = base_point.lon.to_rad

      lat2 = Math.asin( Math.sin(lat1) * Math.cos(dist) + Math.cos(lat1) * Math.sin(dist) * Math.cos(brng) )
      lon2 = lon1 + Math.atan2(Math.sin(brng) * Math.sin(dist) * Math.cos(lat1), Math.cos(dist) - Math.sin(lat1) * Math.sin(lat2))

      lon2 = (lon2 + 3*Math::PI) % (2*Math::PI) - Math::PI  # normalise to -180...+180   

      [lat2.to_deg, lon2.to_deg]
      # GeoPoint.new lat2.to_deg, lon2.to_deg      
    end
  end
end