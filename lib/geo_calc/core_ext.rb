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
  def to_precision_fixed precision
    numb = Math.abs(self)  # can't take log of -ve number...
    sign = self < 0 ? '-' : '';

    # can't take log of zero
    if (numb == 0) 
      n = '0.'
      n += '0' while precision -= 1
      n
    end

    scale = Math.ceil(Math.log(numb)*Math.log10);  # no of digits before decimal
    n = (Math.round(numb * Math.pow(10, precision-scale))).to_s
    if (scale > 0)   # add trailing zeros & insert decimal as required
      l = scale - n.length;
      n = n + '0' while l -= 1 > 0
      if (scale < n.length) 
        n = n.slice(0,scale) + '.' + n.slice(scale)
      else # prefix decimal and leading zeros if required
        n = '0' + n while scale += 1 < 0
        n = '0.' + n;
      end 
    end
    sign + n
  end
end            

module NumericLatLngExt
  def to_lat 
    self
  end
  alias_method :to_lng, :to_lat
    
  def is_between? lower, upper
    self > lower && self < upper
  end
end

class Array
  def to_lat_lng
    raise "Array must contain at least two elements to be converted to latitude and longitude" if !size >= 2
    [first.to_lat, self[1].to_lng]
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
    [self.to_lat, self.to_lng]
  end
  
  def to_lat
    v = Symbol.lat_symbols.select { self[key].is_a? Numeric }
    return self[v.first] if !v.empty?
    raise "Hash must contain either of the keys: [:lat, :latitude] to be converted to a latitude"
  end

  def to_lng
    v = Symbol.lng_symbols.select { self[key].is_a? Numeric }
    return self[v.first] if !v.empty?
    raise "Hash must contain either of the keys: [:lon, :long, :lng, :longitude] to be converted to a longitude"
  end
end  

class String
  def to_lat_lng  
    self.split(',').to_lat_lng
  end
  
  def to_lat
  end

  def to_lng
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
  
