module GeoUnits
  module NumericExt
    def to_lat 
      normalize_lat
    end

    def to_lng 
      normalize_lng
    end

    def is_between? lower, upper
      (lower..upper).cover? self
    end

    def to_dms format = :dms, dp = nil
      Geo.to_dms self, format, dp
    end

    def to_lat_dms format = :dms, dp = nil
      Geo.to_lat self, format, dp
    end

    def to_lon_dms format = :dms, dp = nil
      Geo.to_lon self, format, dp
    end
  
    # Converts numeric degrees to radians
    def to_rad
      self * Math::PI / 180
    end
    alias_method :to_radians, :to_rad
    alias_method :as_rad,     :to_rad
    alias_method :as_radians, :to_rad
    alias_method :in_rad,     :to_rad
    alias_method :in_radians, :to_rad


    # Converts radians to numeric (signed) degrees
    # latitude (north to south) from equator +90 up then -90 down (equator again) = 180 then 180 for south = 360 total 
    # longitude (west to east)  east +180, west -180 = 360 total
    def to_deg
      self * 180 / Math::PI
    end

    alias_method :to_degrees, :to_deg
    alias_method :as_deg,     :to_deg
    alias_method :as_degrees, :to_deg
    alias_method :in_deg,     :to_deg
    alias_method :in_degrees, :to_deg

   
    # Formats the significant digits of a number, using only fixed-point notation (no exponential)
    # 
    # @param   {Number} precision: Number of significant digits to appear in the returned string
    # @returns {String} A string representation of number which contains precision significant digits
    def to_precision precision
      self.round(precision).to_s
    end
    alias_method :to_fixed, :to_precision

    # all degrees between -180 and 180
    def normalize_lng
      case self 
      when -360, 0, 360
        0
      when -360..-180
        self % 180      
      when -180..0 
        -180 + (self % 180) 
      when 0..180
        self
      when 180..360
        self % 180
      else
        return (self % 360).normalize_lng if self > 360
        return (360 - (self % 360)).normalize_lng if self < -360
        raise ArgumentError, "Degrees #{self} out of range"
      end
    end

    # all degrees between -90 and 90
    def normalize_lat
      case self 
      when -360, 0, 360
        0
      when -180, 180
        0
      when -360..-270
        self % 90      
      when -270..-180
        90 - (self % 90)
      when -180..-90
        - (self % 90)
      when -90..0 
        -90 + (self % 90) 
      when 0..90
        self
      when 90..180 
        self % 90
      when 180..270 
        - (self % 90)
      when 270..360 
        - 90 + (self % 90)
      else
        return (self % 360).normalize_lat if self > 360
        return (360 - (self % 360)).normalize_lat if self < -360
        raise ArgumentError, "Degrees #{self} out of range"      
      end
    end

    def normalize_deg shift = 0
      (self + shift) % 360 
    end
    alias_method :normalize_degrees, :normalize_deg  
  end
end