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
            p1.radius.should == 6371
          end
        end    

        describe '(50.1, 5.0)' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "(50.1, 5.2)"
            p1.should be_a(GeoPoint)
            p1.lat.should == 50.1
            p1.lon.should == 5.2
            p1.unit.should == :degrees
            p1.radius.should == 6371
          end
        end 
        
        describe '58 38 38N, 003 04 12W' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "58 38 38N, 003 04 12W"
            p1.should be_a(GeoPoint)
            p1.lat.should be_within(0.5).of(58.38)
            p1.lon.should be_within(0.5).of(356.5)
            p1.unit.should == :degrees
            p1.radius.should == 6371
          end
        end 

        describe '(58 38 38N, 003 04 12W)' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new "(58 38 38N, 003 04 12W)"
            p1.should be_a(GeoPoint)
            p1.lat.should be_within(0.5).of(58.38)
            p1.lon.should be_within(0.5).of(356.5) # W is negative, then normalize
            p1.unit.should == :degrees
            p1.radius.should == 6371
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
            p1.radius.should == 6371
          end
        end
        
        describe '2 Float numbers: 50.1, 5.0 ' do
          it 'should create a GeoPoint' do
            p1 = GeoPoint.new [50.1, 5.0]
            p1.should be_a(GeoPoint)
            p1.lat.should == 50.1
            p1.lon.should == 5.0
            p1.unit.should == :degrees
            p1.radius.should == 6371
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
              p1.radius.should == 6371
            end
          end            
    
          describe 'with: {:lat => 50.1, :long => 5.1}' do
            it 'should create a GeoPoint' do
              p1 = GeoPoint.new :lat => 50.1, :long => 5.1
              p1.should be_a(GeoPoint)
              p1.lat.should == 50.1
              p1.lon.should == 5.1
              p1.unit.should == :degrees
              p1.radius.should == 6371
            end
          end            
    
          describe 'with: {:latitude => 50.1, :longitude => 5.1}' do
            it 'should create a GeoPoint' do
              p1 = GeoPoint.new :latitude => 50.1, :longitude => 5.1
              p1.should be_a(GeoPoint)
              p1.lat.should == 50.1
              p1.lon.should == 5.1
              p1.unit.should == :degrees
              p1.radius.should == 6371
            end
          end
        end
      end     
    end 
    
  #   describe 'with 2 arguments' do
  #     describe '2 Fixed numbers (Fixnum)' do
  #       it 'should create a GeoPoint' do
  #         p1 = GeoPoint.new 50, 5
  #         p1.should be_a(GeoPoint)
  #         p1.lat.should == 50
  #         p1.lon.should == 5
  #         p1.unit.should == :degrees        
  #         p1.radius.should == 6371
  #       end
  #     end
  # 
  #     describe '2 Float numbers' do
  #       it 'should create a GeoPoint' do
  #         p1 = GeoPoint.new 50.1, 5.0
  #         p1.should be_a(GeoPoint)
  #         p1.lat.should == 50.1
  #         p1.lon.should == 5.1
  #         p1.unit.should == :degrees
  #         p1.radius.should == 6371
  #       end
  #     end    
  #     
  #     describe '2 Strings: "58 38 38N", "003 04 12W"' do
  #       it 'should create a GeoPoint' do
  #         p1 = GeoPoint.new "58 38 38N", "003 04 12W"
  #         p1.should be_a(GeoPoint)
  #         p1.lat.should be_within(0.5).of(58.38)
  #         p1.lon.should be_within(0.5).of(3)
  #         p1.unit.should == :degrees
  #         p1.radius.should == 6371
  #       end
  #     end
  # 
  #     describe '2 Arrays: ["58 38 38N"], ["003 04 12W"]' do
  #       it 'should create a GeoPoint' do
  #         p1 = GeoPoint.new ["58 38 38N"], ["003 04 12W"]
  #         p1.should be_a(GeoPoint)
  #         p1.lat.should be_within(0.5).of(58.38)
  #         p1.lon.should be_within(0.5).of(3)
  #         p1.unit.should == :degrees
  #         p1.radius.should == 6371
  #       end
  #     end
  #   end
  end # initializer  

  # describe '#to_s' do
  #   before :each do
  #     @p1 = GeoPoint.new 50.1, 5
  #   end
  # 
  #   it 'should return GeoPoint as a dms formatted String' do
  #     @p1.to_s.should match /50.+5/
  #   end
  # 
  #   it 'should return GeoPoint as a dms formatted String' do
  #     @p1.to_s(:dm, 2).should match /50.+5/
  #   end
  # end
  
  # describe '#to_arr' do
  #   before :each do
  #     @p1 = GeoPoint.new 50, 5
  #   end
  # 
  #   it 'should return GeoPoint as an array depending on state of reverse_arr' do
  #     @p1.to_arr.should == [50, 5]
  #   end
  # 
  #   describe '#reverse_arr!' do    
  #     it 'should reverse the array returned by #to_arr to [lng, lat]' do
  #       @p1.reverse_arr!
  #       @p1.to_arr.should == [5, 50]
  #     end
  #   end
  # 
  #   describe '#reverse_arr!' do    
  #     it 'should turn effect of #to_arr back to normal [lat, lng]' do
  #       @p1.normal_arr!
  #       @p1.to_arr.should == [50, 5]      
  #     end
  #   end
  # end
end
