CommunityFixes = LibStub("AceAddon-3.0"):NewAddon("CommunityFixes")

CommunityFixes.Version = "1.0.0"


function GetJoinedChannels()
  -- 
  local channels = {}
  local chanList = { GetChannelList() }
  for i = 1, #chanList, 3 do
    table.insert(channels, {
      id = chanList[i],
      name = chanList[i + 1],
      isDisabled = chanList[i + 2], -- Not sure what a state of "blocked" would be
    })
  end
  return channels
end

function FixCommunityChannels(channels)
  -- Iterate through the given channels, looking for channels that start with "Community".
  -- Then removes or "unchecks" the General Config channels option, then re-adds or "checks" the config option.
  for k, v in ipairs(channels) do
    if v['name']:find('^' .. 'Community') ~= nil then -- if the name of the channel starts with "Community" EG. "Community:123645665:1"
      ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, v['name'])  -- Uncheck chat enable box
      ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, v['name'])     -- Recheck chat enable box
    end
  end
  print('CommunityFixes: Refreshed Community Channels')
end

function CommunityFixes:OnInitialize()
  print('CommunityFixes: Initialized')
  FixCommunityChannels(GetJoinedChannels())
end
