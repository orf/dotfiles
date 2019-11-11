function temp-virtualenv -d "Create a temporary virtual environment"
   set env_dir (mktemp -d)
   python3 -m venv --prompt "temp" $env_dir
   source $env_dir/bin/activate.fish
   echo "Created virtualenv with version" (python --version)
   echo "Installing dependencies..."
   python -m pip install --upgrade pip --quiet
   if test -e ~/.config/virtualfish/global_requirements.txt
       python -m pip install -r ~/.config/virtualfish/global_requirements.txt --quiet
   end
end
