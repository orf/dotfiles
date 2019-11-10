function open-project -d "Open a project in PyCharm"
  set result (cd-project $argv)
  if string length -q -- $result
    charm $result
  end
end
