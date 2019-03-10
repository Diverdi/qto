use strict;
use warnings;
use 5.10.0;
use ExtUtils::Installed;
#  quick and dirty check for prerequisites perl modules:
#  courtesy of:http://stackoverflow.com/a/9340304/65706
#  if you have a calling bash script call by :
#  perl "/path/to/isg_pub_preq_checker.pl"
#  export ret=$?
#  test $ret -ne 0 && doExit 1 "[FATAL] perl modules not found!!!"

my $PrintOkCheck = 1;
doCheckUbuntuOSPackages();
# check that all the required modules are installed
my ($ret, $msg) = doCheckRequiredModules();

unless ($ret == 0) {
  print "$msg";

  # give some time for the user to react
  print "printing all installed modules :";
  my $c = 9;
  for (my $i = 0; $i <= $c; $i++) {
    print(($c - $i) . '.');
    sleep 1;
  }
  print "\n";
  doListAllInstalledModules();
  print "\n";
}

exit(0);

sub doListAllInstalledModules {
  my $instmod = ExtUtils::Installed->new();
  foreach my $module ($instmod->modules()) {
    my $version = $instmod->version($module) || "???";
    print "found module:$module -- v$version\n";
  }

}

#eof sub

sub doCheckUbuntuOSPackages {

  my @ospackages = qw(
   libxml-atom-perl
   postgresql-9.6
   libdbd-pgsql
  );

  for (@ospackages) {
   my $cmd="sudo apt-get install -y $_ \n" ; 
   `$cmd` ; 
  }

}


sub doCheckRequiredModules {

  my @modules = qw(
   URL::Encode
   ExtUtils::Installed
   Carp::Always
   Data::Printer
   File::Copy
   File::Find
   File::Path
   Term::Prompt
   Excel::Writer::XLSX
   Spreadsheet::ParseExcel
   Spreadsheet::XLSX
   Spreadsheet::ParseExcel::FmtJapan
   Net::Google::DataAPI::Auth::OAuth2
   Net::Google::Spreadsheets::V4
   Net::Google::Spreadsheets;
   Text::CSV_XS
   Module::Build::Tiny
   Carp::Always
   URL::Encode
   Carp::Always
   Data::Printer
   File::Copy::Recursive
   Spreadsheet::ParseExcel
   Spreadsheet::XLSX
   JSON
   Net::Google::DataAPI::Auth::OAuth2
   Text::CSV_XS
   Net::Google::Spreadsheets::V4
   Term::Prompt
   Net::Google::Spreadsheets
   Test::Trap
   Test::More
   Test::Most
   DBD::Pg
   Tie::Hash::DBD
   Scalar::Util::Numeric
   IPC::System::Simple
   Mojolicious
   Mojo::Pg
   Selenium::Remote::Driver
   Selenium::Chrome
   Mojolicious::Plugin::BasicAuthPlus
   Mojolicious::Plugin::StaticCache
   Mojolicious::Plugin::RenderFile
   Time::HiRes
   Mojolicious::Plugin::Authentication
   Mojo::JWT
  );

  for (@modules) {
    eval "use $_";
    if ($@) {

      #flush the screen
      print "\033[2J";
      print "\033[0;0H";

      my $msg
        = "\n\n\n [FATAL] did not found the following prerequisite perl module: $_ \n\n";
      $msg .= "\n # ::: START copy paste ::: ";
      $msg .= "\n#you must install it otherwise the application will not work";
      $msg
        .= "\n#the module could be installef by running the following commands:";

      # if the user knows already the difference between the running the cmd
      # with sudo or he / she probably knows already how-to install perl modules
      $msg
        .= "\n# as a start cnfigure the cpan to install dependancies first \n";
      $msg
        .= "\n"
        . 'perl -MCPAN -e \'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autocnfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit\''
        . "\n";
      $msg .= "\n#than install the $_ module by running: \n";
      $msg .= "\nsudo perl -MCPAN -e 'install $_'\n\n\n";
      $msg .= "\n # ::: STOP  copy paste ::: \n\n\n";
      $msg
        .= "\n# if you seem to be stuck in circular reference kind of loop try even :\n";
      $msg .= "\n # ::: START copy paste ::: ";
      $msg .= "\nsudo perl -MCPAN -e 'CPAN::Shell->force(qw( install $_));'\n";
      $msg .= "\n # ::: STOP  copy paste ::: ";
      $msg .= "\n# You may end-up now with Ctrl + C \n\n\n";

      return (1, "$msg") if $@;
    }
    else {
      say "[INFO ] ::: ok ::: check for prerequisite perl module : $_"
        if $PrintOkCheck == 1;
    }
  }

  #eof foreach module

  return (0, "all required modules found");

}

#eof sub