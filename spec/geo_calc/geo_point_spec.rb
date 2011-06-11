require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do  
  describe '#reverse_point' do
    before :each do
      @p = GeoPoint.new -2, 5
    end
  
    it 'should return reverse GeoPoint (2, -5)' do
      @p2 = @p.reverse_point
      @p2.should_not == @p  
      @p2.lat.should == 2
      @p2.lng.should == -5
    end
  end

  describe '#reverse_point!' do
    before :each do
      @p = GeoPoint.new -2, 5
    end
  
    it 'should return reverse GeoPoint (2, -5)' do
      @p.reverse_point!
      @p.lat.should == 2
      @p.lng.should == -5
    end
  end

  describe '#to_s' do
    before :each do
      @p1 = GeoPoint.new 50.1, 5
    end
  
    it 'should return GeoPoint as a dms formatted String' do
      @p1.to_s.should match /50.+5/
    end
  
    it 'should return GeoPoint as a dms formatted String' do
      @p1.to_s(:dm, 2).should match /50.+5/
    end
  end

  describe '#[]' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end
  
    it 'index of 0 should return latitude' do
      @p1[0].should == 50
    end

    it 'index of 1 should return longitude' do
      @p1[1].should == 5
    end

    it 'index of 2 should raise error' do
      lambda {@p1[2]}.should raise_error
    end

    it ':lat should return latitude' do
      @p1[:lat].should == 50
    end

    it ':long should return longitude' do
      @p1[:long].should == 5
    end
  end
  
  describe '#to_a' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end
  
    it 'should return GeoPoint as an array depending on state of reverse_arr' do
      @p1.to_a.should == [50, 5]
    end  
  end
  
  describe '#to_lat_lng' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end
  
    it 'should return GeoPoint as an array of [lat, lng]' do
      @p1.to_lat_lng.should == [50, 5]
    end  
  end

  describe '#to_lng_lat' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end
  
    it 'should return GeoPoint as an array of [lng, lat]' do
      @p1.to_lng_lat.should == [5, 50]
    end  
  end  
end
