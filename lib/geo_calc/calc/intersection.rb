module GeoCalc
  module Intersection
    def intersection brng1, p2, brng2
      GeoCalc::Calc::Intersection.intersection self, brng1, p2, brng2
    end

    # Returns the point of intersection of two paths defined by point and bearing
    # 
    #   see http:#williams.best.vwh.net/avform.htm#Intersection
    # 
    # @param   [GeoPoint] p1: First point
    # @param   [Number] brng1: Initial bearing from first point
    # @param   [GeoPoint] p2: Second point
    # @param   [Number] brng2: Initial bearing from second point
    # @returns [Array] Destination point (null if no unique intersection defined)

    def self.intersection p1, brng1, p2, brng2
      lat1 = p1.lat.to_rad
      lon1 = p1.lon.to_rad

      lat2 = p2.lat.to_rad
      lon2 = p2.lon.to_rad

      brng13 = brng1.to_rad
      brng23 = brng2.to_rad

      dlat = lat2-lat1
      dlon = lon2-lon1;

      dist12 = 2*Math.asin( Math.sqrt( Math.sin(dlat/2)*Math.sin(dlat/2) + Math.cos(lat1)*Math.cos(lat2)*Math.sin(dlon/2)*Math.sin(dlon/2) ) )
      return nil if dist12 == 0

      # initial/final bearings between points
      brng_a = begin
        Math.acos( ( Math.sin(lat2) - Math.sin(lat1)*Math.cos(dist12) ) / ( Math.sin(dist12)*Math.cos(lat1) ) )
      rescue # protect against rounding
        0
      end

      brng_b = Math.acos( ( Math.sin(lat1) - Math.sin(lat2)*Math.cos(dist12) ) / ( Math.sin(dist12)*Math.cos(lat2) ) )

      brng12, brng21 = if Math.sin(lon2-lon1) > 0
        [brng_a, 2*Math::PI - brng_b] 
      else
        [2*Math::PI - brng_a, brng_b]
      end

      alpha1 = (brng13 - brng12 + Math::PI) % (2*Math::PI) - Math::PI  # angle 2-1-3
      alpha2 = (brng21 - brng23 + Math::PI) % (2*Math::PI) - Math::PI  # angle 1-2-3

      return nil if (Math.sin(alpha1)==0 && Math.sin(alpha2)==0) # infinite intersections
      return nil if (Math.sin(alpha1)*Math.sin(alpha2) < 0)    # ambiguous intersection

      # alpha1 = Math.abs(alpha1);
      # alpha2 = Math.abs(alpha2);
      # ... Ed Williams takes abs of alpha1/alpha2, but seems to break calculation?

      alpha3 = Math.acos( -Math.cos(alpha1)*Math.cos(alpha2) + Math.sin(alpha1)*Math.sin(alpha2)*Math.cos(dist12) )

      dist13 = Math.atan2( Math.sin(dist12)*Math.sin(alpha1)*Math.sin(alpha2), Math.cos(alpha2)+Math.cos(alpha1)*Math.cos(alpha3) )

      lat3 = Math.asin( Math.sin(lat1)*Math.cos(dist13) + Math.cos(lat1)*Math.sin(dist13)*Math.cos(brng13) )

      dlon13 = Math.atan2( Math.sin(brng13)*Math.sin(dist13)*Math.cos(lat1), Math.cos(dist13)-Math.sin(lat1)*Math.sin(lat3) )

      lon3 = lon1 + dlon13;
      lon3 = (lon3 + Math::PI) % (2*Math::PI) - Math::PI  # normalise to -180..180º

      [lat3.to_deg, lon3.to_deg]
    end
  end
end