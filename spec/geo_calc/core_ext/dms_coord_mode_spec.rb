require 'spec_helper'
# require 'geo_point'

class GeoPoint
  mattr_accessor :coord_mode
end

describe 'GeoPoint.coord_mode' do
  # make shared example for default mode!
  context 'coord_mode is :lng_lat' do  
    before do
      GeoPoint.coord_mode = :lng_lat
    end

    after do
      GeoPoint.coord_mode = :lat_lng
    end

    describe 'DMS Array' do
      it 'should convert to (lng, lat) floats' do
        arr = ["58 38 38N", "003 04 12W"].to_lng_lat
        arr.first.should < 4
        arr.last.should > 58
      end
      
      it 'should convert to (lng, lat) floats' do
        arr = ["003 04 12W", "58 38 38N"].to_lng_lat
        arr.first.should < 4
        arr.last.should > 58
      end
    end
  end
  
  context 'coord_mode is :lat_lng' do  
    before do
      GeoPoint.coord_mode = :lat_lng
    end
  
    describe 'DMS Array' do
      it 'should convert to (lat, lng) floats' do
        arr = ["58 38 38N", "003 04 12W"].to_lng_lat
        arr.first.should < 4
        arr.last.should > 58
      end
      
      it 'should convert to (lng, lat) floats' do
        arr = ["003 04 12W", "58 38 38N"].to_lng_lat
        arr.first.should < 4
        arr.last.should > 58
      end
    end
  end  
end
      