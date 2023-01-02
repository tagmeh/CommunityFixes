CommunityFixes = LibStub("AceAddon-3.0"):GetAddon("CommunityFixes")
ComChatBugFix = CommunityFixes:GetModule('ComChatBugFix')
Utils = CommunityFixes:GetModule('Utils')

-- Future Code Updates
-- Reorganize code into utils and per-fix files once I figure out how to import other files.
-- Add debug/logging instead of print statments, if that's possible.


local GetTime = GetTime
-- BugFixes in the array will be called by the specified event type in order to preform their duty
local ChannelUiUpdateEventFixes = { ComChatBugFix }

-- Array of events that need to be registered upon login/reload
local Events = { "CHANNEL_UI_UPDATE" }


function CommunityFixes:CHANNEL_UI_UPDATE()
  -- Iterates over the array corresponding to this Event (ChannelUiUpdateEventFixes)
  -- Calls the "runFix" method on each BugFix object/table, if it's .enabled property is true.
  -- Once all the BugFix items finish their jobs, (.isCompleted() is true), unregister the Event
  Utils:DebugPrint("Start CHANNEL_UI_UPDATE")

  for i=1, #ChannelUiUpdateEventFixes do
    Utils:DebugPrint("Iterating over BugFixes - Call .runFix() ")
    if ChannelUiUpdateEventFixes[i]:isEnabled() and not ChannelUiUpdateEventFixes[i]:isCompleted() then -- If BugFix is enabled and not already ran to completion.
      Utils:DebugPrint("BugFix is enabled and not complete. Calling .runFix()")
      ChannelUiUpdateEventFixes[i]:runFix()                                                             -- Run respective fix
      Utils:DebugPrint("Post .runFix()")
    end
  end

  -- After running the enabled BugFixes, check if we can unregister this event.
  for i=1, #ChannelUiUpdateEventFixes do
    Utils:DebugPrint("Iterating over BugFixes - Unregister Event")
    -- If the BugFix is not completed, don't unregister the Event.
    if ChannelUiUpdateEventFixes[i]:isCompleted() ~= true then
      Utils:DebugPrint("Still have at least 1 BugFix not complete. Don't unregister yet.")
        break -- No reason to keep checking if even 1 BugFix is still incomplete
    end
    -- Only runs if all BugFixes within ChannelUiUpdateEventFixes are completed
    CommunityFixes:UnregisterEvent('CHANNEL_UI_UPDATE')
    Utils:DebugPrint("Unregistered Event 'CHANNEL_UI_UPDATE'")
  end

  Utils:DebugPrint("End CHANNEL_UI_UPDATE")
end

function CommunityFixes:OnInitialize()
  Utils:DebugPrint('Start Initalizing')
  PlayerEnteredWorldAtTime = GetTime()
  Utils:DebugPrint('End Initialization')
end

function CommunityFixes:OnEnable()
  Utils:DebugPrint('Start OnEnable')

  -- Register each event in the Events array
  for i=1, #Events do
    CommunityFixes:RegisterEvent(Events[i])
    Utils:DebugPrint("Registered Event: "..Events[i])
  end

  Utils:DebugPrint('End OnEnable')
end
