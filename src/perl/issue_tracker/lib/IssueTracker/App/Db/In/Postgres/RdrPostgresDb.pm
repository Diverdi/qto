package IssueTracker::App::Db::In::Postgres::RdrPostgresDb ; 

   use strict ; use warnings ; use utf8 ; 

   require Exporter; 
   use AutoLoader ; 
	use Encode qw( encode_utf8 is_utf8 );
   use POSIX qw(strftime);
   use DBI ; 
	use Data::Printer ; 
	use Carp ; 

   use IssueTracker::App::Utils::Logger ; 
   use IssueTracker::App::Mdl::Model ; 

   our $module_trace                            = 0 ; 
   our $IsUnitTest                              = 0 ; 
	our $appConfig 										= {} ; 
	our $objLogger 										= {} ; 
	our $objModel                                = {} ; 
	our $postgres_db_name                        = q{} ; 
	our $db_host 										   = q{} ; 
	our $db_port 										   = q{} ;
	our $postgres_db_user 							   = q{} ; 
	our $postgres_db_user_pw	 					   = q{} ; 
	our $web_host 											= q{} ; 

   
   
   sub doSelectTablesList {

      my $self             = shift ; 
      my $objModel         = ${shift @_ } ; 

      my $msg              = q{} ;         
      my $ret              = 1 ;          # this is the return value from this method 
      my $debug_msg        = q{} ; 
      my $hsr              = {} ;         # this is meta hash describing the data hash ^^
      my $sth              = {} ;         # this is the statement handle
      my $dbh              = {} ;         # this is the database handle
      my $str_sql          = q{} ;        # this is the sql string to use for the query
      
      if ( defined $objModel->get('postgres_db_name') ) {
		   $postgres_db_name = $objModel->get('postgres_db_name');
      }
      
      $str_sql = " 
      SELECT  
           table_catalog 
         , table_schema 
         , table_name 
         , ROW_NUMBER () OVER (ORDER BY table_name) as row_id
      FROM information_schema.tables  
      WHERE 1=1 
      AND table_type = 'BASE TABLE' 
      AND table_schema = 'public' 
      ORDER BY table_type, table_name
      ;
      " ; 

      # authentication src: http://stackoverflow.com/a/19980156/65706
      $debug_msg .= "\n postgres_db_name: $postgres_db_name \n db_host: $db_host " ; 
      $debug_msg .= "\n postgres_db_user: $postgres_db_user \n postgres_db_user_pw $postgres_db_user_pw \n" ; 
      # $objLogger->doLogDebugMsg ( $debug_msg ) ; 
     
      $dbh = DBI->connect("dbi:Pg:dbname=$postgres_db_name", "", "" , {
                 'RaiseError'          => 1
               , 'ShowErrorStatement'  => 1
               , 'PrintError'          => 1
               , 'AutoCommit'          => 1
               , 'pg_utf8_strings'     => 1
      } ) or $msg = DBI->errstr;
      
      # src: http://www.easysoft.com/developer/languages/perl/dbd_odbc_tutorial_part_2.html
      $sth = $dbh->prepare($str_sql);  

      $sth->execute()
            or $objLogger->error ( "$DBI::errstr" ) ;

      $hsr = $sth->fetchall_hashref( 'row_id' ) ; 
      $objModel->set('hsr2' , $hsr);
      # p($hsr )  ; 
      binmode(STDOUT, ':utf8');

      $msg = DBI->errstr ; 

      unless ( defined ( $msg ) ) {
         $msg = 'SELECT tables-list OK ' ; 
         $ret = 0 ; 
      } else {
         $objLogger->doLogErrorMsg ( $msg ) ; 
      }

      # src: http://search.cpan.org/~rudy/DBD-Pg/Pg.pm  , METHODS COMMON TO ALL HANDLES
      $debug_msg        = 'doSelectTablesList ret ' . $ret ; 
      $objLogger->doLogDebugMsg ( $debug_msg ) ; 

      $appConfig->{ "$postgres_db_name".'.tables-list'} = $hsr ;
      return ( $ret , $msg , $hsr ) ; 	
   }
   # eof sub doSelectTablesList


   sub table_exists {
      my $self       = shift ; 
      my $db         = shift ; 
      my $table      = shift ; 
      my $ret        = 1 ; 

      my $table_exists = 0 ; 
      my $hsr2 = {} ; 
      my $msg  = () ; 

      unless ( defined ( $appConfig->{"$db" . '.tables-list'} ) ) {
         ($ret, $msg) = $self->doSelectTablesList(\$objModel);
         $hsr2 = $objModel->get('hsr2');
         return $table_exists unless $ret == 0 ; 
      } 

      $hsr2 = $appConfig->{"$db" . '.tables-list'} ; 

      for my $key ( keys %$hsr2 ) {
         my $table_name = $hsr2->{ $key }->{'table_name'} ; 
         if ( $table eq $table_name ) {
            $table_exists = 1 ; 
            $msg = ' the table exists ' ; 
            return $table_exists ; 
         }
      }
      return $table_exists ; 
   }

   #
   # -----------------------------------------------------------------------------
   # retrieve the single row from db by guid
   # -----------------------------------------------------------------------------
   sub doSelectItemByGuid {

      my $self             = shift ; 
      my $db               = shift ; 
      my $table            = shift || 'daily_issues' ;  # the table to get the data from  
      my $guid             = shift ; 
      
      my $msg              = q{} ;         
      my $ret              = 1 ;          # this is the return value from this method 
      my $debug_msg        = q{} ; 
      my $hsr              = {} ;         # this is hash ref of hash refs to populate with
      my $sth              = {} ;         # this is the statement handle
      my $dbh              = {} ;         # this is the database handle
      my $str_sql          = q{} ;        # this is the sql string to use for the query


      $str_sql = 
         " SELECT 
         * FROM $table 
         WHERE 1=1
         AND guid = '" . $guid . "'
         ;
      " ; 

      # authentication src: http://stackoverflow.com/a/19980156/65706
      $debug_msg .= "\n postgres_db_name: $postgres_db_name \n db_host: $db_host " ; 
      $debug_msg .= "\n postgres_db_user: $postgres_db_user \n postgres_db_user_pw $postgres_db_user_pw \n" ; 
      $objLogger->doLogDebugMsg ( $debug_msg ) ; 
     

      $dbh = DBI->connect("dbi:Pg:dbname=$db", "", "" , {
                 'RaiseError'          => 1
               , 'ShowErrorStatement'  => 1
               , 'PrintError'          => 1
               , 'AutoCommit'          => 1
               , 'pg_utf8_strings'     => 1
      } ) or $msg = DBI->errstr;
      
      $sth = $dbh->prepare($str_sql);  

      $sth->execute()
            or $objLogger->error ( "$DBI::errstr" ) ;

      $hsr = $sth->fetchall_hashref( 'guid' ) ; 
      binmode(STDOUT, ':utf8');
      p( $hsr ) if $module_trace == 1 ; 

      $msg = DBI->errstr ; 
      $objLogger->doLogDebugMsg ( $msg ) ; 

      unless ( defined ( $msg ) ) {
         $msg = 'SELECT OK for table: ' . "$table" ; 
         $ret = 0 ; 
      } else {
         $objLogger->doLogErrorMsg ( $msg ) ; 
      }

      $debug_msg        = ' ret ' . $ret ; 
      $objLogger->doLogDebugMsg ( $debug_msg ) ; 
      
      return ( $ret , $msg , $hsr ) ; 	
   }
   # eof sub doSelectItemByGuid



   sub doSelectTablesColumnList {

      my $self          = shift ; 
      my $table         = shift || 'daily_issues' ; 


      my $msg              = q{} ;         
      my $ret              = 1 ;          # this is the return value from this method 
      my $debug_msg        = q{} ; 
      my $mhsr             = {} ;         # this is meta hash describing the data hash ^^
      my $sth              = {} ;         # this is the statement handle
      my $dbh              = {} ;         # this is the database handle
      my $str_sql          = q{} ;        # this is the sql string to use for the query
      
      $str_sql = " 
         SELECT attnum, attname, attlen
         FROM   pg_attribute
         WHERE  attrelid = '" . lc($table) . "'::regclass
         AND    attnum > 0
         AND    NOT attisdropped
         ORDER  BY attnum
      ;
      " ; 

      # authentication src: http://stackoverflow.com/a/19980156/65706
      # debug $debug_msg .= "\n postgres_db_name: $postgres_db_name \n db_host: $db_host " ; 
      # debug $debug_msg .= "\n postgres_db_user: $postgres_db_user \n postgres_db_user_pw $postgres_db_user_pw \n" ; 
      # debug $objLogger->doLogDebugMsg ( $debug_msg ) ; 
     
      $dbh = DBI->connect("dbi:Pg:dbname=$postgres_db_name", "", "" , {
                 'RaiseError'          => 1
               , 'ShowErrorStatement'  => 1
               , 'PrintError'          => 1
               , 'AutoCommit'          => 1
               , 'pg_utf8_strings'     => 1
      } ) or $msg = DBI->errstr;
      
      # src: http://www.easysoft.com/developer/languages/perl/dbd_odbc_tutorial_part_2.html
      $sth = $dbh->prepare($str_sql);  

      $sth->execute()
            or $objLogger->error ( "$DBI::errstr" ) ;

      $mhsr = $sth->fetchall_hashref( 'attnum' ) ; 
      binmode(STDOUT, ':utf8');
      p( $mhsr ) if $module_trace == 1 ; 

      $msg = DBI->errstr ; 

      unless ( defined ( $msg ) ) {
         $msg = 'SELECT meta OK for table: ' . "$table" ; 
         $ret = 0 ; 
      } else {
         $objLogger->doLogErrorMsg ( $msg ) ; 
      }

      # src: http://search.cpan.org/~rudy/DBD-Pg/Pg.pm  , METHODS COMMON TO ALL HANDLES
      
      return ( $ret , $msg , $mhsr ) ; 	
   }
   # eof sub doSelectTablesColumnList



   #
   # -----------------------------------------------------------------------------
   # get ALL the table data into hash ref of hash refs 
   # -----------------------------------------------------------------------------
   sub doSearchConfigurationEntries {

      my $self             = shift ; 
      my $postgres_db_name          = shift || 'ysg_issues' ; # the default db
      my $table            = shift || 'confs' ;  # the table to get the data from  
      my $query_str        = shift || '*' ;  # the table to get the data from  
   

      $objLogger->doLogDebugMsg ( "doSearchConfigurationEntries table: $table " ) ; 

      my $msg              = q{} ;         
      my $ret              = 1 ;          # this is the return value from this method 
      my $debug_msg        = q{} ; 
      my $hsr              = {} ;         # this is hash ref of hash refs to populate with
      my $sth              = {} ;         # this is the statement handle
      my $dbh              = {} ;         # this is the database handle
      my $str_sql          = q{} ;        # this is the sql string to use for the query


      $str_sql = 
         " SELECT 
         guid, value as name FROM $table 
         WHERE 1=1
         AND value like '%" . $query_str . "%'
         ;
      " ; 

     
      $dbh = DBI->connect("dbi:Pg:dbname=$postgres_db_name", "", "" , {
                 'RaiseError'          => 1
               , 'ShowErrorStatement'  => 1
               , 'PrintError'          => 1
               , 'AutoCommit'          => 1
               , 'pg_utf8_strings'     => 1
      } ) or $msg = DBI->errstr;
      
      $sth = $dbh->prepare($str_sql);  

      $sth->execute()
            or $objLogger->error ( "$DBI::errstr" ) ;



		my @query_output = () ; 
      # LOOP THROUGH RESULTS
      binmode(STDOUT, ':utf8');
      while ( my $row = $sth->fetchrow_hashref ){
          my %hash = %$row ;
          #say "UTF8 flag is turned on in the STRING $key" if is_utf8( $hash{$key} );
          push @query_output, $row
          #if is_utf8( $hash{$key} );
      } #eof while
      
		$msg = DBI->errstr ; 

      unless ( defined ( $msg ) ) {
         $msg = 'SELECT OK for table: ' . "$table" ; 
         $ret = 0 ; 
      } else {
         $objLogger->doLogErrorMsg ( $msg ) ; 
      }

      # CLOSE THE DATABASE CONNECTION
      $dbh->disconnect();
      
		# src: http://search.cpan.org/~rudy/DBD-Pg/Pg.pm  , METHODS COMMON TO ALL HANDLES
      $debug_msg        = 'doInsertSqlHashData ret ' . $ret ; 
      $objLogger->doLogDebugMsg ( $debug_msg ) ; 

      #debug p(@query_output);
      return ( $ret , $msg , \@query_output ) ; 	
   
	}
   # eof sub doSearchConfigurationEntries



   #
   # -----------------------------------------------------------------------------
   # get ALL the table data into hash ref of hash refs 
   # -----------------------------------------------------------------------------
   sub doSelectTableIntoHashRef {

      my $self                   = shift ; 
      my $objModel               = ${shift @_ } ; 
      my $table                  = shift || 'daily_issues' ;  # the table to get the data from  
      my $filter_by_attributes   = shift ; 
      my $ret                    = 1 ; 
      my $msg                    = 'unknown error while retrieving the content of the ' . $table . ' table' ; 

      if ( defined $objModel->get('postgres_db_name') ) {
		   $postgres_db_name = $objModel->get('postgres_db_name');
      }
      
      if ( $self->table_exists ( $postgres_db_name , $table ) == 0  ) {
         $ret = 400 ; 
         $msg = ' the table ' . $table . ' does not exist in the ' . $postgres_db_name . ' database '  ; 
         return ( $ret , $msg ) ; 
      }

      my $debug_msg        = q{} ; 
      my $hsr2             = {} ;         # this is hash ref of hash refs to populate with
      my $mhsr             = {} ;         # this is meta hash describing the data hash ^^
      my $dmhsr            = {} ;        # this is meta hash describing the data hash ^^
      my $sth              = {} ;         # this is the statement handle
      my $dbh              = {} ;         # this is the database handle
      my $str_sql          = q{} ;        # this is the sql string to use for the query


      ( $ret , $msg , $dmhsr ) = $self->doSelectTablesColumnList ( $table ) ; 

      return  ( $ret , $msg , undef ) unless $ret == 0 ; 

      foreach my $key ( sort ( keys %$dmhsr ) ) {
         $mhsr->{'ColumnNames'}-> { $key } = $dmhsr->{ $key } ; 
      }
      
      $objModel->set('hsr_meta' , $mhsr );
      $str_sql = 
         " SELECT 
         * FROM $table 
         WHERE 1=1 " ; 
      $str_sql .= $filter_by_attributes . " " if $filter_by_attributes ; 

      # not all items have the prio attribute
      $str_sql .= "
         order by prio asc
         ;
      " if exists $dmhsr-> { 'prio' } ; 
      
      # debug p ( '$str_sql: ' . "$str_sql" . "\n" ) ; 
      # authentication src: http://stackoverflow.com/a/19980156/65706
     
      $dbh = DBI->connect("dbi:Pg:dbname=$postgres_db_name", "", "" , {
                 'RaiseError'          => 1
               , 'ShowErrorStatement'  => 1
               , 'PrintError'          => 1
               , 'AutoCommit'          => 1
               , 'pg_utf8_strings'     => 1
      } ) or $msg = DBI->errstr;
      
      # src: http://www.easysoft.com/developer/languages/perl/dbd_odbc_tutorial_part_2.html
      $sth = $dbh->prepare($str_sql);  

      $sth->execute()
            or $objLogger->error ( "$DBI::errstr" ) ;

      $hsr2 = $sth->fetchall_hashref( 'guid' ) ; 
      binmode(STDOUT, ':utf8');

      $msg = DBI->errstr ; 

      unless ( defined ( $msg ) ) {
         $msg = 'SELECT OK for table: ' . "$table" ; 
         $objModel->set('hsr2' , $hsr2 ); 
         $ret = 0 ; 
      } else {
         $objLogger->doLogErrorMsg ( $msg ) ; 
      }

      # src: http://search.cpan.org/~rudy/DBD-Pg/Pg.pm  , METHODS COMMON TO ALL HANDLES
      # debug $debug_msg        = 'doSelectTableIntoHashRef ret ' . $ret ; 
      # debug $objLogger->doLogDebugMsg ( $debug_msg ) ; 
      
      return ( $ret , $msg ) ; 	
   }
   # eof sub doSelectTableIntoHashRef

	
   #
	# -----------------------------------------------------------------------------
	# the constructor 
	# -----------------------------------------------------------------------------
	sub new {

		my $invocant 			= shift ;    
		$appConfig     = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
		$objModel      = ${ shift @_ } || print 'objModel not passed in RdrPostgresDb !!!' ; 
      # p($appConfig ) ; 
      # might be class or object, but in both cases invocant
		my $class = ref ( $invocant ) || $invocant ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class
      $self = $self->doInitialize() ; 
		return $self;
	}  
	#eof const
	
   #
	# --------------------------------------------------------
	# intializes this object 
	# --------------------------------------------------------
   sub doInitialize {
      my $self = shift ; 

      %$self = (
           appConfig => $appConfig
      );

		# print "PostgreReader::doInitialize appConfig : " . p($appConfig );
      # sleep 6 ; 
		
		$postgres_db_name    = $ENV{ 'postgres_db_name' } || $appConfig->{'postgres_db_name'}     || 'prd_ysg_issues' ; 
		$db_host 			   = $ENV{ 'db_host' } || $appConfig->{'db_host'} 		|| 'localhost' ;
		$db_port 			   = $ENV{ 'db_port' } || $appConfig->{'db_port'} 		|| '13306' ; 
		$postgres_db_user 	= $ENV{ 'postgres_db_user' } || $appConfig->{'postgres_db_user'} 		|| 'ysg' ; 
		$postgres_db_user_pw = $ENV{ 'postgres_db_user_pw' } || $appConfig->{'postgres_db_user_pw'} 	|| 'no_pass_provided!!!' ; 
      
	   $objLogger 			   = 'IssueTracker::App::Utils::Logger'->new( \$appConfig ) ;

      return $self ; 
	}	
	#eof sub doInitialize
   


1;

__END__
