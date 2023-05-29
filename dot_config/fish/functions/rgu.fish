function rgu -d "Ripgrep with highlighting"
  rg --json $argv | delta
end
