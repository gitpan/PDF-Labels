
package PDF::Labels::Layout::Simple;

use vars qw(@ISA);
use base qw(PDF::Labels::Layout);
use strict;

sub line_count {

    my $self=shift;

    if ( @_ ) {
        $self->{'line_count'} = shift;
    }
    $self->{'line_count'} = 4 if $self->{'line_count'} < 1;
    return $self->{'line_count'};

}

sub font {

    my $self=shift;
    my $line=shift;
    my $size=shift; 

    return if $line > $self->line_count;

    if ( $size ) {
        $self->{'font'}[$line] = $size;
    }

    return exists $self->{'font'}[$line] ? $self->{'font'}[$line] : $self->font_default;

}

sub fontsize {

    my $self=shift;
    my $line=shift;
    my $size=shift; 

    return if $line > $self->line_count;

    if ( $size ) {
        $self->{'fontsize'}[$line] = $size;
    }

    return exists $self->{'fontsize'}[$line] ? $self->{'fontsize'}[$line] : $self->fontsize_default;

}

sub prep {

    my $self=shift;
    my %opts=@_;

    $self->{'_pdf'}=$opts{pdf};
    $self->{'_font_default'} = $self->{'_pdf'}->corefont($self->font_default, 1);

    my $t_fontsize=0;
    for my $l ( 0 ... $self->line_count - 1) {
            $self->{'_font'}[$l] = $self->{'_pdf'}->corefont( $self->font($l), 1);
            $t_fontsize += $self->fontsize($l);
            $self->{'_align'}[$l]    ||= $self->align_default;
    };

    my $leading= ( -$opts{'size'}[1] - $self->margin_top -$self->margin_bottom - $t_fontsize) / ($self->line_count - 1);
    $self->{'_baseline'}[0] = $self->margin_top + $self->fontsize(0);
    for my $l ( 1 ... $self->line_count - 1) {
        $self->{'_baseline'}[$l] = $self->{'_baseline'}[$l-1] + $self->fontsize($l) + $leading;
    }

}


sub print {

    my $self=shift;

    $self->SUPER::print( @_ );
    my $opts=$self->{'_opts'};

    my @pos=@{$self->{'_pos'}};

    my $text = $self->{'_page'}->text;
    my $data = $self->{'_data'};

    for my $l ( 0 ... $self->line_count - 1 ) {

        my $size = $self->fontsize($l);
        my $line= $data->[$l];

        $text->font( $self->{'_font'}[$l], $size );
        while ($text->advancewidth($line) > ($pos[2] - $self->margin_left - $self->margin_right) ) {
            $size -= 1;
            die "Text '$line' is too big to fit on line!\n" if $size < 6;
        }


        if ( $self->{'_align'}[$l] eq "center" ) {
            $text->translate( $pos[0] + $pos[2]/2, $pos[1] - $self->{'_baseline'}[$l] );
            $text->text_center( $line );
        }

        if ( $self->{'_align'}[$l] eq "left" ) {
            $text->translate( $pos[0] + $self->margin_left, $pos[1] - $self->{'_baseline'}[$l] );
            $text->text( $line );
        }

        if ( $self->{'_align'}[$l] eq "right" ) {
            $text->translate( $pos[0] + $pos[2] - $self->margin_right, $pos[1] - $self->{'_baseline'}[$l] );
            $text->text_right( $line );
        }

    }

}

1;

