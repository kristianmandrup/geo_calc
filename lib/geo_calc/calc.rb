module GeoCalc
  autoload :PrettyPrint,  'geo_calc/pretty_print'
end

module GeoCalc
  module Calc
    autoload :Bearing,      'geo_calc/calc/bearing'
    autoload :Destination,  'geo_calc/calc/destination'
    autoload :Distance,     'geo_calc/calc/distance'
    autoload :Intersection, 'geo_calc/calc/intersection'
    autoload :Midpoint,     'geo_calc/calc/midpoint'  
    autoload :Rhumb,        'geo_calc/calc/rhumb'    
  
    module All
      def self.included base
        base.send :include, GeoCalc::Calc::Bearing
        base.send :include, GeoCalc::Calc::Destination
        base.send :include, GeoCalc::Calc::Distance
        base.send :include, GeoCalc::Calc::Intersection
        base.send :include, GeoCalc::Calc::Midpoint
        base.send :include, GeoCalc::Calc::Rhumb
        base.send :include, GeoCalc::PrettyPrint
      end
    end  
  end
end
