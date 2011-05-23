require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe 'ruby core Class extensions' do
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
    end
  end
end
