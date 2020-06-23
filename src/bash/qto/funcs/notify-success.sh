#
# Informs the user that DB provisioning is done
# and that they can start the Mojo server now.
#
# Pops up in the end of execution of DB provisioning:
# ./src/bash/qto/qto.sh -a provision-db-admin -a run-qto-db-ddl -a load-db-data-from-s3
# 
doNotifyProvisioningSuccess(){
   
   cat << EOF_FINAL_SUCCESS
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
      QTO installation completed succesfully.
	  
	  Please run this command to start the web server:
	  
      bash src/bash/qto/qto.sh -a mojo-hypnotoad-start
   :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
EOF_FINAL_SUCCESS

}
