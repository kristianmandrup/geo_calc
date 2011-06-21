require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe 'ruby core Class extensions' do
    describe 'String extension' do
      describe '#to_lat' do              
        it 'should not return latitude on empty String' do
          @str = ""
          lambda { @str.to_lat}.should raise_error
        end

        it 'should return latitude' do
          @str = "4"
          @str.to_lat.should == 4
        end

        it 'should convert to latitude' do
          @str = "50 03 59N"
          @str.to_lat.should be_within(0.4).of(50)
        end
        
        it 'should not allow conversion of longitude format to latitude' do
          str = "50 03 59E"
          lambda { str.to_lat}.should raise_error GeoDirectionMisMatch 
        end        
      end      

      describe '#to_lng' do              
        it 'should not return longitude on empty String' do
          @str = ""
          lambda { @str.to_lng}.should raise_error
        end

        it 'should return latitude' do
          @str = "4"
          @str.to_lng.should == 4
        end

        it 'should convert to latitude' do
          @str = "50 03 59E"
          @str.to_lng.should be_within(0.4).of(50)
        end

        it 'should not allow conversion of latitude format to longitude' do
          str = "50 03 59N"
          lambda { str.to_lng}.should raise_error GeoDirectionMisMatch 
        end
      end

      describe '#to_lat_lng' do              
        it 'should return Array with lat, lng' do
          @str = "4, 3"
          @str.to_lat_lng.should == [4, 3]
        end

        it 'should return Array with lat, lng' do
          @str = "04 38 08 W, 58 38 08 N"
          arr = @str.to_lat_lng
          # W = west is longitude and should be last! 
          arr.last.should < 0
          arr.first.should > 58          
        end

        it 'should return Array with lng, lat' do
          @str = "58 38 08 N, 04 38 08 W"
          arr = @str.to_lat_lng
          # W = west is longitude and should be last! 
          arr.last.should < 0
          arr.first.should > 58          
        end

        it 'should raise error if only latitude' do
          @str = "4"
          lambda { @str.to_lat_lng}.should raise_error
        end

        it 'should raise error if "," but only latitude' do
          @str = "4,"
          lambda { @str.to_lat_lng}.should raise_error
        end

        it 'should raise error if "," in bad position' do
          @str = ", 4 3"
          lambda { @str.to_lat_lng}.should raise_error
        end

        it 'should raise error if not using "," as seperator' do
          @str = "4; 3"
          lambda { @str.to_lat_lng}.should raise_error
        end
      end   

      describe '#to_lng_lat' do              
        it 'should return Array with lng, lat' do
          @str = "4, 3"
          @str.to_lng_lat.should == [3, 4]
        end

        it 'should return Array with lng, lat' do
          @str = "04 38 08 W, 58 38 08 N"
          arr = @str.to_lng_lat 
          # W = west is longitude and should be first!
          arr.first.should < 5
          arr.last.should > 58          
        end

        it 'should return Array with lng, lat' do
          @str = "58 38 08 N, 04 38 08 W"
          arr = @str.to_lng_lat
          # W = west is longitude and should be first!
          arr.first.should < 5
          arr.last.should > 58          
        end

        it 'should raise error if only latitude' do
          @str = "4"
          lambda { @str.to_lng_lat}.should raise_error
        end

        it 'should raise error if "," but only latitude' do
          @str = "4,"
          lambda { @str.to_lng_lat}.should raise_error
        end

        it 'should raise error if "," in bad position' do
          @str = ", 4 3"
          lambda { @str.to_lng_lat}.should raise_error
        end

        it 'should raise error if not using "," as seperator' do
          @str = "4; 3"
          lambda { @str.to_lng_lat}.should raise_error
        end
      end   

    end # String
  end
end