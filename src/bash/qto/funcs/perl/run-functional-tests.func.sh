# src/bash/qto/funcs/run-functional-tests.func.sh

# v0.6.7
# ---------------------------------------------------------
# implement the calls to all the functional tests
# ---------------------------------------------------------
doRunFunctionalTests(){
  
   export QTO_ONGOING_TEST=1
   test -z ${qto_project:-} && \
      source "$product_instance_dir/lib/bash/funcs/parse-cnf-env-vars.sh" && \
      doParseCnfEnvVars "$product_instance_dir/cnf/$run_unit.$env_type.*.cnf"
   
   test -z $sleep_interval && sleep_interval=1
	doLog "DEBUG START : doRunFunctionalTests"

	doLog "INFO START Component testing Initiator.pm with TestInitiator "
	perl src/perl/qto/t/TestInitiator.pl
	sleep $sleep_interval; clearTheScreen ; 

	doLog "INFO START Component testing Configurator.pm with TestInitiator "
   perl src/perl/qto/t/lib/Qto/App/Utils/TestConfigurator.pl
	sleep $sleep_interval; clearTheScreen ; 

	doLog "INFO START Component testing Dispatcher.pm with TestDispatcher.pl"
   perl src/perl/qto/t/TestDispatcher.pl	
	sleep $sleep_interval; clearTheScreen ; 
	
   doLog "INFO START Component testing Model.pm with TestModel.pl"
   perl src/perl/qto/t/TestModel.pl	
	sleep $sleep_interval; clearTheScreen ; 

   doLog "INFO START Unit testing or the SetGetable base module " 
   perl src/perl/qto/t/lib/Qto/App/Utils/OO/TestSetGetable.pl
	sleep $sleep_interval; clearTheScreen ; 
   
   doLog "INFO START Unit testing or the AutoLoadable  base module" 
   perl src/perl/qto/t/lib/Qto/App/Utils/OO/TestAutoLoadable.pl
	sleep $sleep_interval; clearTheScreen ; 

   doLog "INFO START Unit testing or the Command Line Reader module" 
   perl src/perl/qto/t/TestRdrCmdArgs.pl
	sleep $sleep_interval; clearTheScreen ; 

   doLog "INFO START Unit testing or the CnrXlsHsr3ToDbHsr3 module" 
   perl src/perl/qto/t/lib/Qto/App/Cnvr/TestCnrXlsHsr3ToDbHsr3.pl
	sleep $sleep_interval; clearTheScreen ; 

   doLog "INFO START testing controllers"
   find src/perl/qto/t/lib/Qto/Controller/ -type f -name '*.pl' -exec perl {} \;
   doLog "INFO STOP  testing controllers"
	sleep $sleep_interval; clearTheScreen ; 

   export QTO_ONGOING_TEST=0
}


# eof file: src/bash/qto/funcs/run-functional-tests.func.sh
