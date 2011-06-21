class Array    
  def to_lat_lng
    raise "Array must contain at least two elements to be converted to latitude and longitude" if !(size >= 2)
    [to_lat, to_lng]
  end 

  def to_lng_lat
    [to_lng, to_lat]
  end 

  # Assumes by default that the order is lat, lng
  # If GeoPoint is defined, can reverse this order depending on #coord_mode class variable
  def to_lat
    raise "Array must contain at least one element to return the latitude" if empty?
    subject, other = (defined?(GeoPoint) && GeoPoint.respond_to?(:coord_mode) && GeoPoint.coord_mode == :lng_lat) ? [self[1], first] : [first, self[1]]
    
    begin
      subject.to_lat
    rescue GeoDirectionMisMatch
      other.to_lat
    end    
  end

  # see(#to_lat)
  def to_lng
    raise "Array must contain at least two elements to return the longitude" if !self[1]
    subject, other = (defined?(GeoPoint) && GeoPoint.respond_to?(:coord_mode) && GeoPoint.coord_mode == :lng_lat) ? [first, self[1]] : [self[1], first]
    begin
      subject.to_lng
    rescue GeoDirectionMisMatch
      other.to_lng
    end
  end
  
  def trim
    join.trim
  end
end
