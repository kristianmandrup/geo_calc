require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html

# Accuracy: since the earth is not quite a sphere, there are small errors in using spherical geometry; the earth is actually roughly ellipsoidal (or more precisely, oblate spheroidal) with a radius varying between about 6,378km (equatorial) and 6,357km (polar), and local radius of curvature varying from 6,336km (equatorial meridian) to 6,399km (polar). 6,371 km is the generally accepted value for the Earth’s mean radius. This means that errors from assuming spherical geometry might be up to 0.55% crossing the equator, though generally below 0.3%, depending on latitude and direction of travel. An accuracy of better than 3m in 1km is mostly good enough for me, but if you want greater accuracy, you could use the Vincenty formula for calculating geodesic distances on ellipsoids, which gives results accurate to within 1mm. (Out of sheer perversity – I’ve never needed such accuracy – I looked up this formula and discovered the JavaScript implementation was simpler than I expected).
# Trig functions take arguments in radians, so latitude, longitude, and bearings in degrees (either decimal or degrees/minutes/seconds) need to be converted to radians, rad = π.deg/180. When converting radians back to degrees (deg = 180.rad/π), West is negative if using signed decimal degrees. For bearings, values in the range -π to +π [-180° to +180°] need to be converted to 0 to +2π [0°–360°]; this can be done by (brng+2.π)%2.π [or brng+360)%360] where % is the modulo operator.
# 
# The atan2() function widely used here takes two arguments, atan2(y, x), and computes the arc tangent of the ratio y/x. It is more flexible than atan(y/x), since it handles x=0, and it also returns values in all 4 quadrants -π to +π (the atan function returns values in the range -π/2 to +π/2).
# All bearings are with respect to true north, 0°=N, 90°=E, etc; if you are working from a compass, magnetic north varies from true north in a complex way around the earth, and the difference has to be compensated for by variances indicated on local maps.
# 
# If you implement any formula involving atan2 in Microsoft Excel, you will need to reverse the arguments, as Excel has them the opposite way around from JavaScript – conventional order is atan2(y, x), but Excel uses atan2(x, y). To use atan2 in a (VBA) macro, you can use WorksheetFunction.Atan2().
# If you are using Google Maps, several of these functions are now provided in the Google Maps API V3 ‘spherical’ library (computeDistanceBetween(), computeHeading(), computeOffset(), interpolate(), etc; 
# note they use a default Earth radius of 6,378,137 meters).
# 
# I learned a lot from the US Census Bureau GIS FAQ which is no longer available, so I’ve made a copy.
# Thanks to Ed Williams’ Aviation Formulary for many of the formulæ.
# For miles, divide km by 1.609344
# For nautical miles, divide km by 1.852

