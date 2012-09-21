class GeoDirectionMisMatch < StandardError; end;

class String
  def to_rad
    parse_dms.to_rad
  end

  def trim
    strip
  end

  def geo_clean
    self.gsub(/^\(/, '').gsub(/\)$/, '').trim
  end
    
  def to_lat_lng  
    a = geo_clean.split(',').map(&:strip)
    a = (a.last.is_a?(String) && a.last =~ /[N|S]$/) ? a.reverse : a
    a.to_lat_lng
  end

  def to_lng_lat  
    a = geo_clean.split(',')
    a = (a.last.is_a?(String) && a.last =~ /[N|S]$/) ? a.reverse : a    
    a.to_lng_lat
  end
  
  def to_lat
    raise "An empty String has no latitude" if self.empty?
    s = geo_clean
    raise GeoDirectionMisMatch, "Direction E and W signify longitude and thus can't be converted to latitude, was: #{self}" if s =~ /[W|E]$/
    s = s.parse_dms if s.respond_to? :parse_dms
  rescue GeoUnits::Converter::Dms::ParseError
  ensure
    s.to_f.to_lat
  end

  def to_lng
    raise "An empty String has no latitude" if self.empty?
    s = geo_clean                 
    raise GeoDirectionMisMatch, "Direction N and S signify latitude and thus can't be converted to longitude, was: #{self}" if s =~ /[N|S]$/
    s = s.parse_dms if s.respond_to? :parse_dms    
  rescue GeoUnits::Converter::Dms::ParseError
  ensure    
    s.to_f.to_lng
  end
end