
use lib qw(../lib);
use PDF::Labels;

my $l=PDF::Labels->new(
	form => [ brand => "Axxxx", code => "5393" ],
);

$l->layout->background_image("nametag.jpg");
$l->layout->align_default("center");
$l->layout->fontsize(0, "36");
$l->layout->fontsize(1, "36");

$l->data(
	[ "L1 R1", "L1 R2", "L1 R3", "L1 R4" ],
	[ "L2 R1", "L2 R2", "L2 R3", "L2 R4" ],
	[ "L3 R1", "L3 R2", "L3 R3", "L3 R4" ],
	[ "L4 R1", "L4 R2", "L4 R3", "L4 R4" ],
	[ "L5 R1", "L5 R2", "L5 R3", "L5 R4" ],
	[ "L6 R1", "L6 R2", "L6 R3", "L6 R4" ],
	[ "L7 R1", "L7 R2", "L7 R3", "L7 R4" ],
	[ "L8 R1", "L8 R2", "L8 R3", "L8 R4" ],
	[ "L9 R1", "L9 R2", "L9 R3", "L9 R4" ],
);

$l->generate;