describe GeoCalc do 

  # Point 1: 50 03 59N, 005 42 53W
  # Point 2: 58 38 38N, 003 04 12W
  context 'p1= (50 03 59N, 005 42 53W) .. p2= (58 38 38N, 003 04 12W)' do
    before do
      @p1 = GeoPoint.new "50 03 59N", "005 42 53W"
      @p2 = GeoPoint.new "58 38 38N, 003 04 12W"
    end

    # Distance: 968.9 km
    describe '#distance_to' do      
      it 'should return the distance from p1 to p2 as 968.9 km' do
        @p1.distance_to(@p2).should be_within(0.5).of(968.9)
      end
    end

    # Initial bearing:  009°07′11″
    describe '#bearing_to' do      
      it 'should return the initial bearing from p1 to p2 as 009 07 11' do
        @p1.bearing_to(@p2).to_dms.should match /009.+07.+11/
      end
    end
    
    # Final bearing:  011°16′31″
    describe '#final_bearing_to' do      
      it 'should return the initial bearing from p1 to p2 as 011 16 31' do
        @p1.final_bearing_to(@p2).to_dms.should match /011.+16.+31/
      end
    end
    # 
    # Midpoint: 54°21′44″N, 004°31′50″W
    describe '#midpoint_to' do
      it 'should return the initial bearing from p1 to p2 as 011 16 31' do
        mp = @p1.midpoint_to(@p2)
        mp.to_dms.should match /54.+21.+44.+N, 004.+31.+50.+W/
      end
    end
  end # context

  # Start Point:  53°19′14″N, 001°43′47″W
  # Bearing:      096°01′18″
  # Distance:     124.8
  
  context 'Start Point: (53 19 14 N, 001 43 47 W)' do
    before do
      @p1 = GeoPoint.new "53 19 14 N, 001 43 47 W"
    end
  
    # Destination point:  53°11′18″N, 000°08′00″E
    # Final bearing:      097°30′52″
    describe '#destination_point' do      
      it 'should return the destination_point as (53 11 18 N, 000 08 00 E)' do
        # Bearing:      096°01′18″
        # Distance:     124.8
        @p2 = @p1.destination_point("096 01 18", 124.8)
        @p2.to_dms.should match /53.+11.+18.+N, 000.+08.+00.+E/
  
        # @p1.final_bearing_to(@p2).to_dms.should == "097°30′52″"
      end
    end
  end
  
  # Intersection:
  # Point 1: 51.885 N, 0.235 E; Brng 108.63°
  # Point 2: 49.008 N, 2.549 E; Brng 32.72°
  # Distance:     124.8 km
  context 'Points: (51.885 N, 0.235 E) Brng 108.63 .. (49.008 N, 2.549 E) Brng 32.72' do
    before do
      @p1 = GeoPoint.new "51.885 N, 0.235 E"
      @brng1 = "108.63"
      @p2 = GeoPoint.new "49.008 N, 2.549 E"
      @brng2 = "32.72"
    end
  
    # Intersection point:   50°54′06″N, 004°29′39″E
    describe '#intersection' do      
      it 'should return the intersection between p1 and p2 as (50 54 06 N, 004 29 39 E)' do
        GeoCalc.intersection(@p1, @brng1, @p2, @brng2).to_dms.should match /50.+54.+06.+N, 004.+29.+39.+E/
      end
    end
  end
  
  # Rhumb lines:
  # Point 1:  (50 21 50 N, 004 09 25 W)
  # Point 2:  (42 21 04 N, 071 02 27 W)
  context 'Points: (50 21 50N, 004 09 25W ) (42 21 04N, 071 02 27 W)' do
    before do
      @p1 = GeoPoint.new "50 21 50N, 004 09 25 W"
      @p2 = GeoPoint.new "42 21 04N, 071 02 27 W"
    end
    
    # Distance:   5196 km
    describe '#rhumb_distance_to' do
      it 'should return the distance from p1 to p2 as 5196 km' do
        @p1.rhumb_distance_to(@p2).should be_within(1).of(5196)
      end
    end
  
    # Bearing:    260°07′38″
    describe '#rhumb_bearing_to' do      
      it 'should return the initial bearing from p1 to p2 as 260 07 38' do
        @p1.rhumb_bearing_to(@p2).to_dms.should match /260.+07.+38/
      end
    end
  end
  
  # Start Point:  (51 07 32N, 001 20 17E)
  # Bearing:      116°38′10
  # Distance:     40.23 km
  context 'Start Point: (51 07 32N, 001 20 17E), Bearing: 116 38 10, Distance: 40.23 km' do
    before do
      @p1 = GeoPoint.new "51 07 32N, 001 20 17E"
      @brng = "116 38 10" 
      @dist = 40.23
    end
        
    # Destination point:  50°57′48″N, 001°51′09″E
    describe '#rhumb_destination_point' do      
      it 'should return the destination_point as (50 57 48 N, 001 51 09 E)' do
        @p2 = @p1.rhumb_destination_point(@brng, @dist)
        @p2.to_dms.should match /50.+57.+48.+N, 001.+51.+09.+E/
      end
    end
  end
  
  # Conversion
  # Point: (52°12′17.0″N, 000°08′26.0″E)
  # 52.20472 numeric deg (lat)
  # 0.14056 numeric deg (lon)
  context 'Point: (52 12 17.0 N, 000 08 26.0 E)' do
    before do
      @p = GeoPoint.new "52 12 17.0 N", "000 08 26.0 E"
      @lat = 52.20472
      @lon = 0.14056
    end
  
    # 1° ≈ 111 km (110.57 eq’l — 111.70 polar)
    # 1′ ≈ 1.85 km (= 1 nm)   0.01° ≈ 1.11 km
    # 1″ ≈ 30.9 m   0.0001° ≈ 11.1 m
  
    # Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)
    describe '#to_lon' do      
      it 'should Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)' do
        @lon.to_lon_dms.should match /000.+08.+26.+E/
      end
    end
    
    # Convert numeric degrees to deg/min/sec latitude (suffixed with N/S)
    describe '#to_lat' do      
      it 'should convert numeric degrees to deg/min/sec latitude (suffixed with N/S)' do
        @lat.to_lat_dms.should match /52.+12.+17.+N/
      end
    end
  end 
end
