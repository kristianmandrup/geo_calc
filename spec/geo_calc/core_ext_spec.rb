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
      
      # describe '#to_precision_fixed' do
      #   it 'should make precision 4' do
      #     1.123456.to_precision_fixed(4).should == '1.123'
      #   end
      # end
    end # NumericGeoExt
    
    describe NumericLatLngExt do
      describe '#to_lat' do      
        it 'should return latitude degree value for 360' do
          360.to_lat.should == 0
        end

        it 'should normalize degrees before converting to latitude, so 361 becomes 1' do
          361.to_lat.should == 1
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
      end      
    end
  end
end
