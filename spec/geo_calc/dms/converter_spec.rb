require 'spec_helper'

class Parser
  include GeoCalc::Dms::Converter
end

def parser
  Parser.new
end

# - www.movable-type.co.uk/scripts/latlong.html
describe GeoCalc::Dms::Converter do
  # # @param   {String|Number} dmsStr: Degrees or deg/min/sec in variety of formats
  # @returns {Number} Degrees as decimal number
  describe '#parse_dms' do
    it 'should convert "58 38 38N" to a Float of degrees (58..59)' do
      deg = parser.parse_dms("58 38 38N")
      deg.should be_a(Float)
      deg.should be_between(58, 59)
    end

    it 'should convert "01 38 38W" to a Float of degrees (1..2)' do
      deg = parser.parse_dms("01 38 38W")
      deg.should be_a(Float)
      deg.should < 0
      deg.should > -2       
    end

    it 'should convert "005 38 E" to a Float of degrees (5..6)' do
      deg = parser.parse_dms("005 38 E")
      deg.should be_a(Float)
      deg.should be_between(5, 6)
    end
  end

  # deg, format = :dms, dp = 0
  describe '#to_dms' do
    it 'should convert 58.3 to a String in DMS format' do
      dms = parser.to_dms(58.3)
      dms.should be_a(String)
      expr = Regexp.escape "058".concat("\u00B0", "18", "\u2032", "00", "\u2033")
      dms.should match expr
    end
  
    it 'should convert 58.3 to a String in DM format' do
      dm = parser.to_dms(58.3, :dm, 2)
      dm.should be_a(String)
      expr = Regexp.escape "058".concat("\u00B0", "18", "\u2032")
      dm.should match expr
    end
  
    it 'should convert 58.3 to a String in D format' do
      d = parser.to_dms(58.3, :d, 2)
      d.should be_a(String)
      m = Regexp.escape "058".concat("\u00B0")
      d.should match m
    end
  end  
end

