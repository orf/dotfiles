function open-github -d "Open a project in Github"
  set url (git remote get-url origin)
  set path (echo "$url" | rg "git@github.com:(([A-Za-z0-9-]{1,})/([A-Za-z0-9-]{1,})).git\$" -r '$1')
  open https://github.com/$path
end
