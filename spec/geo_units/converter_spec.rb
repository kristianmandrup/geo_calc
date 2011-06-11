require 'spec_helper'

class Converter
  include GeoUnits::Converter
end

def converter
  Converter.new
end

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoUnits::Converter do
  # deg, format, dp      
  describe '#to_lat' do
    it 'should convert 58.3 to a latitude String in North direction' do
      str_lat = converter.to_lat(58.3)
      str_lat.should be_a(String)
      expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "N")
      str_lat.should match expr
    end

    it 'should convert -58.3 to a latitude String in South direction' do
      str_lat = converter.to_lat(-58.3)
      str_lat.should be_a(String)
      expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "S")
      str_lat.should match expr
    end
  end
         
  # deg, format, dp
  describe '#to_lon' do
    it 'should convert 58.3 to a longitude String' do
      str_lat = converter.to_lon(58.3)
      str_lat.should be_a(String)
      expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "E")
      str_lat.should match expr        
    end

    it 'should convert 58.3 to a longitude String' do
      str_lat = converter.to_lon(-58.3)
      str_lat.should be_a(String)
      expr = Regexp.escape "58".concat("\u00B0", "18", "\u2032", "00", "\u2033", "W")
      str_lat.should match expr        
    end
  end

  # Convert numeric degrees to deg/min/sec as a bearing (0º..360º)
  # deg, format, dp      
  describe '#to_brng' do
    it 'should convert 58.3 to a longitude String' do
      brng = converter.to_brng(-58.3)
      brng.to_f.should be_between(0, 360)
      expr = Regexp.escape "301".concat("\u00B0", "42", "\u2032", "00")
      brng.should match expr
    end
  end
end