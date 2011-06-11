require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do  
  describe 'Class methods' do     
    describe '#coord_mode' do
      it 'should change global coordinates mode' do
        GeoPoint.coord_mode = :lng_lat
        GeoPoint.coord_mode.should == :lng_lat        

        GeoPoint.coord_mode = :lat_lng
        GeoPoint.coord_mode.should == :lat_lng                        
      end
      
      it 'shoould not allow setting invalid coord mode' do
        lambda { GeoPoint.coord_mode = :blip }.should raise_error
      end
    end
    
    describe '#earth_radius_km' do
      it 'should change global earth_radius_km' do
        GeoPoint.earth_radius_km = 6360
        GeoPoint.earth_radius_km.should == 6360
      end
      
      it 'shoould not allow setting invalid earth radius' do
        lambda { GeoPoint.earth_radius_km = 6100 }.should raise_error
      end    
    end
  end
end
