require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe 'ruby core Class extensions' do
    describe NumericGeoExt do
      describe '#to_rad' do
        it 'should convert 0 degrees to 0 radians' do
          0.to_rad.should == 0
        end

        it 'should convert 180 degrees to PI radians' do
          180.to_rad.should == Math::PI        
        end

        it 'should convert 360 degrees to 6.28 radians' do
          360.to_rad.should == Math::PI*2                
        end
      end

      describe '#to_radians' do      
        it 'should alias to_rad' do
          360.to_rad.should == 360.to_radians
        end
      end

      describe '#to_deg' do
        it 'should convert 0 radians to 0 degrees' do
          0.to_deg.should == 0
        end

        it 'should convert PI radians to 180 degrees' do
          180.to_rad.to_deg.should be_within(0.01).of(180)
        end

        it 'should convert 6.28 radians to 360 degrees' do
          360.to_rad.to_deg.should be_within(0.01).of(360)
        end
      end
      
      describe '#to_degrees' do      
        it 'should alias to_deg' do
          360.to_deg.should == 360.to_degrees
        end
      end
      
      describe '#to_fixed' do
        it 'should make precision 4' do
          1.123456.to_fixed(2).should == '1.12'
        end
      end

      describe '#to_precision' do
        it 'should alis to_fixed' do
          1.123456.to_precision(4).should == '1.1235'
        end
      end

      describe '#normalize' do
        it 'should turn 180 deg and normalize' do
          361.normalize_deg(180).should == 181
        end
        it 'should normalize deg' do
          361.normalize_deg.should == 1
        end

        it 'should alias with #normalize_degrees' do
          362.normalize_degrees.should == 2
        end
      end
    end # NumericGeoExt
    
    describe NumericLatLngExt do
      describe 'Fixnum extension' do
        describe '#to_lat' do              
          it 'should return latitude degree value for 360' do
            360.to_lat.should == 0
          end

          it 'should normalize degrees before converting to latitude, so 361 becomes 1' do
            361.to_lat.should == 1
          end
        end      

        describe '#to_lng' do              
          it 'should return latitude degree value for 360' do
            90.to_lng.should == 90
          end

          it 'should normalize degrees before converting to latitude, so 361 becomes 1' do
            91.to_lng.should == 91
          end
        end      
      end

      describe 'Float extension' do
        describe '#to_lat' do              
          it 'should return latitude degree value for 360' do
            (360.0).to_lat.should == 0
          end

          it 'should normalize degrees before converting to latitude, so 361 becomes 1' do
            (361.1).to_lat.should be_within(0.01).of(1.1)
          end
        end      

        describe '#to_lng' do              
          it 'should return latitude degree value for 360' do
            (360.0).to_lng.should == 0
          end

          it 'should normalize degrees before converting to latitude, so 361 becomes 1' do
            (361.1).to_lng.should be_within(0.01).of(1.1)
          end
        end      
      end

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
      end # Array

      describe 'Hash extension' do
        describe '#to_lat' do              
          it 'should return latitude as #to_lat on the value for key :lat' do
            @hash = {:lat => 4}
            @hash.to_lat.should == 4
          end

          it 'should return latitude as #to_lat on the value for key :latitude' do
            @hash = {:latitude => "7"}
            @hash.to_lat.should == 7
          end
        end      

        describe '#to_lng' do              
          it 'should return latitude as #to_lng on the value for key :lng' do
            @hash = {:lng => 2}
            @hash.to_lng.should == 2
          end

          it 'should return latitude as #to_lng on the value for key :longitude' do
            @hash = {:longitude => "3.1"}
            @hash.to_lng.should == 3.1
          end 
        end

        describe '#to_lat_lng' do              
          it 'should return Array with lat, lng' do
            @hash = {:lng => 2, :lat => "3"}
            @hash.to_lat_lng.should == [3, 2]
          end
        end
      end # Hash 
      
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
        end      

        describe '#to_lng' do              
          it 'should not return longitude on empty String' do
            @str = ""
            lambda { @str.to_lng}.should raise_error
          end

          it 'should return latitude' do
            @str = "4"
            @str.to_lat.should == 4
          end

          it 'should convert to latitude' do
            @str = "50 03 59E"
            @str.to_lat.should be_within(0.4).of(50)
          end
        end

        describe '#to_lat_lng' do              
          it 'should return Array with lat, lng' do
            @str = "4, 3"
            @str.to_lat_lng.should == [4, 3]
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
      end # String      
    end
  end
end
