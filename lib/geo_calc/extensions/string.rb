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
    geo_clean.split(',').to_lat_lng
  end

  def to_lng_lat  
    geo_clean.split(',').to_lng_lat
  end
  
  def to_lat
    raise "An empty String has no latitude" if self.empty?
    s = geo_clean
    s = s.parse_dms if s.respond_to? :parse_dms
    s.to_f.to_lat
  end

  def to_lng
    raise "An empty String has no latitude" if self.empty?
    s = geo_clean
    s = s.parse_dms if s.respond_to? :parse_dms    
    s.to_f.to_lng
  end
end