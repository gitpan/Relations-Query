use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'Relations::Query',
  'VERSION_FROM' => 'Query.pm', 
  ($] ge '5.005') ? 
  (
    'AUTHOR'   => 'George A. Fitch III (aka Gaffer), gaf3@gaf3.com',
    'ABSTRACT' => 'DBI/DBD::mysql object for creating queries',
  ) : (),
  'PREREQ_PM' => 
  { 
    'DBI'        => 1.13,
    'DBD::mysql' => 1.18,
    'Relations'  => 0.93
  },
  'PM' => {
     'Query.pm' => '$(INST_LIBDIR)/Query.pm'
  }
);

