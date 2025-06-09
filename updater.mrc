; === Config ===
alias script.version return 1.0.0
alias script.url return https://raw.githubusercontent.com/yourusername/yourrepo/main/script.mrc
alias script.name return myscript.mrc

; === Menu Item ===
menu * {
  Update Script: check_for_update
}

; === Check for update ===
alias check_for_update {
  if ($sock(updatecheck)) sockclose updatecheck
  echo -a Checking for script updates...
  ; Use SSL for HTTPS connection
  sockopen -e updatecheck raw.githubusercontent.com 443
}

on *:sockopen:updatecheck: {
  if ($sockerr > 0) {
    echo -a Error: Unable to connect to update server (Error: $sockerr)
    return
  }
  
  ; Extract path from URL for raw.githubusercontent.com
  var %path = $remove($script.url, https://raw.githubusercontent.com)
  
  sockwrite -tn $sockname GET %path HTTP/1.1
  sockwrite -tn $sockname Host: raw.githubusercontent.com
  sockwrite -tn $sockname User-Agent: mIRC-Script-Updater/1.0
  sockwrite -tn $sockname Connection: close
  sockwrite -tn $sockname $crlf
}

on *:sockread:updatecheck: {
  var %data
  sockread %data
  if ($sockerr > 0) {
    echo -a Error reading update data (Error: $sockerr)
    sockclose updatecheck
    return
  }
  
  ; Skip HTTP headers until we reach the content
  if (%data == $null) {
    set %update.reading.content 1
    return
  }
  
  if (!%update.reading.content) return
  
  ; Look for version line in the script content
  if (%data isin alias script.version return) {
    var %remotever = $gettok(%data, 4, $chr(32))
    unset %update.reading.content
    
    if (%remotever == $null) {
      echo -a Error: Could not parse remote version
      sockclose updatecheck
      return
    }
    
    var %comparison = $versioncmp(%remotever, $script.version)
    if (%comparison > 0) {
      echo -a New version available: %remotever (current: $script.version)
      set %update.new.version %remotever
      dialog -m updateprompt updateprompt
    }
    else {
      echo -a Your script is up to date (v $+ $script.version $+ )
    }
    sockclose updatecheck
  }
}

; === Compare Versions ===
alias versioncmp {
  var %a = $1, %b = $2
  if (%a == %b) return 0
  
  var %i = 1
  while ($gettok(%a, %i, 46) != $null || $gettok(%b, %i, 46) != $null) {
    var %x = $gettok(%a, %i, 46), %y = $gettok(%b, %i, 46)
    if (%x == $null) var %x = 0
    if (%y == $null) var %y = 0
    
    ; Convert to numbers for proper comparison
    if (%x > %y) return 1
    if (%x < %y) return -1
    inc %i
  }
  return 0
}

; === Update Prompt Dialog ===
dialog updateprompt {
  title "Script Update Available"
  size -1 -1 250 120
  option dbu
  
  text "A new version is available:", 1, 10 15 180 10
  text "Current: v $+ $script.version", 2, 10 30 100 10
  text "Latest: v $+ %update.new.version", 3, 10 42 100 10
  text "Download the new version?", 4, 10 60 180 10
  
  button "Download", 5, 50 85 50 15, ok
  button "Cancel", 6, 130 85 50 15, cancel
}

on *:dialog:updateprompt:init:0: {
  ; Update dialog text with actual version numbers
  did -o updateprompt 2 1 Current: v $+ $script.version
  did -o updateprompt 3 1 Latest: v $+ %update.new.version
}

on *:dialog:updateprompt:sclick:5: {
  ; Download the latest script
  echo -a Opening download URL in browser...
  run $script.url
  echo -a Please save the file as $script.name and reload it with: /load -rs $script.name
  unset %update.new.version
  dialog -x updateprompt
}

on *:dialog:updateprompt:sclick:6: {
  ; Cancel update
  unset %update.new.version
  echo -a Update cancelled.
}

; === Cleanup on close ===
on *:dialog:updateprompt:close:0: {
  unset %update.new.version
}

; === Auto-cleanup on unload ===
on *:unload: {
  unset %update.*
  if ($sock(updatecheck)) sockclose updatecheck
}