doSetUpPythonVenv(){

   which pip3 2>/dev/null || { 
		if [[ "$OSTYPE" == "darwin"* ]]; then
			brew install python3; brew postinstall python3 ; fi
		if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
			sudo apt update; sudo apt install -y python3-pip; fi

		which pip3 2>/dev/null || { 
			echo >&2 "The pip3 binary is missing ! Install it manually ! Aborting ..."; exit 1; 
		}
	}

   pip3 install virtualenv
   python3 -m venv ./venv
   pip3 install -r $PRODUCT_INSTANCE_DIR/cnf/python/requirements.txt
	sleep 1 ; clear_the_screen

   installed_python_modules=$(cat $PRODUCT_INSTANCE_DIR/cnf/python/requirements.txt)

   cat << EOF
   installed the following python modules: 
		$installed_python_modules
   listed in the following file: 
		 $PRODUCT_INSTANCE_DIR/cnf/python/requirements.txt
  
	# to activate the venv 
	cd $PRODUCT_INSTANCE_DIR
	source ./venv/bin/activate

   # you MIGHT have to 
   pip3 install -r $PRODUCT_INSTANCE_DIR/cnf/python/requirements.txt

   # to exit the venv, run the following command
   deactivate

EOF
}