class GeoPoint
  module CoreExtension
    def to_coords    
      send(:"to_#{GeoPoint.coord_mode}")
    end

    def geo_point
      GeoPoint.new to_coords
    end
  end
end
