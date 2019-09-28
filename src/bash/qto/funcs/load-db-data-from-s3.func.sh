#
# the following db dump in the s3 of the aws credentials owning user should exist:
# https://s3-$AWS_DEFAULT_REGION.amazonaws.com/$bucket/"$ENV_TYPE"_$RUN_UNIT"'.latest.insrts.dmp.sql
# 
doLoadDbDataFromS3(){
   
   test -z "${PROJ_INSTANCE_DIR-}" && PROJ_INSTANCE_DIR="$PRODUCT_INSTANCE_DIR"
   source $PROJ_INSTANCE_DIR/.env ; env_type=$ENV_TYPE
   doExportJsonSectionVars $PROJ_INSTANCE_DIR/cnf/env/$env_type.env.json '.env.db'
   doExportJsonSectionVars $PROJ_INSTANCE_DIR/cnf/env/$env_type.env.json '.env.aws'

   mkdir -p $PRODUCT_INSTANCE_DIR/dat/sql/

   # fetch the db inserts data from the s3 bucket - to be parametrized for env ...
   echo wget -O "$PRODUCT_INSTANCE_DIR/dat/sql/"$ENV_TYPE'_'$RUN_UNIT".latest.insrts.dmp.sql" \
      "https://s3-$AWS_DEFAULT_REGION.amazonaws.com/$bucket/"$ENV_TYPE"_$RUN_UNIT"'.latest.insrts.dmp.sql'

   # configure psql to access the db of THIS instance
   PGPASSWORD=${postgres_db_useradmin_pw:-} psql -v -t -X -w -U ${postgres_db_useradmin:-} \
      --port $postgres_db_port --host $postgres_db_host -d $postgres_db_name < \
         "$PRODUCT_INSTANCE_DIR/dat/sql/$ENV_TYPE"'_'"$RUN_UNIT"'.latest.insrts.dmp.sql'

   test -f $PRODUCT_INSTANCE_DIR/dat/tmp/bootstrapping && rm -v $PRODUCT_INSTANCE_DIR/dat/tmp/bootstrapping

}
