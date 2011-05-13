require 'geo_calc/core_ext'

 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #  Geodesy representation conversion functions (c) Chris Veness 2002-2010
 #   - www.movable-type.co.uk/scripts/latlong.html
 #
 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

# Parses string representing degrees/minutes/seconds into numeric degrees
# 
# This is very flexible on formats, allowing signed decimal degrees, or deg-min-sec optionally
# suffixed by compass direction (NSEW). A variety of separators are accepted (eg 3º 37' 09"W) 
# or fixed-width format without separators (eg 0033709W). Seconds and minutes may be omitted. 
# (Note minimal validation is done).
# 
# @param   {String|Number} dmsStr: Degrees or deg/min/sec in variety of formats
# @returns {Number} Degrees as decimal number
# @throws  ArgumentError

module Geo
  extend self  
  extend ::NumericCheckExt
  include ::NumericCheckExt
  
  def parse_dms dms_str  
    # check for signed decimal degrees without NSEW, if so return it directly
    return dms_str if is_numeric?(dms_str)
  
    # strip off any sign or compass dir'n & split out separate d/m/s
    dms = dms_str.trim.gsub(/^-/,'').gsub(/[NSEW]$/i,'').split(/[^0-9.,]+/).map(&:trim).map(&:to_f)
    return nil if dms.empty?
  
    # and convert to decimal degrees...
    deg = case dms.length      
    when 3 # interpret 3-part result as d/m/s
       dms[0]/1 + dms[1]/60 + dms[2]/3600
    when 2 # interpret 2-part result as d/m
      dms[0]/1 + dms[1]/60        
    when 1 # just d (possibly decimal) or non-separated dddmmss        
      d = dms[0];
      # check for fixed-width unseparated format eg 0033709W
      d = "0#{d}" if (/[NS]/i.match(dms_str)) # - normalise N/S to 3-digit degrees
      d = "#{d.slice(0,3)/1}#{deg.slice(3,5)/60}#{deg.slice(5)/3600}" if (/[0-9]{7}/.match(deg)) 
      d
    else
      nil
    end
    return nil if !deg
    deg = (deg * -1) if (/^-|[WS]$/i.match(dms_str.trim)) # take '-', west and south as -ve
    deg.to_f
  end

  # Convert decimal degrees to deg/min/sec format
  #  - degree, prime, double-prime symbols are added, but sign is discarded, though no compass
  #    direction is added
  # 
  # 
  # @param   {Number} deg: Degrees
  # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
  # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
  # @returns {String} deg formatted as deg/min/secs according to specified format
  # @throws  {TypeError} deg is an object, perhaps DOM object without .value?

  def to_dms deg, format = :dms, dp = nil
    deg = begin
      deg.to_f
    rescue
      nil
    end
    return nil if !deg # give up here if we can't make a number from deg   
  
    # default values
    format ||= :dms
    dp = if dp.nil?
      case format.to_sym
      when :d 
        4
      when :dm 
        2
      else
        0 # default
      end
    end
    dp ||= 0
  
    deg = deg.abs # (unsigned result ready for appending compass dir'n)
  
    case format
    when :d
      d = deg.round(dp)       # round degrees
      ds = "0#{d}" if (d <100)    # pad with leading zeros
      ds = "0#{ds}" if (d <10) 
      dms = ds.to_s.concat("\u00B0")  # add º symbol
    when :dm            
      min = (deg*60).round(dp)   # convert degrees to minutes & round
      d = d.to_i
      d = (min / 60).floor          # get component deg/min
      m = (min % 60).round(dp)   # pad with trailing zeros
      ds = d
      ms = m
      ds = "0#{d}" if (d<100)        # pad with leading zeros
      ds = "0#{d}" if (d<10)
      ms = "0#{m}" if (m<10)               
      dms = ds.to_s.concat("\u00B0", ms, "\u2032") # add º, ' symbols
    when :dms
      sec = (deg * 3600).round   # convert degrees to seconds & round
      d = (sec / 3600).floor          # get component deg/min/sec
      m = ((sec / 60) % 60).floor
      s = (sec % 60).round(dp)     # pad with trailing zeros
      ds = 
      ms = m
      ss = s
      ds = "0#{d}" if (d < 100)          # pad with leading zeros
      ds = "0#{ds}" if (d < 10) 
      ms = "0#{m}" if (m < 10) 
      ss = "0#{s}" if (s < 10) 
      dms = ds.to_s.concat("\u00B0", ms, "\u2032", ss, "\u2033")  # add º, ', " symbols
    end
    return dms
  end


  # Convert numeric degrees to deg/min/sec latitude (suffixed with N/S)
  # 
  # @param   {Number} deg: Degrees
  # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
  # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
  # @returns {String} Deg/min/seconds

  def to_lat deg, format = :dms, dp = 0
    _lat = to_dms deg, format, dp
    _lat == '' ? '' : _lat[1..-1] + (deg<0 ? 'S' : 'N')  # knock off initial '0' for lat!
  end


  # Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)
  # 
  # @param   {Number} deg: Degrees
  # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
  # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
  # @returns {String} Deg/min/seconds

  def to_lon deg, format = :dms, dp = 0
    lon = to_dms deg, format, dp
    lon == '' ? '' : lon + (deg<0 ? 'W' : 'E')
  end


  # Convert numeric degrees to deg/min/sec as a bearing (0º..360º)
  # 
  # @param   {Number} deg: Degrees
  # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
  # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for dms, 2 for dm, 4 for d
  # @returns {String} Deg/min/seconds

  def to_brng deg, format = :dms, dp = 0
    deg = (deg.to_f + 360) % 360  # normalise -ve values to 180º..360º
    brng =  to_dms deg, format, dp
    brng.gsub /360/, '0'  # just in case rounding took us up to 360º!
  end 
  
  protected

  include NumericCheckExt
end

class String
  include ::Geo
end