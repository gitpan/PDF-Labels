
package PDF::Labels;
use strict;


use vars qw(@ISA);
use PDF::Labels::base;
@ISA=qw(PDF::Labels::base);


use PDF::Labels::Producer;

sub new {

    my $self=shift;
    return PDF::Labels::Producer->new( @_ );

}


1;
