;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CritiCAL IRC Script v2.0 - Auto-join Module                               ;;
;; by sorzkode                                                               ;;
;; https://github.com/sorzkode/circ                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; On Load Event Handler - Added functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:LOAD:*:{
  if (%ajoin.version == $null) {
    set %ajoin.version 2.0.0
  }
  echo -a ✅ CritiCAL Auto-join Module Loaded - See @cIRC window for details
  ; Create custom window for detailed output
  if (!$window(@cIRC)) window @cIRC
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 📂 CritiCAL IRC Script - Auto-join Module Loaded
  echo @cIRC 👤 Author: sorzkode
  echo @cIRC 🔗 GitHub: https://github.com/sorzkode/circ
  echo @cIRC 📅 Version: %ajoin.version
  echo @cIRC ✨ Features:
  echo @cIRC   • Auto-join channels on connect with optional keys
  echo @cIRC   • Easy management through a graphical interface
  echo @cIRC   • Channel list sorting and organization
  echo @cIRC   • Export/Import channel lists
  echo @cIRC 🛠️ Commands:
  echo @cIRC   • /ajoin - Open the Auto-join Module dialog
  echo @cIRC   • /ajoin_help - Display help information
  echo @cIRC   • /ajoin_stats - View script statistics
  echo @cIRC   • /ajoin_reset_stats - Reset statistics
  echo @cIRC   • /ajoin_view_vars - View script variables
  echo @cIRC   • /ajoin_export - Export channels list
  echo @cIRC   • /ajoin_import - Import channels list
  echo @cIRC   • /ajoin_disable - Disable the Auto-join Module
  echo @cIRC   • /ajoin_enable - Enable the Auto-join Module
  echo @cIRC   • /ajoin_unload - Unload the script completely
  echo @cIRC ──────────────────────────────────────────────────────────

  ; Initialize settings on first load if they don't exist
  if (%ajoin.delay == $null) {
    set %ajoin.delay 2
  }
  ; Initialize stats if they don't exist
  if (%ajoin.stats.joins == $null) {
    set %ajoin.stats.joins 0
  }
  if (%ajoin.stats.sessions == $null) {
    set %ajoin.stats.sessions 0
  }
  if (%ajoin.stats.added == $null) {
    set %ajoin.stats.added 0
  }
  if (%ajoin.stats.removed == $null) {
    set %ajoin.stats.removed 0
  }

  set %ajoin.status on
  halt
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; On Unload Event Handler - Added functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:UNLOAD:*:{ 
  echo -a ──────────────────────────────────────────────────────────
  echo -a 📂 CritiCAL IRC Script - Auto-join Module Unloaded
  echo -a ❌ All Auto-join Module functionality has been removed
  echo -a 📝 To reload the script, use: /load -rs modules/ajoin.mrc
  echo -a ──────────────────────────────────────────────────────────
  unset %ajoin.status
  halt
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stats Functions - New functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin_stats {
  ; Calculate current channel counts
  var %ajoin.stats.channels = $numtok(%ajoin.channels,44)
  var %ajoin.stats.channels.key = $numtok(%ajoin.channels.key,44)
  var %ajoin.stats.total = $calc(%ajoin.stats.channels + %ajoin.stats.channels.key)
  
  ; Display stats in @cIRC window
  echo -a ✅ See @cIRC window for stats
  if (!$window(@cIRC)) window @cIRC
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 📊 CritiCAL IRC Auto-join Module Statistics
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 📋 Current Configuration:
  echo @cIRC   • Total channels in list: %ajoin.stats.total
  echo @cIRC   • Channels without keys: %ajoin.stats.channels
  echo @cIRC   • Channels with keys: %ajoin.stats.channels.key
  echo @cIRC   • Join delay: %ajoin.delay seconds
  echo @cIRC   • Module status: $iif(%ajoin.status == on,✅ Enabled,❌ Disabled)
  echo @cIRC 📈 Usage Statistics:
  echo @cIRC   • Total channels joined: %ajoin.stats.joins
  echo @cIRC   • Auto-join sessions: %ajoin.stats.sessions
  echo @cIRC   • Channels added: %ajoin.stats.added
  echo @cIRC   • Channels removed: %ajoin.stats.removed
  echo @cIRC   • Average channels/session: $iif(%ajoin.stats.sessions > 0,$calc(%ajoin.stats.joins / %ajoin.stats.sessions),0)
  echo @cIRC ──────────────────────────────────────────────────────────
}

alias ajoin_reset_stats {
  set %ajoin.stats.joins 0
  set %ajoin.stats.sessions 0
  set %ajoin.stats.added 0
  set %ajoin.stats.removed 0
  echo -a ✅ AJOIN: Statistics have been reset
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables viewer - New functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin_view_vars {
  echo -a ✅ See @cIRC window for variables
  if (!$window(@cIRC)) window @cIRC
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 🔧 CritiCAL IRC Auto-join Module Variables
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 💲Script Version: %ajoin.version = $iif(%ajoin.version != $null,%ajoin.version,2.0.0)
  echo @cIRC 📌 Configuration Variables:
  echo @cIRC   • %ajoin.status = $iif(%ajoin.status != $null,%ajoin.status,<not set>)
  echo @cIRC   • %ajoin.delay = $iif(%ajoin.delay != $null,%ajoin.delay,<not set>)
  echo @cIRC 📋 Channel Lists:
  echo @cIRC   • %ajoin.channels = $iif(%ajoin.channels != $null,%ajoin.channels,<empty>)
  echo @cIRC   • %ajoin.channels.key = $iif(%ajoin.channels.key != $null,%ajoin.channels.key,<empty>)
  echo @cIRC 📊 Statistics Variables:
  echo @cIRC   • %ajoin.stats.joins = $iif(%ajoin.stats.joins != $null,%ajoin.stats.joins,0)
  echo @cIRC   • %ajoin.stats.sessions = $iif(%ajoin.stats.sessions != $null,%ajoin.stats.sessions,0)
  echo @cIRC   • %ajoin.stats.added = $iif(%ajoin.stats.added != $null,%ajoin.stats.added,0)
  echo @cIRC   • %ajoin.stats.removed = $iif(%ajoin.stats.removed != $null,%ajoin.stats.removed,0)
  echo @cIRC ──────────────────────────────────────────────────────────
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; About dialog - New functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin_about {
  echo -a ✅ See @cIRC window for details
  if (!$window(@cIRC)) window @cIRC
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 🌟 About CritiCAL IRC Auto-join Module
  echo @cIRC ──────────────────────────────────────────────────────────
  echo @cIRC 📦 Script Information:
  echo @cIRC   • Name: CritiCAL IRC Auto-join Module
  echo @cIRC   • Version: %ajoin.version
  echo @cIRC   • Author: sorzkode
  echo @cIRC   • License: MIT
  echo @cIRC   • Repository: https://github.com/sorzkode/circ
  echo @cIRC 📝 Description:
  echo @cIRC   This module provides automatic channel joining functionality
  echo @cIRC   for mIRC with support for channel keys, join delays, and
  echo @cIRC   comprehensive channel list management.
  echo @cIRC ✨ Key Features:
  echo @cIRC   • Automatic channel joining on connect
  echo @cIRC   • Support for channels with keys
  echo @cIRC   • Configurable join delay to avoid flooding
  echo @cIRC   • Import/Export channel lists
  echo @cIRC   • Usage statistics tracking
  echo @cIRC   • Cross-network support
  echo @cIRC 🌐 Updates & Support:
  echo @cIRC   Visit the GitHub repository for latest updates,
  echo @cIRC   bug reports, and feature requests.
  echo @cIRC ──────────────────────────────────────────────────────────
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom Command Aliases - Added functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin_help {
  echo -a ⌛ Loading helpfile...
  
  ; Set the local help file path (using $mircdir for absolute path)
  var %local.helpfile = $mircdir $+ docs/helpfiles/ajoin.html
  
  ; Check if the file exists
  if ($exists(%local.helpfile)) {
    ; Try to run the local file
    run %local.helpfile
    echo -a ✅ Success...check your browser!
  }
  else {
    ; Local file doesn't exist
    ajoin_help_error
  }
}

alias -l ajoin_help_error {
  echo -a ❌ Could not find local help file
  echo -a 🔄 Attempting to load online documentation...
  
  ; Small delay before opening online version
  .timer 1 1 ajoin_help_github
}

alias ajoin_help_github {
  echo -a 🌐 Opening online help documentation from GitHub...
  
  ; Open the GitHub hosted version
  var %github.url = https://github.com/sorzkode/circ/blob/main/docs/helpfiles/ajoin.html
  
  ; Try to open the URL
  run %github.url
  echo -a 📋 If the page doesn't open, please visit manually: %github.url
}

alias ajoin_unload {
  echo -a 🔄 Unloading CritiCAL IRC Auto-join Module...
  .unload -rs $script
}

; Added new aliases for enable/disable functionality
alias ajoin_enable {
  if (%ajoin.status == on) {
    echo -a ⚠️ Auto-join Module is already enabled.
    return
  }
  set %ajoin.status on
  echo -a ✅ Auto-join Module has been enabled.
}

alias ajoin_disable {
  if (%ajoin.status != on) {
    echo -a ⚠️ Auto-join Module is already disabled.
    return
  }
  set %ajoin.status off
  echo -a ❌ Auto-join Module has been disabled.

  ; Close ajoin dialog if it's open
  if ($dialog(ajoin)) { dialog -x ajoin }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Export/Import Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin_export {
  ; Let user select export filename
  var %ajoin.export.file = $sfile(ajoin_channels.txt,Save channel list as,Save)
  if (!%ajoin.export.file) {
    echo -a ❌ AJOIN: Export cancelled
    return
  }

  ; Open file for writing
  if ($exists(%ajoin.export.file)) { .remove %ajoin.export.file }
  
  var %ajoin.export.total = 0
  
  ; Export channels without keys
  if (%ajoin.channels != $null) {
    var %ajoin.export.i = 1
    while (%ajoin.export.i <= $numtok(%ajoin.channels,44)) {
      write %ajoin.export.file $gettok(%ajoin.channels,%ajoin.export.i,44)
      inc %ajoin.export.total
      inc %ajoin.export.i
    }
  }
  
  ; Export channels with keys
  if (%ajoin.channels.key != $null) {
    var %ajoin.export.i = 1
    while (%ajoin.export.i <= $numtok(%ajoin.channels.key,44)) {
      write %ajoin.export.file $gettok(%ajoin.channels.key,%ajoin.export.i,44)
      inc %ajoin.export.total
      inc %ajoin.export.i
    }
  }
  
  echo -a ✅ AJOIN: Exported %ajoin.export.total channels to %ajoin.export.file
}

alias ajoin_import {
  ; Let user select import filename
  var %ajoin.import.file = $sfile(*.txt,Select channel list to import,Import)
  if (!%ajoin.import.file) {
    echo -a ❌ AJOIN: Import cancelled
    return
  }
  
  if (!$exists(%ajoin.import.file)) {
    echo -a ❌ AJOIN: File not found: %ajoin.import.file
    return
  }
  
  var %ajoin.import.lines = $lines(%ajoin.import.file)
  var %ajoin.import.i = 1
  var %ajoin.import.imported = 0
  var %ajoin.import.skipped = 0
  
  ; Process each line
  while (%ajoin.import.i <= %ajoin.import.lines) {
    var %ajoin.import.line = $read(%ajoin.import.file,%ajoin.import.i)
    
    ; Skip empty lines
    if (%ajoin.import.line != $null) {
      var %ajoin.import.channel = $gettok(%ajoin.import.line,1,32)
      var %ajoin.import.key = $gettok(%ajoin.import.line,2,32)
      
      ; Validate channel name
      if (%ajoin.import.channel != $null) {
        ; Add # prefix if missing
        if ($left(%ajoin.import.channel,1) != $chr(35)) %ajoin.import.channel = $chr(35) $+ %ajoin.import.channel
        
        ; Check if channel name is valid (no spaces in channel part)
        if (!$regex(%ajoin.import.channel,/^#[^\s]+$/)) {
          echo -a ⚠️ AJOIN: Skipped invalid channel: %ajoin.import.line
          inc %ajoin.import.skipped
        }
        else {
          ; Add to appropriate list
          if (%ajoin.import.key != $null) {
            ; Check if key contains spaces
            if ($regex(%ajoin.import.key,/\s/)) {
              echo -a ⚠️ AJOIN: Skipped channel with invalid key: %ajoin.import.line
              inc %ajoin.import.skipped
            }
            else {
              ; Add to channels with keys
              set %ajoin.channels.key $addtok(%ajoin.channels.key,%ajoin.import.channel $+ $chr(32) $+ %ajoin.import.key,44)
              inc %ajoin.import.imported
              inc %ajoin.stats.added
            }
          }
          else {
            ; Add to channels without keys
            set %ajoin.channels $addtok(%ajoin.channels,%ajoin.import.channel,44)
            inc %ajoin.import.imported
            inc %ajoin.stats.added
          }
        }
      }
    }
    inc %ajoin.import.i
  }
  
  echo -a ✅ AJOIN: Import complete - Imported: %ajoin.import.imported channels, Skipped: %ajoin.import.skipped invalid entries
  
  ; Refresh dialog if open
  if ($dialog(ajoin)) {
    dialog -x ajoin
    dialog -dmrvo ajoin ajoin
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Popups for menus - New functionality
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu status,channel,query,nicklist {
  CritiCAL IRC
  .Auto-join
  ..Open:/ajoin
  ..Help:/ajoin_help
  ..Toggle Status:{ 
    if (%ajoin.status == on) {
      ajoin_disable
    }
    else {
      ajoin_enable
    }
  }
  ..Unload:/ajoin_unload
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ----- Original Alias Section with Enhancements -----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ajoin {
  ; Check if Module is enabled
  if (%ajoin.status != on) {
    echo -a ❌ Auto-join Module is not currently enabled.
    echo -a 🧑🏻‍🏫 Please use /ajoin_enable to enable.
    return
  }

  ; Opens the Auto-join configuration dialog
  dialog -dmrvo ajoin ajoin
}

alias ajoin_newchan {
  ; Adds a new channel to the auto-join list
  var %ajoin.input.channel = $did(ajoin,3), %ajoin.input.key, %ajoin.display.text

  ; Input validation - Check if channel is empty
  if (%ajoin.input.channel == $null) {
    echo -a ❌ ERROR: Channel name cannot be empty!
    return
  }

  ; Check for spaces in channel name
  if ($regex(%ajoin.input.channel, /\s/)) {
    echo -a ❌ ERROR: Channel name cannot contain spaces!
    return
  }

  ; Add # prefix if not present
  if ($left(%ajoin.input.channel,1) != $chr(35)) %ajoin.input.channel = $chr(35) $+ %ajoin.input.channel

  ; Handle channel key if provided
  if ($did(ajoin,5)) {
    ; Check for spaces in key
    if ($regex($did(ajoin,5), /\s/)) {
      echo -a ❌ ERROR: Channel key cannot contain spaces!
      return
    }

    ; Add the key emoji in the display version
    %ajoin.display.text = %ajoin.input.channel $+ $chr(32) $+ 🗝️ $+ $chr(32) $+ $did(ajoin,5)
    ; Store the actual join command without the emoji
    %ajoin.input.key = %ajoin.input.channel $+ $chr(32) $+ $did(ajoin,5)
  }

  ; Store in appropriate variable based on whether key exists
  if (%ajoin.input.key) {
    set %ajoin.channels.key $addtok(%ajoin.channels.key,%ajoin.input.key,44)
    ; Add formatted display text to the list
    did -a ajoin 9 %ajoin.display.text
  }
  else {
    set %ajoin.channels $addtok(%ajoin.channels,%ajoin.input.channel,44)
    ; Add channel to the list
    did -a ajoin 9 %ajoin.input.channel
  }

  ; Update stats
  inc %ajoin.stats.added

  ; Reset input fields
  did -r ajoin 3,5
  did -f ajoin 3

  echo -a 💾 AJOIN: Added $iif(%ajoin.input.key,%ajoin.display.text,%ajoin.input.channel) to auto-join list
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ----- Enhanced Dialog Definition -----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dialog ajoin {
  title "CritiCAL Auto-join Module"
  size -1 -1 350 165
  icon images/ajoin.ico
  option dbu

  ; Channel input section
  box "Add Channel", 1, 2 5 170 55
  text "Channel:", 2, 5 14 30 10
  edit "", 3, 35 14 125 10, autohs
  text "Key (optional):", 4, 5 28 45 10
  edit "", 5, 50 28 70 10
  text "💡 Enter name w/ or w/o # prefix", 6, 5 42 150 10
  button "➕ Add", 7, 120 28 40 10, flat

  ; Channel list section
  box "Channel / Key List", 8, 175 5 170 145
  list 9, 180 14 160 125, sort
  button "🗑️ Remove Selected", 10, 180 132 80 10, flat
  button "🧹 Clear All", 11, 265 132 75 10, flat

  ; Options section - Modified to include Reset button
  box "Options", 12, 2 65 170 30
  text "Join delay (seconds):", 13, 5 75 60 10
  edit "", 14, 70 75 25 10
  button "Reset", 19, 100 75 25 10, flat

  ; Network info
  box "Network", 15, 2 100 170 50
  text "Current Network:", 16, 5 110 50 10
  edit "", 17, 60 110 100 10, read
  text "Auto-join variables will be used across all networks", 18, 5 125 150 10, disabled
  
  ; Menu - Enhanced
  menu "&File", 23
  item "&Import List", 24
  item "&Export List", 25
  item "&Update", 26
  item "&Exit", 27
  menu "&Tools", 28
  item "&Reset Stats", 30
  menu "&View", 32
  item "&Stats", 33
  item "&Variables", 34
  menu "&Help", 35
  item "&About", 36
  item "&Help", 37
  item "&Website", 38
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ----- Enhanced Dialog Event Handlers -----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:DIALOG:ajoin:menu:24:{ 
  ; Import List
  ajoin_import
}

on *:DIALOG:ajoin:menu:25:{ 
  ; Export List
  ajoin_export
}

on *:DIALOG:ajoin:menu:26:{ 
  ; Download repo
  run https://github.com/sorzkode/circ/archive/refs/heads/main.zip
}

on *:DIALOG:ajoin:menu:30:{ 
  ; Reset Stats
  ajoin_reset_stats
}

on *:DIALOG:ajoin:menu:33:{ 
  ; View Stats
  ajoin_stats
}

on *:DIALOG:ajoin:menu:34:{ 
  ; View Variables
  ajoin_view_vars
}

on *:DIALOG:ajoin:menu:36:{ 
  ; About
  ajoin_about
}

on *:DIALOG:ajoin:menu:37:{ 
  ; Display help information
  ajoin_help
}

on *:DIALOG:ajoin:menu:38:{ 
  ; Open GitHub site
  .timer 1 0 /run https://github.com/sorzkode/circ/
}

; Added handler for Exit menu item
on *:DIALOG:ajoin:menu:27:{
  dialog -x ajoin
}

on *:DIALOG:ajoin:init:0: {
  ; Check if Module is enabled, if not, show warning and close dialog
  if (%ajoin.status != on) {
    echo -a ❌ Auto-join Module is currently disabled.
    echo -a 🧑🏻‍🏫 Please use /ajoin_enable to enable before opening the dialog.
    dialog -x ajoin
    return
  }

  ; Initialize dialog with saved channels and keys
  var %ajoin.init.chan = 1, %ajoin.init.key = 1

  ; Set text fields - ensure delay is set properly
  if (%ajoin.delay == $null) {
    set %ajoin.delay 2
  }
  did -o ajoin 14 1 %ajoin.delay
  did -o ajoin 17 1 $network

  ; Check if reset button should be enabled
  if (%ajoin.delay == 2) {
    did -b ajoin 19
  }

  ; Add channels without keys
  while (%ajoin.init.chan <= $numtok(%ajoin.channels,44)) {
    did -a ajoin 9 $gettok(%ajoin.channels,%ajoin.init.chan,44)
    inc %ajoin.init.chan
  }

  ; Add channels with keys (format for display with emoji)
  var %ajoin.init.key = 1
  while (%ajoin.init.key <= $numtok(%ajoin.channels.key,44)) {
    var %ajoin.init.entry = $gettok(%ajoin.channels.key,%ajoin.init.key,44)
    var %ajoin.init.chan.part = $gettok(%ajoin.init.entry,1,32)
    var %ajoin.init.key.part = $gettok(%ajoin.init.entry,2,32)
    if (%ajoin.init.key.part) {
      did -a ajoin 9 %ajoin.init.chan.part $+ $chr(32) $+ 🗝️ $+ $chr(32) $+ %ajoin.init.key.part
    }
    else {
      did -a ajoin 9 %ajoin.init.entry
    }
    inc %ajoin.init.key
  }

  did -f ajoin 3
}

on *:DIALOG:ajoin:edit:14: {
  ; Save delay value when edited
  var %ajoin.delay.input = $did(ajoin,14)
  if (%ajoin.delay.input isnum 0-300) {
    set %ajoin.delay %ajoin.delay.input
    echo -a 💾 AJOIN: Join delay set to %ajoin.delay.input seconds
    
    ; Enable/disable reset button
    if (%ajoin.delay == 2) {
      did -b ajoin 19
    }
    else {
      did -e ajoin 19
    }
  }
  else {
    echo -a ❌ ERROR: Delay must be a number between 0 and 300
    did -o ajoin 14 1 %ajoin.delay
  }
}

on *:DIALOG:ajoin:sclick:7: {
  ; Handle Add button click
  ajoin_newchan
}

on *:DIALOG:ajoin:sclick:19: {
  ; Handle Reset button click
  set %ajoin.delay 2
  did -o ajoin 14 1 2
  did -b ajoin 19
  echo -a ✅ AJOIN: Join delay reset to default (2 seconds)
}

on *:DIALOG:ajoin:sclick:10: {
  ; Handle Remove button click - with validation
  if ($did(ajoin,9).sel == $null) {
    if ($did(ajoin,9).lines == 0) {
      echo -a ❌ ERROR: No channels in the list to remove!
    }
    else {
      echo -a ❌ ERROR: No channel selected! Please select a channel first.
    }
    return
  }

  var %ajoin.remove.line = $did(ajoin,9).sel
  var %ajoin.remove.text = $did(ajoin,9,%ajoin.remove.line)

  ; Remove the item from the list
  did -d ajoin 9 $did(ajoin,9).sel 

  ; Remove from appropriate variable (key or non-key)
  if ($pos(%ajoin.remove.text,🗝️)) {
    ; This is a channel with a key - format: #channel 🗝️ key
    ; Extract the channel and key for removal from %ajoin.channels.key
    var %ajoin.remove.channel = $gettok(%ajoin.remove.text,1,32)
    var %ajoin.remove.key = $gettok(%ajoin.remove.text,3,32)
    set %ajoin.channels.key $remtok(%ajoin.channels.key,%ajoin.remove.channel $+ $chr(32) $+ %ajoin.remove.key,1,44)
  }
  else {
    ; This is a channel without a key
    set %ajoin.channels $remtok(%ajoin.channels,%ajoin.remove.text,1,44)
  }

  ; Update stats
  inc %ajoin.stats.removed

  echo -a 🗑️ AJOIN: Removed %ajoin.remove.text from auto-join list
}

; Double-click handler for removing items from the list
on *:DIALOG:ajoin:dclick:9: {
  ; Handle double-click on list item (ID 9)
  ; This reuses the same removal logic as the Remove button
  
  if ($did(ajoin,9).sel == $null) {
    return
  }

  var %ajoin.dclick.line = $did(ajoin,9).sel
  var %ajoin.dclick.text = $did(ajoin,9,%ajoin.dclick.line)

  ; Remove the item from the list
  did -d ajoin 9 $did(ajoin,9).sel 

  ; Remove from appropriate variable (key or non-key)
  if ($pos(%ajoin.dclick.text,🗝️)) {
    ; This is a channel with a key - format: #channel 🗝️ key
    ; Extract the channel and key for removal from %ajoin.channels.key
    var %ajoin.dclick.channel = $gettok(%ajoin.dclick.text,1,32)
    var %ajoin.dclick.key = $gettok(%ajoin.dclick.text,3,32)
    set %ajoin.channels.key $remtok(%ajoin.channels.key,%ajoin.dclick.channel $+ $chr(32) $+ %ajoin.dclick.key,1,44)
  }
  else {
    ; This is a channel without a key
    set %ajoin.channels $remtok(%ajoin.channels,%ajoin.dclick.text,1,44)
  }

  ; Update stats
  inc %ajoin.stats.removed

  echo -a 🗑️ AJOIN: Removed %ajoin.dclick.text from auto-join list (double-click)
}

on *:DIALOG:ajoin:sclick:11: {
  ; Handle Clear All button click with validation
  if ($did(ajoin,9).lines == 0) {
    echo -a ❌ ERROR: No channels in the list to clear!
    return
  }

  ; Update stats before clearing
  var %ajoin.clear.count = $did(ajoin,9).lines
  inc %ajoin.stats.removed %ajoin.clear.count

  ; Clear the entire list and variables
  did -r ajoin 9
  unset %ajoin.channels
  unset %ajoin.channels.key
  
  echo -a 🧹 AJOIN: Cleared all channels from auto-join list
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ----- IRC Events -----
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:CONNECT: {
  ; Check if Auto-join is enabled
  if (%ajoin.status != on) { return }

  ; Check if any channels are configured
  if ((%ajoin.channels == $null) && (%ajoin.channels.key == $null)) { return }

  ; Ensure delay has a default value
  if (%ajoin.delay == $null) {
    set %ajoin.delay 2
  }

  ; Increment session counter
  inc %ajoin.stats.sessions

  ; Delay join if configured
  if (%ajoin.delay > 0) {
    echo -a 🔄 AJOIN: Will join channels in %ajoin.delay seconds...
    .timer 1 %ajoin.delay ajoin_perform_join
  }
  else {
    ajoin_perform_join
  }
}

; Separated join function for timer use
alias -l ajoin_perform_join {
  var %ajoin.join.count = 0

  ; Join channels without keys
  if (%ajoin.channels != $null) {
    echo -a 🚪 AJOIN: Joining channels: %ajoin.channels
    .raw JOIN %ajoin.channels
    inc %ajoin.join.count $numtok(%ajoin.channels,44)
  }

  ; Join channels with keys
  if (%ajoin.channels.key != $null) {
    var %ajoin.join.i = 1
    while (%ajoin.join.i <= $numtok(%ajoin.channels.key,44)) {
      echo -a 🔑 AJOIN: Joining channel with key: $gettok(%ajoin.channels.key,%ajoin.join.i,44)
      .raw JOIN $gettok(%ajoin.channels.key,%ajoin.join.i,44)
      inc %ajoin.join.i
      inc %ajoin.join.count
    }
  }

  ; Update join statistics
  inc %ajoin.stats.joins %ajoin.join.count
}