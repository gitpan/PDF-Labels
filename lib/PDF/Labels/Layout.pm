
package PDF::Labels::Layout;

use base qw(PDF::Labels::base);

sub _new {

    my $self=shift;

    $self->{'font_default'}     = "Helvetica-Bold";
    $self->{'fontsize_default'} = 14;
    $self->{'background_image'} = "";
    $self->{'bleed'}            = 5;

    $self->{'outline'}          = 1;
    $self->{'outline_colour'}   = "#0000000";
    $self->{'outline_width'}    = 0.1;
    $self->{'outline_cap'}      = 1;
    $self->{'outline_dash'}     = [ 20, 20 ];

    $self->{'align_default'}    = "left";

    $self->{'margin_left'}      = 18;
    $self->{'margin_right'}     = 18;
    $self->{'margin_top'}       = 18;
    $self->{'margin_bottom'}    = 18;
}

sub print {

    my $self=shift;

    my %opts=@_;

    $self->{'_opts'} = \%opts;
    $self->{'_pos'} =  $opts{'loc'};
    $self->{'_gfx'} =  $opts{'page'}->gfx;
    $self->{'_page'} = $opts{'page'};
    $self->{'_data'} = $opts{'data'};

    $self->print_background;
    $self->print_outline;

}


=item $self->print_background( $x, $y, $h, $w )

=cut

sub print_background {

    my $self=shift;

    eval { $self->{'_bg'}{ $self->background_image } = $self->{'_pdf'}->image( $self->background_image ) } 
        unless $self->{'_bg'}{ $self->background_image };
    return unless $self->{'_bg'}{ $self->background_image };

    my @p   = @{$self->{'_pos'}};

    my $bgBleed=$self->{'bleed'};
    $p[0] -= $bgBleed / 2;
    $p[1] += $bgBleed / 2;
    $p[2] += $bgBleed;
    $p[3] -= $bgBleed;

    $self->{'_gfx'}->image( $self->{'_bg'}{ $self->background_image }, @p );

}

sub print_outline {

    my $self=shift;
    return unless $self->outline;

    my @p   = @{$self->{'_pos'}};

    $self->{'_gfx'}->strokecolor( $self->outline_colour);
    $self->{'_gfx'}->linewidth(   $self->outline_width );
    $self->{'_gfx'}->linecap(     $self->outline_cap);
    $self->{'_gfx'}->linedash(    $self->outline_dash);

    $self->{'_gfx'}->rect( @p );

    $self->{'_gfx'}->stroke;
    $self->{'_gfx'}->endpath;

}

sub font_default {

    my $self=shift;
    if (@_) {
        $self->{'font_default'}=shift;
    }
    return $self->{'font_default'};

}

sub fontsize_default {

    my $self=shift;
    if (@_) {
        $self->{'fontsize_default'}=shift;
    }
    return $self->{'fontsize_default'};

}

sub background_image {

    my $self=shift;

    if (@_) {

        $self->{'background_image'}=shift;

        if ( ! -f $self->{'background_image'} ) {
            warn "Background image $self->{'background_image'} does not exist\n";
            delete $self->{'background_image'};
        }

        if ( ! -f $self->{'background_image'} ) {
            warn "Cannot read background image $self->{'background_image'}\n";
            delete $self->{'background_image'};
        }

    }

    return $self->{'background_image'};

}

sub outline {

    my $self=shift;
    if (@_) {
        $self->{'outline'}=shift;
    }
    return $self->{'outline'};

}

sub outline_colour {

    my $self=shift;
    if (@_) {
        $self->{'outline_colour'}=shift;
    }
    return $self->{'outline_colour'};

}

# 'cause I ain't from the US
sub outline_color { outline_colour( @_ ) }

sub outline_width {

    my $self=shift;
    if (@_) {
        $self->{'outline_width'}=shift;
    }
    return $self->{'outline_width'};

}

sub outline_cap {

    my $self=shift;
    if (@_) {
        $self->{'outline_cap'}=shift;
    }
    return $self->{'outline_cap'};

}

sub outline_dash {

    my $self=shift;
    if (@_) {
        $self->{'outline_dash'}=[ @_ ];
    }
    return @{$self->{'outline_dash'}};

}

sub align_default {

    my $self=shift;
    if (@_) {
        $self->{'align_default'}=shift;
    }
    return $self->{'align_default'};

}

sub margin_left {

    my $self=shift;
    if (@_) {
        $self->{'margin_left'}=shift;
    }
    return $self->{'margin_left'};

}

sub margin_right {

    my $self=shift;
    if (@_) {
        $self->{'margin_right'}=shift;
    }
    return $self->{'margin_right'};

}

sub margin_top {

    my $self=shift;
    if (@_) {
        $self->{'margin_top'}=shift;
    }
    return $self->{'margin_top'};

}

sub margin_bottom {

    my $self=shift;
    if (@_) {
        $self->{'margin_bottom'}=shift;
    }
    return $self->{'margin_bottom'};

}

1;

