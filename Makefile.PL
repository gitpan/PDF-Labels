use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(

    'NAME'		=> 'PDF::Labels',

    'VERSION_FROM'	=> 'VERSION', # finds $VERSION
    'PREREQ_PM'		=> {
		'PDF::API2' => 0,
		'Paper::Specs' => 0.03,
	    'Test::More' => 0,
    }, 
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/PDF/Labels.pm', # retrieve abstract from module
       AUTHOR     => 'Jay Lawrence <jlawrenc@cpan.org>') : ()),

);
