require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoCalc do 
  describe 'ruby core Class extensions' do
    describe 'Array extension' do
      describe '#to_lat' do              
        it 'should return latitude as first element' do          
          [4, 27].to_lat.should == 4
        end

        it 'should return latitude as #to_lng of first element' do
          ["4.1", 27].to_lat.should == 4.1
        end
      end      

      describe '#to_lng' do              
        it 'should return latitude degree value for 360' do
          [4, 27].to_lng.should == 27
        end
      
        it 'should return latitude as #to_lng of first element' do          
          [4, "27.2"].to_lng.should == 27.2
        end
      end   
      
      describe '#to_lat_lng' do              
        it 'should return Array with lat, lng' do
          ["3", {:lng => "2"}].to_lat_lng.should == [3, 2]
        end
      end   
      
      describe '#to_lng_lat' do              
        it 'should return Array with lat, lng' do
          ["3", {:lng => "2"}].to_lng_lat.should == [2, 3]
        end
      end   
    end # Array
  end
end

