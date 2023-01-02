CF = LibStub("AceAddon-3.0"):GetAddon("CommunityFixes")
ComChatBugFix = CF:NewModule('ComChatBugFix')
Utils = CF:GetModule('Utils')

local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ChatFrame_AddChannel = ChatFrame_AddChannel
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME

-- Blizzard BugFix
-- Fixes the issue where upon login, Community channels set to display in the chat UI, no longer show up there.
-- Furthermore, you cannot send messages or see others messages without first opening the chat settings and manually unchecking the Community box and rechecking it.
-- This module is more of a bandaid than a fix for this specific issue.

-- How It Works:
-- Upon login, register the CHANNEL_UI_UPDATE event. For 60 seconds after the user logs in, anytime that event is triggered
--  this module grabs the current channels in the chat UI, finds the Community channels, and toggles the aforementioned checkbox.
-- The biggest drawback for this "fix" is that it requires the CHANNEL_UI_UPDATE event to fire, which it may not do if the user is bankstanding.
-- If the user takes more than 60 seconds to trigger a CHANNEL_UI_UPDATE event, the fix will run once on the first time the event is fired.

-- Reasonings:
-- I'm using this event because A) the chat channels aren't loaded by OnInitialize() or OnEnable(), and they're loaded one at a time, each time firing the CHANNEL_UI_UPDATE event
-- Not all chat channels show up at the same time. Notably, the Community channels take the longest to connect/appear, thus making the decision as to when
--  to run the fix, more difficult. How do we know all of the user's Community channels have connected and are ready for the refesh? So we wait 60 seconds before
--  assuming the fix is complete (running the refresh (fix) on each event until the 60 seconds is up, or once on the first event outside the initial 60 second window).


ComChatBugFix.enabled = true  -- In future, pulled from settings or something
ComChatBugFix.requiredEvents = { "CHANNEL_UI_UPDATE" }  -- Might be used to dynamically pull together all of the modules' requiredEvents to register them OnInitialize or OnEnable
ComChatBugFix.completed = false

function ComChatBugFix:RefreshCommunityChannels(channels)
  -- Iterate through the given channels, looking for channels that start with "Community".
  -- Then removes or "unchecks" the General Config channels option, then re-adds or "checks" the config option.

  Utils:DebugPrint('Start RefreshCommunityChannels')
  -- Utils:DebugPrint(channels)

  -- This is where we'll iterate through the chat UI tabs in the next feature update.
  for k, v in pairs(channels) do
    if v['name']:find('^' .. 'Community') ~= nil then         -- if the name of the channel starts with "Community" EG. "Community:123645665:1"
      ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, v['name'])  -- Uncheck chat enable box
      ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, v['name'])     -- Recheck chat enable box
      Utils:DebugPrint('Refreshed '..v['name'])
    end
  end

  Utils:DebugPrint('End RefreshCommunityChannels')
end

function ComChatBugFix:isEnabled()
  -- Matches isCompleted(), though, isn't really used.
  return self.enabled
end

function ComChatBugFix:isCompleted()
  -- Returns the .completed prop value if self.enabled is true, otherwise, returns true.
  -- This makes it so a disabled module shows that it's "completed" it's work, for checks to see if it's done running. 
  if self.enabled == true then
    return self.completed
  else
    return true
  end
end

function ComChatBugFix:runFix()
  Utils:DebugPrint("Start ComChatBugFix runFix()")
  Within60SecondsOfLogin = GetTime() <= PlayerEnteredWorldAtTime + 60

  if Within60SecondsOfLogin then
    -- Normal and expected path most of the time. When the player logs in and becomes active (moving around, entering new zones, etc)
    Utils:DebugPrint('ComChatBugFix runFix (Within 60 seconds of login)')
    ComChatBugFix:RefreshCommunityChannels(Utils:GetJoinedChannels())
  elseif not Within60SecondsOfLogin and self.completed == false then
    -- handles the edgecase where there are no channel updates after the player has logged in. IE, they bankstand for more than a minute and have no addons to trigger the event.
    Utils:DebugPrint('ComChatBugFix runFix (Outside 60 second window, First time running)')
    ComChatBugFix:RefreshCommunityChannels(Utils:GetJoinedChannels())
    self.completed = true
  else
    self.completed = true
  end

  Utils:DebugPrint("End ComChatBugFix runFix()")
end
