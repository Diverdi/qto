use strict ; use warnings ; 
package IssueTracker::App::Cnvr::CnrHsr2ToArray ; 

our $appConfig = {} ; 
use Data::Printer ; 
use Carp ; 

our $objModel = {} ; 

   #
	# -----------------------------------------------------------------------------
	# convert from hash ref of hash refs to an array and return the array ref
	# -----------------------------------------------------------------------------
   sub doConvert {
      my $self          = shift ; 
      my $hsr2          = $objModel->get('hsr2');
      my $to_order_by   = $objModel->get('select.web-action.o') ; 
      my $to_hide       = $objModel->get('select.web-action.hide');

      my $msg        = 'unknown error has occurred !!!' ; 
      my $ret        = 1 ;      # assume error from the start  
      my @list       = () ; 

         if ( defined ( $to_order_by) ) {
            foreach my $key ( sort { $hsr2->{$a}->{ $to_order_by } cmp $hsr2->{$b}->{ $to_order_by } } keys (%$hsr2) ) {
               my $row = $hsr2->{$key} ; 
               $self->doHideHidables ( $row , $to_hide ) ; 
               push ( @list , $row ) ; 
            }
         }
         else {
            foreach my $key ( keys %$hsr2 ) {
               my $row = $hsr2->{$key} ; 
               $self->doHideHidables ( $row , $to_hide ) ; 
               push ( @list , $row ) ; 
            }
         }
      $ret = 0 ; 
      $msg = "" ; 
      return ( $ret , $msg , \@list ) ; 
   } 


   #
	# -----------------------------------------------------------------------------
	# hide the attribute's values to hide per row in the hash ref of hash refs 
	# -----------------------------------------------------------------------------
   sub doHideHidables {

      my $self       = shift ; 
      my $row        = shift ; 
      my $to_hide    = shift ; 

      if ( defined ( $to_hide ) ) {
         my @hides = split ( ',' , $to_hide ) ; 
         foreach my $hidable ( @hides ) {
           delete $row->{$hidable} ;  
         }
      }
      return $row ; 
   }

   #
	# -----------------------------------------------------------------------------
	# the constructor 
	# -----------------------------------------------------------------------------
	sub new {

		my $class      = shift;    # Class name is in the first parameter
		$appConfig     = ${ shift @_ } || { 'foo' => 'bar' ,} ; 
		$objModel      = ${ shift @_ } || croak 'objModel not passed !!!' ; 

		my $self = {};        # Anonymous hash reference holds instance attributes
		bless( $self, $class );    # Say: $self is a $class
		return $self;
	}  
	#eof const
  

1;

__END__

=head1 NAME

CnrHsr2ToArray

=head1 SYNOPSIS

use UrlSniper  ; 


=head1 DESCRIPTION
the converter between xls read produced hsr2 and a hierarchichal model
containing hsr2
=head2 EXPORT


=head1 SEE ALSO

No mailing list for this module


=head1 AUTHOR

yordan.georgiev@gmail.com

=head1 



=cut 

