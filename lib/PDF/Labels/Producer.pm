
package PDF::Labels::Producer;

use vars qw(@ISA);
use base qw(PDF::Labels::base);
use strict;

use Paper::Specs strict => 1, layout => "pdf";

use PDF::API2;

sub filename {

    my $self=shift;
    if (@_) {
        $self->{'filename'} = shift;
    }

    $self->{'filename'} ||= "labels.pdf";
    return $self->{'filename'};

}

sub generate {

    my $self=shift;

    my $pdf=PDF::API2->new;
    my $page;

    my $layout=$self->layout;
    my $form  =$self->form;
    $layout->prep( pdf => $pdf, size => [ $form->label_size ] );

    while (my $data = $self->fetch) {

        my ($r, $c) = $self->next_location;

        if ($r == 1 && $c == 1) {
            $page = $pdf->page();
            $page->mediabox( $form->sheet_size );
        }

        $layout->print( data => $data, loc => [ $form->label_location( $r, $c), $form->label_size ], 
            page => $page, r => $r, c => $c );

    }        

    $pdf->saveas( $self->filename );
    $pdf->end;

}

sub form {

    my $self=shift;
    if (@_) {
        if ( ref $_[0] eq 'ARRAY' ) {
            $self->{'form'} = Paper::Specs->find( @{$_[0]} );
        } else {
            $self->{'form'} = Paper::Specs->find( @_ );
        }
    }
    return $self->{'form'};

}

sub skip_first {

	return {

	};

}

sub skip_all {

	return {

	};

}


sub next_location {

    my $self=shift;

    # XXX provision for skipping empty spots
    $self->{'c'}++;

    if ($self->{'c'} > $self->form->label_cols) {
        $self->{'c'}=1;
        $self->{'r'}++;
    }

    if ($self->{'r'} > $self->form->label_rows) {
        $self->{'c'}=1; $self->{'r'}=1;
    }

    $self->{'r'} ||=1;

    return ($self->{'r'}, $self->{'c'} );

}

sub fetch {

    my $self=shift;
    return shift @{$self->{'data'}};

}

sub data {

    my $self=shift;
    $self->{'data'} = [ @_ ];

}

sub layout {

    my $self=shift;

    if (@_) {
        $self->{'layout'} = shift;
    }

    unless ($self->{'layout'}) {
        eval "use PDF::Labels::Layout::Simple";
        die $@ if $@;
        $self->{'layout'} = PDF::Labels::Layout::Simple->new;
    }

    return $self->{'layout'};

}

1;
