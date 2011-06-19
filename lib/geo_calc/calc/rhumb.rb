module GeoCalc
  module Rhumb
    # Returns the distance from this point to the supplied point, in km, travelling along a rhumb line
    # 
    # see(http:#williams.best.vwh.net/avform.htm#Rhumb)
    #
    # @param  [GeoPoint] Destination point latitude and longitude of 
    # @return [Numeric] Distance in km between start and destination point
    def rhumb_distance_to point
      GeoCalc::Rhumb.rhumb_distance_to self, point
    end

    # Returns the distance from this point to the supplied point, in km, travelling along a rhumb line
    #
    # @param  [GeoPoint] Start point with (latitude, longitude)
    # @param  [GeoPoint] Destination point (latitude, longitude)
    # @return [Numeric] Distance in km between start and destination point
    #
    def self.rhumb_distance_to base_point, point
      lat1 = base_point.lat.to_rad
      lat2 = point.lat.to_rad

      dlat = (point.lat - base_point.lat).to_rad
      dlon = (point.lon - base_point.lon).abs.to_rad

      dphi = Math.log(Math.tan(lat2/2 + Math::PI/4) / Math.tan(lat1/2 + Math::PI/4))

      q = begin
        dlat / dphi
      rescue 
        Math.cos(lat1) # E-W line gives dPhi=0
      end
      
      # if dlon over 180° take shorter rhumb across 180° meridian:
      dlon = 2*Math::PI - dlon if (dlon > Math::PI)

      dist = Math.sqrt(dlat*dlat + q*q*dlon*dlon) * base_point.earth_radius_km; 

      dist.round(4)  # 4 sig figures reflects typical 0.3% accuracy of spherical model
    end

    # Returns the bearing from this point to the supplied point along a rhumb line, in degrees
    #
    # @param  [GeoPoint] Destination point (latitude, longitude)
    # @return [Numeric] Bearing in degrees from North
    #
    def rhumb_bearing_to point
      GeoCalc::Rhumb.rhumb_bearing_to self, point
    end
    # Returns the bearing from this point to the supplied point along a rhumb line, in degrees
    # 
    # @param  [GeoPoint] Destination point (latitude, longitude)
    # @return [Numeric] Bearing in degrees from North
    #
    def self.rhumb_bearing_to base_point, point
      lat1 = base_point.lat.to_rad
      lat2 = point.lat.to_rad

      dlon = (point.lon - base_point.lon).to_rad

      dphi = Math.log(Math.tan(lat2/2+Math::PI/4) / Math.tan(lat1/2+Math::PI/4))
      if dlon.abs > Math::PI
        dlon = dlon>0 ? -(2*Math::PI-dlon) : (2*Math::PI+dlon);
      end

      brng = Math.atan2(dlon, dphi);

      (brng.to_deg+360) % 360
    end

    # Returns the destination point from this point having travelled the given distance (in km) on the 
    # given bearing along a rhumb line
    #
    # @param   [Number] brng: Bearing in degrees from North
    # @param   [Number] dist: Distance in km
    # @returns [Array] Destination point as an array [lat, long]
    def rhumb_destination_point brng, dist
      GeoCalc::Rhumb.rhumb_destination_point self, brng, dist
    end

    # Returns the destination point from this point having travelled the given distance (in km) on the 
    # given bearing along a rhumb line
    #
    # @param   [GeoPoint] Starting point (latitude, longitude)     
    # @param   [Number] brng: Bearing in degrees from North
    # @param   [Number] dist: Distance in km
    # @returns [Array] Destination point as an array [lat, long]
    #
    def self.rhumb_destination_point base_point, brng, dist
      d = dist / base_point.earth_radius_km  # d = angular distance covered on earth's surface
      lat1 = base_point.lat.to_rad
      lon1 = base_point.lon.to_rad
      brng = brng.to_rad

      lat2 = lat1 + d*Math.cos(brng);
      dlat = lat2 - lat1;
      dphi = Math.log(Math.tan(lat2/2+Math::PI/4) / Math.tan(lat1/2+Math::PI/4))

      q = begin
        dlat / dphi
      rescue 
        Math.cos(lat1) # E-W line gives dPhi=0
      end

      dlon = d * Math.sin(brng) / q
      # check for some daft bugger going past the pole

      if lat2.abs > Math::PI/2
        lat2 = lat2>0 ? Math::PI-lat2 : -(Math::PI-lat2)
      end
      lon2 = (lon1+dlon+3*Math::PI) % (2*Math::PI) - Math::PI

      [lat2.to_deg, lon2.to_deg]
      # GeoPoint.new 
    end
  end
end