
package PDF::Labels::base;
use strict;


sub new {

    my $class = ref($_[0]) ? ref(shift) : shift;
    my $opts = ref($_[0]) ? $_[0] : {@_};

    my $self = bless {}, $class;

    map { 
		UNIVERSAL::can( $self, $_ ) ?
			$self->$_( $opts->{$_} ) 
			: $self->{$_}=$opts->{$_};
	} keys %$opts;

    $self->_new if UNIVERSAL::can($self, "_new");

    return $self;

}


1;

