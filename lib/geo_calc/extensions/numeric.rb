require 'geo_units'

module GeoCalc
  module NumericCheckExt
    def is_numeric? arg
      arg.is_a? Numeric
    end  

    alias_method :is_num?, :is_numeric?
  
    def check_numeric! arg
      raise ArgumentError, "Argument must be Numeric" if !is_numeric? arg
    end  
  end
end

class Fixnum
  include ::GeoUnits::NumericExt 
end

class Float
  include ::GeoUnits::NumericExt
end

