package IssueTracker::Controller::HSelect;
use strict ; use warnings ; 

require Exporter; our @ISA = qw(Exporter Mojo::Base IssueTracker::Controller::BaseController);
our $AUTOLOAD =();
use AutoLoader;
use parent qw(IssueTracker::Controller::BaseController);

use Data::Printer ; 
use Data::Dumper; 

use IssueTracker::App::Utils::Logger;
use IssueTracker::App::Db::In::RdrDbsFactory ; 
use IssueTracker::App::IO::In::CnrUrlParams ; 
use IssueTracker::App::Cnvr::CnrHsr2ToArray ; 
use IssueTracker::App::Cnvr::CnrHashesArrRefToHashesArrRef ; 

our $appConfig          = {} ; 

sub doHSelectItems {

   my $self             = shift ; 
   my $db               = $self->stash('db');
   my $item             = $self->stash('item');
   my $msg              = '' ; 
   my $http_code        = 400 ; 
   my $http_method      = 'GET' ; 
   my $met              = {} ; 
   my $ret              = 1 ; 
   my $cnt              = 0 ; 
   my $objRdrDbsFactory = {} ; 
   my $objRdrDb         = {} ; 
   my $rdbms_type       = 'postgres' ; 
   my $objModel         = {} ; 
   my $dat              = [] ;
   my $seq              = $self->req->query_params->param('seq') || 1 ; 
   my $bid              = $self->req->query_params->param('bid') || 0 ; 
 
   return unless ( $self->SUPER::isAuthorized($db) == 1 );
   $self->SUPER::doReloadProjDbMeta( $db ) ;

   $appConfig		 		= $self->app->get('AppConfig');
   $objModel            = 'IssueTracker::App::Mdl::Model'->new ( \$appConfig ) ;

   $objRdrDbsFactory 	= 'IssueTracker::App::Db::In::RdrDbsFactory'->new(\$appConfig, \$objModel );
   $objRdrDb 				= $objRdrDbsFactory->doSpawn("$rdbms_type");

   my $objCnrUrlParams = 
      'IssueTracker::App::IO::In::CnrUrlParams'->new(\$appConfig , \$objModel , $self->req->query_params);

   ( $ret , $msg ) = $objCnrUrlParams->doSetView();
   return $self->SUPER::doRenderJSON($http_code,$msg,$http_method,$met,$cnt,$dat) unless $ret == 200 ; 

   ( $ret , $msg ) = $objCnrUrlParams->doSetSelect();
   return $self->SUPER::doRenderJSON($http_code,$msg,$http_method,$met,$cnt,$dat) unless $ret == 0 ; 

   ($http_code, $msg, $dat) 	= $objRdrDb->doHSelectBranch( $db , $item, $bid ,$seq);
   my $objCnrHashesArrRefToHashesArrRef = 'IssueTracker::App::Cnvr::CnrHashesArrRefToHashesArrRef'->new (\$appConfig  ) ; 
   $dat = $objCnrHashesArrRefToHashesArrRef->doConvert ( $dat) ; 
   
   $self->SUPER::doRenderJSON($http_code,$msg,$http_method,$met,$cnt,$dat);
   return ; 
}

1 ; 

__END__