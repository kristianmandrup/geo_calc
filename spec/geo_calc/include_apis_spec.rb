require 'spec_helper'

class CalcApis
  include GeoCalc
end

class CalcDistance
  include GeoCalc::Distance
end



# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe 'include all Apis' do
    it 'should have Bearing api' do
      CalcApis.new.should respond_to :bearing_to
    end
  end

  describe 'include select Apis' do
    it 'should not have Bearing api' do
      dist = CalcDistance.new
      dist.should_not respond_to :bearing_to
    end
    
    it 'should have Distance api' do
      dist = CalcDistance.new
      dist.should respond_to :distance_to
    end
  end
end