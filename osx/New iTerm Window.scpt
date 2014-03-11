tell app "System Events"
  tell process "iTerm"
    click menu item "New Window" of menu "Shell" of menu bar 1
  end tell
end tell
tell app "iTerm"
  activate
end tell
