package Qto::Controller::HiSelect;
use strict ; use warnings ; 

require Exporter; our @ISA = qw(Exporter Mojo::Base Qto::Controller::BaseController);
our $AUTOLOAD =();
use AutoLoader;
use parent qw(Qto::Controller::BaseController);

use Data::Printer ; 
use Data::Dumper; 

use Qto::App::Utils::Logger;
use Qto::App::Db::In::RdrDbsFcry ; 
use Qto::App::IO::In::CnrUrlPrms ; 
use Qto::App::Cnvr::CnrHsr2ToArray ; 
use Qto::App::Cnvr::CnrHashesArrRefToHashesArrRef ; 
use Qto::App::Cnvr::CnrDbName qw(toPlainName toEnvName);

our $config          = {} ; 

sub doHiSelectItems {

   my $self          = shift ; 
   my $db            = $self->stash('db');
   my $item          = $self->stash('item');
   my $msg           = '' ; 
   my $http_code     = 400 ; 
   my $http_method   = 'GET' ; 
   my $met           = {} ; 
   my $ret           = 1 ; 
   my $cnt           = 0 ; 
   my $rdbms_type    = 'postgres' ; 
   my $dat           = [] ;
   my $objModel      = {} ; 
   my $objRdrDb      = {} ; 
   my $objRdrDbsFcry = {} ; 
   my $mc               = {}; # the meta-counter of the meta-data
 
   $config		      = $self->app->config ; 
   $db               = toEnvName ( $db , $config) ;
   return unless ( $self->SUPER::isAuthenticated($db) == 1 );
   $self->SUPER::doReloadProjDbMeta( $db,$item ) ;

   $objModel         = 'Qto::App::Mdl::Model'->new ( \$config , $db , $item ) ;
   my $objCnrUrlPrms = 'Qto::App::IO::In::CnrUrlPrms'->new(\$config , \$objModel , $self->req->query_params);
   ( $ret , $msg , $met , $mc)   = $objModel->doGetTableMeta($config,$db,$item);
  
   return $self->SUPER::doRenderJSON($objCnrUrlPrms->get('http_code'),$objCnrUrlPrms->get('msg'),$http_method,$met,$cnt,$dat) 
      unless $objCnrUrlPrms->doValidateAndSetHiSelect();
  

   $objRdrDbsFcry = 'Qto::App::Db::In::RdrDbsFcry'->new(\$config, \$objModel );
   $objRdrDb 			= $objRdrDbsFcry->doSpawn("$rdbms_type");

   ($http_code, $msg, $dat) 	= $objRdrDb->doHiSelectBranch( $db , $item );
   my $objCnrHashesArrRefToHashesArrRef = 'Qto::App::Cnvr::CnrHashesArrRefToHashesArrRef'->new (\$config  ) ; 
   $dat = $objCnrHashesArrRefToHashesArrRef->doConvert ( $dat) ; 

   $self->SUPER::doRenderJSON($http_code,$msg,$http_method,$met,$cnt,$dat);
   return ; 
}

1 ; 

__END__
