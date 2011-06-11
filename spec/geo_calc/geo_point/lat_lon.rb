require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do  
  describe '#lat' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end

    it 'should return latitude' do
      @p1.lat.should == 50
    end

    describe '#latitude (alias)' do
      it 'should return latitude' do
        @p1.latitude.should == 50
      end
    end

    describe '#to_lat (alias)' do
      it 'should return latitude' do
        @p1.to_lat.should == 50
      end
    end
  end

  describe '#lat=' do
    before :each do
      @p1 = GeoPoint.new 50, 5
    end

    it 'should set new latitude' do
      @p1.lat = 60
      @p1.lat.should == 60
    end

    it 'should set new latitude -2' do
      @p1.lat = -2
      @p1.lat.should == -2
    end

    it 'should convert latitude -182 to -2' do
      @p1.lat = -2
      @p1.lat.should == -2
    end


    it 'should set new latitude within allowed range' do
      @p1.lat = 520
      @p1.lat.should be_between(0, 360)
    end

    describe '#latitude (alias)' do
      it 'should set latitude' do
        @p1.lat = 72
        @p1.latitude.should == 72
      end
    end
  end

  describe '#lon' do
    before :each do
      @p1 = GeoPoint.new 5, 50
    end

    it 'should return longitude' do
      @p1.lon.should == 50
    end

    it 'should return longitude (via lng)' do
      @p1.lng.should == 50
    end

    describe '#longitude (alias)' do
      it 'should return longitude' do
        @p1.longitude.should == 50
      end
    end

    describe '#to_lng (alias)' do
      it 'should return latitude' do
        @p1.to_lng.should == 50
      end
    end
  end

  describe '#lon=' do
    before :each do
      @p1 = GeoPoint.new 5, 50
    end

    it 'should set new longitude' do
      @p1.lat.should == 5
      @p1.lon = 60
      @p1.lon.should == 60
    end

    it 'should return longitude (via lng)' do
      @p1.lng = 70
      @p1.lng.should == 70
    end

    it 'should set new latitude within allowed range' do
      @p1.lon = 520
      @p1.longitude.should be_between(-180, 180)
    end

    describe '#latitude (alias)' do
      it 'should set latitude' do
        @p1.longitude = 72
        @p1.longitude.should == 72
      end
    end
  end
end