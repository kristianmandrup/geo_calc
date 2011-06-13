require 'active_support/inflector'

module GeoCalc
  autoload :Bearing,      'geo_calc/calc/bearing'
  autoload :Destination,  'geo_calc/calc/destination'
  autoload :Distance,     'geo_calc/calc/distance'
  autoload :Intersection, 'geo_calc/calc/intersection'
  autoload :Midpoint,     'geo_calc/calc/midpoint'  
  autoload :Rhumb,        'geo_calc/calc/rhumb'    
  
  def self.included base
    apis.each do |api|           
      base.send :include, "GeoCalc::#{api}".constantize
    end
  end
  
  def self.apis
    [:Bearing, :Destination, :Distance, :Intersection, :Midpoint, :Rhumb]
  end
end
