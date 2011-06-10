class Array
  include GeoPoint::CoreExt
  
  def to_lat_lng
    raise "Array must contain at least two elements to be converted to latitude and longitude" if !(size >= 2)
    [to_lat, to_lng]
  end 

  def to_lng_lat
    to_lat_lng.reverse
  end 

  def to_lat
    raise "Array must contain at least one element to return the latitude" if empty?
    first.to_lat
  end

  def to_lng
    raise "Array must contain at least two elements to return the longitude" if !self[1]
    self[1].to_lng
  end
  
  def trim
    join.trim
  end
end
