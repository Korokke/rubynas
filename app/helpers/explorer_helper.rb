module ExplorerHelper
  FILE_SIZE_UNITS = %w{K M G T P E Z Y}
  def byte2pretty(bytes)
    if bytes < 1024
      return bytes.to_s + " B"
    else
      # ln byte / ln 1024 = log 1024 byte => byte는 1024의 몇 제곱인가
      pos = (Math.log(bytes) / Math.log(1024)).floor
      pos = FILE_SIZE_UNITS.size if pos >= FILE_SIZE_UNITS.size
      unit = FILE_SIZE_UNITS[pos - 1] + "B"
      size = (bytes * 10) / (1024 ** pos)
      if (size % 10 == 0)
        return "%d %s" % [size / 10, unit]
      else
        return "%.1f %s" % [size.to_f * 0.1, unit]
      end
    end
  end
end
