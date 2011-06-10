class Hash
  include GeoPoint::CoreExt  
  
  def to_lat_lng
    [to_lat, to_lng]
  end

  def to_lng_lat
    to_lat_lng.reverse
  end
  
  def to_lat
    v = Symbol.lat_symbols.select {|key| self[key] }
    return self[v.first].to_lat if !v.empty?
    raise "Hash must contain either of the keys: [:lat, :latitude] to be converted to a latitude"
  end

  def to_lng
    v = Symbol.lng_symbols.select {|key| self[key] }
    return self[v.first].to_lng if !v.empty?
    raise "Hash must contain either of the keys: [:lon, :long, :lng, :longitude] to be converted to a longitude"
  end  
end