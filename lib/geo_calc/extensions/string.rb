class String
  include ::GeoPoint::CoreExtension
  
  def concat *args
    args.inject(self) do |res, arg| 
      res << arg.to_s
      res
    end
  end

  def parse_dms
    GeoCalc::Dms::Converter.parse_dms self
  end

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
    raise "An empty String has no latitude" if empty?
    geo_clean.parse_dms.to_f.to_lat
  end

  def to_lng
    raise "An empty String has no latitude" if empty?
    geo_clean.parse_dms.to_f.to_lng
  end
end