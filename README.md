LoadHelper
==========

A small library to make loading in dota 2 custom games more reliable by allowing infinite wait times.

###Setup Guide###
 - Copy `resource/flash3/loadhelper.swf` into your `resource/flash3` folder
 - Add the following strings into your `resource/addon_english.txt`
  - "LH_Resume"     "Toggle Resume"
  - "LH_Quit"       "Return To Lobby"
 - Manually add the UI code from `resource/flash3/custom_ui.txt`
  - Note: Each element needs a uniqueID, if "1" is already taken, just call this "2" for example.
  - The depth doesn't really matter
 - Copy the event from `scripts/custom_events.txt` into your `scripts/custom_events.txt` file.
 - Copy `scripts/vscripts/lib/loadhelper.lua` into your `scripts/vscripts/lib` folder
 - Open your `scripts/vscripts/addon_game_mode.lua`
  - Add `require('lib.loadhelper')` anywhere in the gloabal scope of the file (if not sure, just put it at the very top of the file)
