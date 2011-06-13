require 'geo_units'

module GeoCalc
  module PrettyPrint

    # Returns the latitude of this point; signed numeric degrees if no format, otherwise format & dp 
    # 
    # @param [String] format: Return value as 'd', 'dm', 'dms'
    # @param [Numeric] dp: No of decimal places to display (0|2|4)
    #
    # @return   [Numeric|String]: Numeric degrees if no format specified, otherwise deg/min/sec
    # 
    def to_lat format = :dms, dp = 0
      return lat if !format
      GeoUnits::Converter.to_lat lat, format, dp
    end

    # Returns the longitude of this point; signed numeric degrees if no format, otherwise format & dp 
    # as per Geo.toLon()
    # 
    # @param   [String} [format]: Return value as 'd', 'dm', 'dms'
    # @param   [Number} [dp=0|2|4]: No of decimal places to display
    # @return [Number|String} Numeric degrees if no format specified, otherwise deg/min/sec
    # 
    # @requires Geo

    def to_lon format, dp
      return lon if !format
      GeoUnits::Converter.to_lon lon, format, dp
    end


    # Returns a string representation of this point; format and dp as per lat()/lon()
    # 
    # @param   [String] format: Return value as 'd', 'dm', 'dms'
    # @param   [Number] dp: No of decimal places to display (0|2|4)

    # @return [String] Comma-separated latitude/longitude
    # 

    def to_s format = :dms, dp = 0 
      format ||= :dms

      return '-,-' if !lat || !lon

      _lat = GeoUnits::Converter.to_lat lat, format, dp
      _lon = GeoUnits::Converter.to_lon lon, format, dp

      "#{_lat}, #{_lon}"
    end
  end
end