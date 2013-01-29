function centerText(mon, text, fill)
  w, h = mon.getSize()
  fw = (w-string.len(text))/2
  
  if fill == nil then
    fill = "-"
  end
  
  ft = string.rep(fill, fw)
  
  return ft..text..ft
end

function writeAt(mon, x, y, msg, color)
  if color ~= nil then
    mon.setTextColor(color)
  end
  mon.setCursorPos(x, y)
  mon.write(msg)
  mon.setTextColor(colors.white)
end

function readAt(mon, x, y, msg)
  writeAt(x, y, msg)
  return read()
end
