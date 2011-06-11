require 'geo_calc/calc'
require 'geo_calc/extensions'

module GeoUnits
  module Converter
    # Convert numeric degrees to deg/min/sec latitude (suffixed with N/S)
    # 
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds

    def to_lat deg, format = :dms, dp = 0
      deg = deg.normalize_lat
      _lat = to_dms deg, format, dp
      _lat == '' ? '' : _lat[1..-1] + (deg<0 ? 'S' : 'N')  # knock off initial '0' for lat!
    end


    # Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)
    # 
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds

    def to_lon deg, format = :dms, dp = 0
      deg = deg.normalize_lng
      lon = to_dms deg, format, dp
      lon == '' ? '' : lon + (deg<0 ? 'W' : 'E')
    end


    # Convert numeric degrees to deg/min/sec as a bearing (0º..360º)
    # 
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds

    def to_brng deg, format = :dms, dp = 0
      deg = (deg.to_f + 360) % 360  # normalise -ve values to 180º..360º
      brng =  to_dms deg, format, dp
      brng.gsub /360/, '0'  # just in case rounding took us up to 360º!
    end 

    protected

    include ::GeoCalc::NumericCheckExt    
    
    # Converts numeric degrees to radians
    def to_rad degrees
      degrees * Math::PI / 180
    end
    alias_method :to_radians, :to_rad
    alias_method :as_rad,     :to_rad
    alias_method :as_radians, :to_rad
    alias_method :in_rad,     :to_rad
    alias_method :in_radians, :to_rad


    # Converts radians to numeric (signed) degrees
    # latitude (north to south) from equator +90 up then -90 down (equator again) = 180 then 180 for south = 360 total 
    # longitude (west to east)  east +180, west -180 = 360 total
    def to_deg radians
      radians * 180 / Math::PI
    end

    alias_method :to_degrees, :to_deg
    alias_method :as_deg,     :to_deg
    alias_method :as_degrees, :to_deg
    alias_method :in_deg,     :to_deg
    alias_method :in_degrees, :to_deg
  end 

  # all degrees between -180 and 180
  def normalize_lng deg
    case deg 
    when -360..-180
      deg % 180      
    when -180..0 
      -180 + (deg % 180) 
    when 0..180
      deg
    when 180..360
      deg % 180
    else
      raise ArgumentError, "Degrees #{deg} out of range, must be between -360 to 360"
    end
  end

  # all degrees between -90 and 90
  def normalize_lat deg
    case deg 
    when -360..-270
      deg % 90      
    when -270..-180
      90 - (deg % 90)
    when -180..-90
      - (deg % 90)
    when -90..0 
      -90 + (deg % 90) 
    when 0..90
      deg
    when 90..180 
      deg % 90
    when 180..270 
      - (deg % 90)
    when 270..360 
      - 90 + (deg % 90)
    else
      raise ArgumentError, "Degrees #{deg} out of range, must be between -360 to 360"    
    end 
  end
  
  def normalize_deg degrees, shift = 0
    (degrees + shift) % 360 
  end
  alias_method :normalize_degrees, :normalize_deg  
end