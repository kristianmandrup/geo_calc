module NumericGeoExt
  # Converts numeric degrees to radians
  def to_rad
      self * Math::PI / 180
  end

  # Converts radians to numeric (signed) degrees
  # latitude (north to south) from equator +90 up then -90 down (equator again) = 180 then 180 for south = 360 total 
  # longitude (west to east)  east +180, west -180 = 360 total
  def to_deg
    self * 180 / Math::PI
  end
   
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
      while precision-- { n += '0'}
      n
    end

    scale = Math.ceil(Math.log(numb)*Math.LOG10E);  # no of digits before decimal
    n = (Math.round(numb * Math.pow(10, precision-scale))).to_s
    if (scale > 0)   # add trailing zeros & insert decimal as required
      l = scale - n.length;
      while (l-- > 0) { n = n + '0' }
      if (scale < n.length) 
        n = n.slice(0,scale) + '.' + n.slice(scale)
      else # prefix decimal and leading zeros if required
        while (scale++ < 0) { n = '0' + n }
        n = '0.' + n;
      end 
    end
    sign + n
  end
end            

class Fixnum
  include NumericGeoExt
end

class Float
  include NumericGeoExt
end
  
