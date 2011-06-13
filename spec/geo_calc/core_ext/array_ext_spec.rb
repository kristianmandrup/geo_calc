require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe 'ruby core Class extensions' do
    describe 'Array extension' do
      describe '#to_lat' do              
        it 'should return latitude as first element' do
          @arr = [4, 27]
          @arr.to_lat.should == 4
        end

        it 'should return latitude as #to_lng of first element' do
          @arr = ["4.1", 27]
          @arr.to_lat.should == 4.1
        end
      end      

      describe '#to_lng' do              
        it 'should return latitude degree value for 360' do
          @arr = [4, 27]            
          @arr.to_lng.should == 27
        end

        it 'should return latitude as #to_lng of first element' do
          @arr = [4, "27.2"]            
          @arr.to_lng.should == 27.2
        end
      end   

      describe '#to_lat_lng' do              
        it 'should return Array with lat, lng' do
          @arr = ["3", {:lng => "2"}]
          @arr.to_lat_lng.should == [3, 2]
        end
      end   
    end # Array
  end
end