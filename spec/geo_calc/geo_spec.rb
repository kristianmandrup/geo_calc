require 'spec_helper'

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoPoint do 
  describe Geo do

    # # @param   {String|Number} dmsStr: Degrees or deg/min/sec in variety of formats
    # @returns {Number} Degrees as decimal number
    describe '#parse_dms' do
      it 'should convert "58 38 38N" to a Float of degrees (58..59)' do
        deg = Geo.parse_dms("58 38 38N")
        deg.should be_a(Float)
        deg.should be_between(58, 59)
      end

      it 'should convert "01 38 38W" to a Float of degrees (1..2)' do
        deg = Geo.parse_dms("01 38 38W")
        deg.should be_a(Float)
        deg.should < 0
        deg.should > -2       
      end

      it 'should convert "005 38 E" to a Float of degrees (5..6)' do
        deg = Geo.parse_dms("005 38 E")
        deg.should be_a(Float)
        deg.should be_between(5, 6)
      end
    end

    # deg, format = :dms, dp = 0
    describe '#to_dms' do
      it 'should convert 58.3 to a String in DMS format' do
        dms = Geo.to_dms(58.3)
        dms.should be_a(String)
        expr = Regexp.escape "058".concat("\u00B0", "18", "\u2032", "00", "\u2033")
        dms.should match expr
      end
    
      it 'should convert 58.3 to a String in DM format' do
        dm = Geo.to_dms(58.3, :dm, 2)
        dm.should be_a(String)
        expr = Regexp.escape "058".concat("\u00B0", "18", "\u2032")
        dm.should match expr
      end
    
      it 'should convert 58.3 to a String in D format' do
        d = Geo.to_dms(58.3, :d, 2)
        d.should be_a(String)
        m = Regexp.escape "058".concat("\u00B0")
        d.should match m
      end
    end
    
    # deg, format, dp      
    describe '#to_lat' do
      it 'should convert 58.3 to a latitude String in North direction' do
        str_lat = Geo.to_lat(58.3)
        str_lat.should be_a(String)
        expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "N")
        str_lat.should match expr
      end
    
      it 'should convert -58.3 to a latitude String in South direction' do
        str_lat = Geo.to_lat(-58.3)
        str_lat.should be_a(String)
        expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "S")
        str_lat.should match expr
      end
    end
             
    # deg, format, dp
    describe '#to_lon' do
      it 'should convert 58.3 to a longitude String' do
        str_lat = Geo.to_lon(58.3)
        str_lat.should be_a(String)
        expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "E")
        str_lat.should match expr        
      end
    
      it 'should convert 58.3 to a longitude String' do
        str_lat = Geo.to_lon(-58.3)
        str_lat.should be_a(String)
        expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "W")
        str_lat.should match expr        
      end
    end
    
    # Convert numeric degrees to deg/min/sec as a bearing (0º..360º)
    # deg, format, dp      
    describe '#to_brng' do
      it 'should convert 58.3 to a longitude String' do
        brng = Geo.to_brng(-58.3)
        brng.to_f.should be_between(0, 360)
        expr = Regexp.escape "301".concat("\u00B0", "42", "\u2032", "00")
        brng.should match expr
      end
    end
  end
end
