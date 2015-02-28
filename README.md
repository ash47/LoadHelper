LoadHelper
==========

A small library to make loading in dota 2 custom games more reliable by allowing infinite wait times.

###Setup Guide###
 - Copy `resource/flash3/loadhelper.swf` into your `resource/flash3` folder
 - Add the following strings into your `resource/addon_english.txt`
  - "LH_Resume"     "Toggle Resume"
  - "LH_Quit"       "Cancel Lobby"
  - "LH_Confirm"    "Confirm"
 - Manually add the UI code from `resource/flash3/custom_ui.txt`
  - Note: Each element needs a uniqueID, if "1" is already taken, just call this "2" for example.
  - The depth doesn't really matter
 - Copy the event from `scripts/custom_events.txt` into your `scripts/custom_events.txt` file.
 - Copy `scripts/vscripts/lib/loadhelper.lua` into your `scripts/vscripts/lib` folder
 - Open your `scripts/vscripts/addon_game_mode.lua`
  - Add `require('lib.loadhelper')` anywhere in the gloabal scope of the file (if not sure, just put it at the very top of the file)
  - Call `loadhelper.init()` somewhere inside the Activate() event

###Stat Collection###
 - If you have the [stat collection module](http://getdotastats.com/#d2mods__guide) installed, three new stats will be available under the loadHelper module:
  - **enabled:** This will be true if the module successfully loaded
  - **quit**: This will be true if the Cancel Lobby button was used to close the lobby
  - **duration**: This represents the total time, in second, it took from when the module first paused the game (when the host loaded), to when everybody was fully connected to the game. If the host chooses to pause the match again after everyone has connected, this extra pause time will NOT be counted.
  - **hostSlotID** The slot of the hoster
