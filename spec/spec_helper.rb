require 'rspec'
require 'geo_calc'

class GeoPoint
  attr_accessor :lat, :lon
  
  def initialize lat, lon
    @lat = lat
    @lon = lon
  end
  
  def lng
    lon
  end
end


RSpec.configure do |config|
  
end
