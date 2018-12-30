package IssueTracker::App::Db::In::RdrDbsFactory ; 

	use strict; use warnings;
	
	use Data::Printer ; 
   use Carp ; 	

	our $appConfig 		= {} ; 
	our $rdbms_type      = 'postgres' ; 
	our $objItem			= {} ; 
   our $objModel        = {} ; 

   use IssueTracker::App::Db::In::Postgres::RdrPostgresDb ; 

	#
	# -----------------------------------------------------------------------------
	# fabricates / produces different RdrDb object 
	# -----------------------------------------------------------------------------
	sub doSpawn {

		my $self 			= shift ; 	
		my $rdbms_type	   = shift // $rdbms_type ; # the default is postgres

		my @args 			= ( @_ ) ; 
		my $package_file  = () ; 
		my $objRdrDb   	= () ; 

		if ( $rdbms_type eq 'postgres' ) {
		   $package_file     = "IssueTracker/App/Db/In/Postgres/RdrPostgresDb.pm";
		   $objRdrDb   		= "IssueTracker::App::Db::In::Postgres::RdrPostgresDb";
		}
		else {
			# future support for different RDBMS 's should be added here ...
		   $package_file     = "IssueTracker/App/Db/In/Postgres/RdrPostgresDb.pm";
		   $objRdrDb   		= "IssueTracker::App::Db::In::Postgres::RdrPostgresDb";
		}
		#if ( $rdbms_type eq 'mariadb' ) {
		#   $package_file     = "IssueTracker/App/Db/In/MariaDb/RdrMariaDb.pm";
		#   $objRdrDb   		= "IssueTracker::App::Db::In::MariaDb::RdrMariaDb";
		#}
		#elsif ( $rdbms_type eq 'mysql' ) {
		#   $package_file     = "IssueTracker/App/Db/In/MariaDb/RdrMariaDb.pm";
		#   $objRdrDb   		= "IssueTracker::App::Db::In::MariaDb::RdrMariaDb";
		#}

		require $package_file;
		return $objRdrDb->new( \$appConfig , \$objModel , @args);
	}
	

	sub new {

		my $invocant   = shift ;    
		$appConfig     = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
		$objModel      = ${ shift @_ } || croak 'objModel not passed !!!' ; 
		my $class      = ref ( $invocant ) || $invocant ; 
		my $self = {}; bless( $self, $class ) ; 
      $self = $self->doInit() ; 
		return $self;
	}  
	
   sub doInit {
      my $self = shift ; 

      %$self = (
           appConfig => $appConfig
      );
	   #$objLogger 			= 'IssueTracker::App::Utils::Logger'->new( \$appConfig ) ;
      return $self ; 
	}	

1;


__END__
