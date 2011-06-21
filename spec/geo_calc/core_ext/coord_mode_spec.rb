require 'spec_helper'
# require 'geo_point'

class GeoPoint
  mattr_accessor :coord_mode
end

describe 'GeoPoint.coord_mode' do
  context 'coord_mode is nil (default is :lat_lng)' do  
    before do
      GeoPoint.coord_mode = nil
    end    
  end

  # make shared example for default mode!
  context 'coord_mode is :lat_lng' do  
    before do
      GeoPoint.coord_mode = :lat_lng
    end

    describe 'Array' do
      describe '#to_lng_lat' do
        it 'should reverse array' do
          [2, 3].to_lng_lat.should == [3, 2]
        end
      end

      describe '#to_lat_lng' do
        it 'should not reverse array' do
          [2, 3].to_lat_lng.should == [2, 3]
        end
      end
    end # Array
    
    describe 'String' do
      describe '#to_lat_lng' do
        it 'should return Array in same order' do
          @str = "4, 3"
          @str.to_lat_lng.should == [4, 3]
        end
      end

      describe '#to_lng_lat' do
        it 'should return reversed Array' do
          @str = "4, 3"
          @str.to_lng_lat.should == [3,4]
        end
      end
    end # String    
  end

  context 'coord_mode is :lng_lat' do  
    before do
      GeoPoint.coord_mode = :lng_lat
    end

    describe 'Array' do
      describe '#to_lng_lat' do
        it 'should not reverse array' do
          [2, 3].to_lng_lat.should == [2, 3]
        end
      end
      
      describe '#to_lat_lng' do
        it 'should reverse array' do
          [2, 3].to_lat_lng.should == [3, 2]
        end
      end      
    end # Array

    describe 'String' do
      describe '#to_lng_lat' do
        it 'should return Array in same order' do
          @str = "4, 3"
          @str.to_lng_lat.should == [4, 3]
        end
      end

      describe '#to_lat_lng' do
        it 'should return reversed Array' do
          @str = "4, 3"
          @str.to_lat_lng.should == [3,4]
        end
      end
    end # String 
    
    describe 'Hash' do
      describe '#to_lng_lat' do
        it 'should return Array with lng, lat' do
          hash = {:lng => 2, :lat => "3"}
          hash.to_lng_lat.should == [2, 3]
        end
      end  

      describe '#to_lat_lng' do              
        it 'should return Array with lat, lng' do
          hash = {:lng => 2, :lat => "3"}
          hash.to_lat_lng.should == [3, 2]
        end
      end
    end
  end
end