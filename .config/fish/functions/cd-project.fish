function cd-project -d "Move to a project"
  set filter "$argv"
  set chosen_project (git workspace list | fzf -q "$filter")
  if string length -q -- $chosen_project
     pushd $GIT_WORKSPACE/$chosen_project
     return $GIT_WORKSPACE/$chosen_project
  end
end
