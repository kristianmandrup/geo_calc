require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe '#initializer' do
    describe '1 argument' do
      describe 'single String' do
        describe '50.1, 5.0 ' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "50.1, 5.0"
            p1.should be_a(GeoPoint)
            p1.lat.should == 50.1
            p1.lon.should == 5.0
            p1.unit.should == :degrees
            p1.earth_radius_km.should == 6371
          end
        end    

        describe '(50.1, 5.0)' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "(50.1, 5.2)"
            p1.should be_a(GeoPoint)
            p1.lat.should == 50.1
            p1.lon.should == 5.2
            p1.unit.should == :degrees
            p1.earth_radius_km.should == 6371
          end
        end 
        
        describe '58 38 38N, 003 04 12W' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "58 38 38N, 003 04 12W"
            p1.should be_a(GeoPoint)
            p1.lat.should be_within(0.5).of(58.38)
            p1.lon.should be_within(0.5).of(-3)
            p1.unit.should == :degrees
            p1.earth_radius_km.should == 6371
          end
        end 

        describe '(58 38 38N, 003 04 12W)' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "(58 38 38N, 003 04 12W)"
            p1.should be_a(GeoPoint)
            p1.lat.should be_within(0.5).of(58.38)
            p1.lon.should be_within(0.5).of(-3) # W is negative, then normalize
            p1.unit.should == :degrees
            p1.earth_radius_km.should == 6371
          end
        end
      end
      
      describe 'single Array' do
        describe '2 Fixed numbers: 50,5 ' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new [50, 5]
            p1.should be_a(GeoPoint)
            p1.lat.should == 50
            p1.lon.should == 5
            p1.unit.should == :degrees        
            p1.earth_radius_km.should == 6371
          end
        end
        
        describe '2 Float numbers: 50.1, 5.0 ' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new [50.1, 5.0]
            p1.should be_a(GeoPoint)
            p1.lat.should == 50.1
            p1.lon.should == 5.0
            p1.unit.should == :degrees
            p1.earth_radius_km.should == 6371
          end
        end            
        
        describe 'single Hash' do
          describe 'with: {:lat => 50.1, :lng => 5.1}' do
            it 'should create a GeoPoint' do
              p1 = GeoPoint.new :lat => 50.1, :lng => 5.1
              p1.should be_a(GeoPoint)
              p1.lat.should == 50.1
              p1.lon.should == 5.1
              p1.unit.should == :degrees
              p1.earth_radius_km.should == 6371
            end
          end            
    
          describe 'with: {:lat => 50.1, :long => 5.1}' do
            it 'should create a GeoPoint' do
              p1 = GeoPoint.new :lat => 50.1, :long => 5.1
              p1.should be_a(GeoPoint)
              p1.lat.should == 50.1
              p1.lon.should == 5.1
              p1.unit.should == :degrees
              p1.earth_radius_km.should == 6371
            end
          end            
    
          describe 'with: {:latitude => 50.1, :longitude => 5.1}' do
            it 'should create a GeoPoint' do
              p1 = GeoPoint.new :latitude => 50.1, :longitude => 5.1
              p1.should be_a(GeoPoint)
              p1.lat.should == 50.1
              p1.lon.should == 5.1
              p1.unit.should == :degrees
              p1.earth_radius_km.should == 6371
            end
          end
        end
      end     
    end 
    
    describe 'with 2 arguments' do
      describe '2 Fixed numbers (Fixnum)' do
        it 'should create a GeoPoint' do
          p1 = GeoPoint.new 50, 5
          p1.should be_a(GeoPoint)
          p1.lat.should == 50
          p1.lon.should == 5
          p1.unit.should == :degrees        
          p1.earth_radius_km.should == 6371
        end
      end
  
      describe '2 Float numbers' do
        it 'should create a GeoPoint' do
          p1 = GeoPoint.new 50.1, 5.0
          p1.should be_a(GeoPoint)
          p1.lat.should == 50.1
          p1.lon.should == 5.0
          p1.unit.should == :degrees
          p1.earth_radius_km.should == 6371
        end
      end    
      
      describe '2 Strings: "58 38 38N", "003 04 12W"' do
        it 'should create a GeoPoint' do
          p1 = GeoPoint.new "58 38 38N", "003 04 12W"
          p1.should be_a(GeoPoint)
          p1.lat.should be_within(0.5).of(58.38)
          p1.lon.should be_within(0.5).of(-3)
          p1.unit.should == :degrees
          p1.earth_radius_km.should == 6371
        end
      end  
    end
  end # initializer  

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
