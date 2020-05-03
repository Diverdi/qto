package Qto::App::Cnvr::CnrDbName ; 

use strict ; use warnings ; 

use Exporter qw(import);
use Carp qw< carp croak confess cluck >;

our @EXPORT = qw(toPlainName toEnvName );

sub toEnvName {
   my $db                  = shift ; 
   my $config              = shift ; 

   carp  "appconfig->env_type is undef " unless $config->{'env'}->{'run'}->{ 'ENV_TYPE' } ;
   carp "db is undef " unless $db ; 
   my @env_prefixes        = ( 'dev_' , 'tst_' , 'qas_' , 'prd_' );
 
   my $db_prefix           = substr($db,0,4);

   if ( $db =~ m/[^a-z0-9_]/g ) {
      carp "invalid $db db " ;
      return $db ;
   }

   unless ( grep ( /^$db_prefix$/, @env_prefixes)) {
      $db = $config->{'env'}->{'run'}->{'ENV_TYPE'} . '_' . $db ; 
   } 
   return $db ;
}

  
sub toPlainName {
   my $db  = shift ; 
   $db =~ s/^|dev_|tst_|qas_|prd_|//g;
   return $db ;
}

1;

__END__

=head1 NAME

CnrDbName

=head1 SYNOPSIS

use CnrDbName ; 


=head1 DESCRIPTION
provide util functions for dbname conversions
=head2 EXPORT


=head1 SEE ALSO

No mailing list for this module


=head1 AUTHOR

yordan.georgiev@gmail.com

=head1 


=cut 

