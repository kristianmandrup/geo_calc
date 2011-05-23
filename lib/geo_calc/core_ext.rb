module NumericCheckExt
  def is_numeric? arg
    arg.is_a? Numeric
  end  

  alias_method :is_num?, :is_numeric?
  
  def check_numeric! arg
    raise ArgumentError, "Argument must be Numeric" if !is_numeric? arg
  end  
end

module GeoUnits
  module Converter
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

module NumericGeoExt 
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

module Math
  def self.log10e
    0.4342944819032518
  end
end

module NumericLatLngExt
  def to_lat 
    normalize_lat
  end

  def to_lng 
    normalize_lng
  end
    
  def is_between? lower, upper
    (lower..upper).cover? self
  end
end

class Array
  def geo_point
    GeoPoint.new to_lat_lng
  end  
  
  def to_lat_lng
    raise "Array must contain at least two elements to be converted to latitude and longitude" if !(size >= 2)
    [to_lat, to_lng]
  end 

  def to_lat
    raise "Array must contain at least one element to return the latitude" if empty?
    first.to_lat
  end

  def to_lng
    raise "Array must contain at least two elements to return the longitude" if !self[1]
    self[1].to_lng
  end
  
  def trim
    join.trim
  end
end

class Symbol
  def self.lng_symbols
    [:lon, :long, :lng, :longitude]  
  end

  def self.lat_symbols
    [:lat, :latitude]
  end
end

class Hash
  def to_lat_lng
    [to_lat, to_lng]
  end
  
  def to_lat
    v = Symbol.lat_symbols.select {|key| self[key] }
    return self[v.first].to_lat if !v.empty?
    raise "Hash must contain either of the keys: [:lat, :latitude] to be converted to a latitude"
  end

  def to_lng
    v = Symbol.lng_symbols.select {|key| self[key] }
    return self[v.first].to_lng if !v.empty?
    raise "Hash must contain either of the keys: [:lon, :long, :lng, :longitude] to be converted to a longitude"
  end  
  
  def geo_point
    GeoPoint.new to_lat_lng
  end
end  

class String
  def concat *args
    args.inject(self) do |res, arg| 
      x = arg.is_a?(String) ? arg : arg.to_s
      res << x
      res
    end
  end

  def parse_dms
    Geo.parse_dms self
  end

  def to_rad
    parse_dms.to_rad
  end

  def trim
    strip
  end

  def geo_clean
    self.gsub(/^\(/, '').gsub(/\)$/, '').trim
  end

  def geo_point
    GeoPoint.new to_lat_lng
  end
    
  def to_lat_lng  
    geo_clean.split(',').to_lat_lng
  end
  
  def to_lat
    raise "An empty String has no latitude" if empty?
    geo_clean.parse_dms.to_f.to_lat
  end

  def to_lng
    raise "An empty String has no latitude" if empty?
    geo_clean.parse_dms.to_f.to_lng
  end
end

class Fixnum
  include NumericGeoExt 
  include NumericLatLngExt  
end

class Float
  include NumericGeoExt   
  include NumericLatLngExt
end

