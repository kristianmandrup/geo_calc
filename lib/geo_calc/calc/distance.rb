 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #  Latitude/longitude spherical geodesy formulae & scripts (c) Chris Veness 2002-2010            
 #   - www.movable-type.co.uk/scripts/latlong.html
 #                                                                                                

module GeoCalc
  module Distance  
    def distance_to point, precision = 4
      GeoCalc::Distance.distance_to self, point, precision
    end

    # Returns the distance from this point to the supplied point, in km 
    # (using Haversine formula)
    # 
    # from: Haversine formula - R. W. Sinnott, "Virtues of the Haversine",
    #       Sky and Telescope, vol 68, no 2, 1984
    # 
    # @param [GeoPoint] Latitude/longitude of destination point
    # @param [Numeric] number of significant digits to use for returned value
    #
    # @return [Numeric] distance in km between this point and destination point
  
    def self.distance_to base_point, point, precision = 4
      # default 4 sig figs reflects typical 0.3% accuracy of spherical model
      precision ||= 4

      lat1 = base_point.lat.to_rad
      lon1 = base_point.lon.to_rad

      lat2 = point.lat.to_rad
      lon2 = point.lon.to_rad

      dlat = lat2 - lat1
      dlon = lon2 - lon1

      a = Math.sin(dlat/2) * Math.sin(dlat/2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon/2) * Math.sin(dlon/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = base_point.earth_radius_km * c
      d.round(precision)
    end
  end
end

