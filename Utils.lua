CF = LibStub("AceAddon-3.0"):GetAddon("CommunityFixes")
Utils = CF:NewModule('Utils')

local GetChannelList = GetChannelList
local DEBUG = false

function Utils:DebugPrint(text)
  local txt = text
  if DEBUG == true then
    print("["..GetTime().."] CommunityFixes: "..tostring(txt))
  end
end

function Utils:GetJoinedChannels()
  -- Returns a table of channels the user has already joined. These channels are found in the Chat > Settings > Channels
  Utils:DebugPrint('Start GetChannelList')

  local channels = {}
  local chanList = { GetChannelList() }
  for i = 1, #chanList, 3 do
    table.insert(channels, {
      id = chanList[i],
      name = chanList[i + 1],
      isDisabled = chanList[i + 2],
    })
  end

  Utils:DebugPrint('Num Channels Found: '..#channels)
  Utils:DebugPrint('End GetChannelList')
  return channels
end
