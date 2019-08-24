# file: src/bash/qto/funcs/run-pgsql-scripts.func.sh

# v0.6.5
# ---------------------------------------------------------
# cat doc/txt/qto/funcs/run-pgsql-scripts.func.txt
# ---------------------------------------------------------
doRunPgsqlScripts(){

   test -z "${PROJ_INSTANCE_DIR-}" && PROJ_INSTANCE_DIR="$PRODUCT_INSTANCE_DIR"
   source $PROJ_INSTANCE_DIR/.env ; env_type=$ENV_TYPE
   test -z ${PROJ_CONF_FILE:-} && export PROJ_CONF_FILE="$PROJ_INSTANCE_DIR/cnf/env/$env_type.env.json"
   doExportJsonSectionVars $PROJ_CONF_FILE '.env.db'
	
   export tmp_log_file="$tmp_dir/.$$.log"
	doLog "INFO START :: running pg sql scripts "	
	printf "\033[2J";printf "\033[0;0H"  ;    #and flush the screen

   # if the calling shell did not have exported pgsql_scripts_dir var	
	test -z "${pgsql_scripts_dir:-}" && \
	   pgsql_scripts_dir="$PRODUCT_INSTANCE_DIR/src/sql/pgsql/qto"

   # if a relative path is passed add to the product version dir
	[[ ${pgsql_scripts_dir:-} == /* ]] || export pgsql_scripts_dir="$PRODUCT_INSTANCE_DIR"/"$pgsql_scripts_dir"
   sql_script="$pgsql_scripts_dir/""00.create-db.pgsql"
   
   # run the sql save the result into a tmp log file
   PGPASSWORD="${postgres_db_useradmin_pw:-}" psql -v ON_ERROR_STOP=1 -q -t -X -w -U "${postgres_db_useradmin:-}" \
      -h $postgres_db_host -p $postgres_db_port -v postgres_db_name="${postgres_db_name:-}" \
      -f "$sql_script" postgres > "$tmp_log_file" 2>&1
   ret=$?
   doLog "INFO ret: $ret" 
   
   cat "$tmp_log_file" # show it 

   test $ret -ne 0 && sleep 3
   test $ret -ne 0 && doExit 1 "pid: $$ psql ret $ret - failed to run sql_script: $sql_script !!!"
   test $ret -ne 0 && break
 
	cat "$tmp_log_file" # show it 
	cat "$tmp_log_file" >> $log_file # save it

	test -z "${is_sql_biz_as_usual_run:-}" || sleep 1 ; 
	printf "\033[2J";printf "\033[0;0H"  ;    #and flush the screen
	
	doLog "INFO should run the following sql files: "
   echo -e "\n\n"
	find "$pgsql_scripts_dir" -type f -name "*.sql"|sort -n

	# run the sql scripts in alphabetical order
   while read -r sql_script ; do 

		relative_sql_script=$(echo $sql_script|perl -ne "s#$PRODUCT_INSTANCE_DIR##g;print")

		# give the poor dev a time to see what is happening
		test -z "${is_sql_biz_as_usual_run:-}" || sleep $sleep_interval ; 

		# and clear the screen
		printf "\033[2J";printf "\033[0;0H"

		doLog "INFO START ::: running $relative_sql_script"
		echo -e '\n\n'
		# run the sql save the result into a tmp log file
      PGPASSWORD="${postgres_db_useradmin_pw:-}" psql -v ON_ERROR_STOP=1 -q -t -X -w \
         -h $postgres_db_host -p $postgres_db_port -U "${postgres_db_useradmin:-}" \
         -v postgres_db_name="$postgres_db_name" -f "$sql_script" "$postgres_db_name" > "$tmp_log_file" 2>&1
      ret=$?

		# show the user what is happenning 
		cat "$tmp_log_file"
      test $ret -ne 0 && sleep 3
      test $ret -ne 0 && doExit 1 "pid: $$ psql ret $ret - failed to run sql_script: $sql_script !!!"
      test $ret -ne 0 && break

		# and save the tmp log file into the script log file
		cat "$tmp_log_file" >> $log_file
		echo -e '\n\n'

		doLog "INFO STOP  ::: running $relative_sql_script"
	done < <(find "$pgsql_scripts_dir" -type f -name "*.sql"|sort -n)
	
	doLog "INFO STOP  :: running sql scripts "	
	test -z "${is_sql_biz_as_usual_run:-}" || sleep $sleep_interval ; 
	
	printf "\033[2J";printf "\033[0;0H"  ;    #and flush the screen
	doLog "DEBUG STOP  doRunPgsqlScripts"
}


# eof file: src/bash/qto/funcs/run-pgsql-scripts.func.sh
