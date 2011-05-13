module NumericCheckExt
  def is_numeric? arg
    arg.is_a? Numeric
  end  

  alias_method :is_num?, :is_numeric?
  
  def check_numeric! arg
    raise ArgumentError, "Argument must be Numeric" if !is_numeric? arg
  end  
end

module NumericGeoExt
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

    # numb = self.abs  # can't take log of -ve number...
    # sign = self < 0 ? '-' : '';
    # 
    # # can't take log of zero
    # if (numb == 0) 
    #   n = '0.' 
    #   while (precision -= 1) > 0
    #     n += '0' 
    #   end 
    #   return n
    # end
    # 
    # scale = (Math.log(numb) * Math.log10e).ceil # no of digits before decimal
    # n = (numb * (precision - scale)**10).round.to_s
    # if (scale > 0)   # add trailing zeros & insert decimal as required
    #   l = scale - n.length
    # 
    #   while (l -= 1) > 0
    #     n += '0' 
    #   end
    # 
    #   if scale < n.length 
    #     n = n.slice(0,scale) + '.' + n.slice(scale)
    #   else # prefix decimal and leading zeros if required
    #     while (scale += 1) < 0
    #       n = '0' + n 
    #     end
    #     n = '0.' + n
    #   end 
    # end
    # sign + n
  end
  alias_method :to_fixed, :to_precision

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
    normalize_deg
  end
  alias_method :to_lng, :to_lat
    
  def is_between? lower, upper
    (lower..upper).cover? self
  end
end

class Array
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
end  

class String
  def concat *args
    args.inject(self) do |res, arg| 
      x = arg.is_a?(String) ? arg : arg.to_s
      res << x
      res
    end
  end

  def trim
    strip
  end

  def geo_clean
    self.gsub(/^\(/, '').gsub(/\)$/, '').trim
  end
    
  def to_lat_lng  
    geo_clean.split(',').to_lat_lng
  end
  
  def to_lat
    raise "An empty String has no latitude" if empty?
    parse_dms(geo_clean).to_f.to_lat
  end

  def to_lng
    raise "An empty String has no latitude" if empty?
    parse_dms(geo_clean).to_f.to_lng
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
  
