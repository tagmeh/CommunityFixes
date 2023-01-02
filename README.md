# CommunityFixes
A World of Warcraft addon built to fix some of the issues with the Communities feature.

Future Features  
- Configuration option to set the Community chat color and have it persist across characters (who are also in the same community).
- Update the initial fix (Persistent Chat on Login) to cycle through all chat UI tabs instead of just the default tab (General) (Testing to see if this is even necessary)

Current Fixes:  
- **Bug/Issue: Community chat doesn't display in default chat window after login.**  
**Solved:** Yes (runs automatically)  
**Solution caveats:** Due to the nature of how chat channels connect (slowly), the solution is applied a few times for up to 60 seconds after the player logs in. The solution is only triggered when the chat channels update (joining a group, moving to a new zone). Therefore, if you login and bankstand, and there are no updates to your chat channels, this fix won't be applied immediately. (Working on manually triggered a channel update maybe 20 seconds after login to account for this).

Version 1.1.0
- Modularized code into individual files.

Version 1.0.0  
- Persistent Chat on Login: Implements a solution for when, on a fresh login/relog, the Community channel is assigned a chat number (eg /4), but text sent to that channel doesn't show up in the chat box or the Community chat until the user manually uhchecks/checks a chatbox setting.