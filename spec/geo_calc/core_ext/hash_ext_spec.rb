require 'spec_helper'
require 'geo_point'

describe GeoPoint do 
  describe 'ruby core Class extensions' do
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

      describe '#to_lng_lat' do              
        it 'should return Array with lat, lng' do
          @hash = {:lng => 2, :lat => "3"}
          @hash.to_lng_lat.should == [2, 3]
        end
      end  

      context 'GeoPoint.coord_mode == :lng_lat' do
        describe '#to_coords' do              
          it 'should return Array with lng, lat' do
            GeoPoint.coord_mode = :lng_lat
            @hash = {:lng => 2, :lat => "3"}
            @hash.to_coords.should == [2, 3]
          end
        end  
      end

      context 'GeoPoint.coord_mode == :lat_lng' do
        describe '#to_coords' do              
          it 'should return Array with lat, lng' do
            GeoPoint.coord_mode = :lat_lng
            @hash = {:lng => 2, :lat => "3"}
            @hash.to_coords.should == [3, 2]
          end
        end  
      end
      
      describe '#geo_point' do              
        context 'GeoPoint.coord_mode == :lat_lng' do
          it 'should return Array with lng, lat' do
            GeoPoint.coord_mode = :lat_lng
            @hash = {:lng => 2, :lat => "3"}
            p = @hash.geo_point
            puts p.inspect

            p.to_lng_lat.should == [2, 3]
          end
        end

        context 'GeoPoint.coord_mode == :lng_lat' do
          it 'should return Array with lng, lat' do
            GeoPoint.coord_mode = :lng_lat
            @hash = {:lng => 2, :lat => "3"}   
            p = @hash.geo_point
            puts p.inspect
            
            p.to_lng_lat.should == [2, 3]
          end
        end
      end  
      
    end # Hash 
  end
end