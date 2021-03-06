# LINZ::Geodetic::NZMS1MapRef
#
# This provides the functions for converting
# between NZMS1 map references and NZGD49 latitude/longitude

use strict;
use LINZ::Geodetic::TMProjection;
use LINZ::Geodetic::Ellipsoid;

package LINZ::Geodetic::NZMS1MapRef;

my $ellipsoid;

my $nseries = {
    projprm=> [175.5,-39,1.0,300000.0,400000.0,0.91439841],
    sheets => [
   [  'N1', 940000, -15000],
   [  'N2', 940000,  30000],
   [  'N3', 910000, -15000],
   [  'N4', 910000,  30000],
   [  'N5', 910000,  75000],
   [  'N6', 880000,  30000],
   [  'N7', 880000,  75000],
   [  'N8', 880000, 120000],
   [  'N9', 850000,  30000],
   [ 'N10', 850000,  75000],
   [ 'N11', 850000, 120000],
   [ 'N12', 850000, 165000],
   [ 'N13', 820000,  30000],
   [ 'N14', 820000,  75000],
   [ 'N15', 820000, 120000],
   [ 'N16', 820000, 165000],
   [ 'N17', 820000, 210000],
   [ 'N18', 790000,  75000],
   [ 'N19', 790000, 120000],
   [ 'N20', 790000, 165000],
   [ 'N21', 790000, 210000],
   [ 'N22', 760000,  75000],
   [ 'N23', 760000, 120000],
   [ 'N24', 760000, 165000],
   [ 'N25', 760000, 210000],
   [ 'N26', 760000, 255000],
   [ 'N27', 730000, 120000],
   [ 'N28', 730000, 165000],
   [ 'N29', 730000, 210000],
   [ 'N30', 730000, 255000],
   [ 'N31', 730000, 300000],
   [ 'N32', 700000, 120000],
   [ 'N33', 700000, 165000],
   [ 'N34', 700000, 210000],
   [ 'N35', 700000, 255000],
   [ 'N36', 700000, 300000],
   [ 'N37', 670000, 165000],
   [ 'N38', 670000, 210000],
   [ 'N39', 670000, 255000],
   [ 'N40', 670000, 300000],
   [ 'N41', 640000, 165000],
   [ 'N42', 640000, 210000],
   [ 'N43', 640000, 255000],
   [ 'N44', 640000, 300000],
   [ 'N45', 640000, 345000],
   [ 'N46', 610000, 165000],
   [ 'N47', 610000, 210000],
   [ 'N48', 610000, 255000],
   [ 'N49', 610000, 300000],
   [ 'N50', 610000, 345000],
   [ 'N51', 580000, 210000],
   [ 'N52', 580000, 255000],
   [ 'N53', 580000, 300000],
   [ 'N54', 580000, 345000],
   [ 'N55', 550000, 210000],
   [ 'N56', 550000, 255000],
   [ 'N57', 550000, 300000],
   [ 'N58', 550000, 345000],
   [ 'N59', 550000, 390000],
   [ 'N60', 550000, 435000],
   [ 'N61', 550000, 480000],
   [ 'N62', 550000, 525000],
   [ 'N63', 550000, 570000],
   [ 'N64', 520000, 210000],
   [ 'N65', 520000, 255000],
   [ 'N66', 520000, 300000],
   [ 'N67', 520000, 345000],
   [ 'N68', 520000, 390000],
   [ 'N69', 520000, 435000],
   [ 'N70', 520000, 480000],
   [ 'N71', 520000, 525000],
   [ 'N72', 520000, 570000],
   [ 'N73', 490000, 210000],
   [ 'N74', 490000, 255000],
   [ 'N75', 490000, 300000],
   [ 'N76', 490000, 345000],
   [ 'N77', 490000, 390000],
   [ 'N78', 490000, 435000],
   [ 'N79', 490000, 480000],
   [ 'N80', 490000, 525000],
   [ 'N81', 490000, 570000],
   [ 'N82', 460000, 210000],
   [ 'N83', 460000, 255000],
   [ 'N84', 460000, 300000],
   [ 'N85', 460000, 345000],
   [ 'N86', 460000, 390000],
   [ 'N87', 460000, 435000],
   [ 'N88', 460000, 480000],
   [ 'N89', 460000, 525000],
   [ 'N90', 460000, 570000],
   [ 'N91', 430000, 210000],
   [ 'N92', 430000, 255000],
   [ 'N93', 430000, 300000],
   [ 'N94', 430000, 345000],
   [ 'N95', 430000, 390000],
   [ 'N96', 430000, 435000],
   [ 'N97', 430000, 480000],
   [ 'N98', 430000, 525000],
   [ 'N99', 400000, 165000],
   ['N100', 400000, 210000],
   ['N101', 400000, 255000],
   ['N102', 400000, 300000],
   ['N103', 400000, 345000],
   ['N104', 400000, 390000],
   ['N105', 400000, 435000],
   ['N106', 400000, 480000],
   ['N107', 400000, 525000],
   ['N108', 370000, 120000],
   ['N109', 370000, 165000],
   ['N110', 370000, 210000],
   ['N111', 370000, 255000],
   ['N112', 370000, 300000],
   ['N113', 370000, 345000],
   ['N114', 370000, 390000],
   ['N115', 370000, 435000],
   ['N116', 370000, 480000],
   ['N117', 370000, 525000],
   ['N118', 340000, 120000],
   ['N119', 340000, 165000],
   ['N120', 340000, 210000],
   ['N121', 340000, 255000],
   ['N122', 340000, 300000],
   ['N123', 340000, 345000],
   ['N124', 340000, 390000],
   ['N125', 340000, 435000],
   ['N126', 340000, 480000],
   ['N127', 340000, 525000],
   ['N128', 310000, 120000],
   ['N129', 310000, 165000],
   ['N130', 310000, 210000],
   ['N131', 310000, 255000],
   ['N132', 310000, 300000],
   ['N133', 310000, 345000],
   ['N134', 310000, 390000],
   ['N135', 310000, 435000],
   ['N136', 280000, 165000],
   ['N137', 280000, 210000],
   ['N138', 280000, 255000],
   ['N139', 280000, 300000],
   ['N140', 280000, 345000],
   ['N141', 280000, 390000],
   ['N142', 280000, 435000],
   ['N143', 250000, 255000],
   ['N144', 250000, 300000],
   ['N145', 250000, 345000],
   ['N146', 250000, 390000],
   ['N147', 250000, 435000],
   ['N148', 220000, 255000],
   ['N149', 220000, 300000],
   ['N150', 220000, 345000],
   ['N151', 220000, 390000],
   ['N152', 190000, 255000],
   ['N153', 190000, 300000],
   ['N154', 190000, 345000],
   ['N155', 190000, 390000],
   ['N156', 160000, 210000],
   ['N157', 160000, 255000],
   ['N158', 160000, 300000],
   ['N159', 160000, 345000],
   ['N160', 130000, 210000],
   ['N161', 130000, 255000],
   ['N162', 130000, 300000],
   ['N163', 130000, 345000],
   ['N164', 100000, 210000],
   ['N165', 100000, 255000],
   ['N166', 100000, 300000],
   ['N167', 100000, 345000],
   ['N168',  70000, 255000],
   ['N169',  70000, 300000]
    ]};
    
my $sseries = {
    projprm=> [171.5,-44,1.0,500000.0,500000.0,0.91439841],
    sheets=>[
   [  'S1', 920000, 590000],
   [  'S2', 890000, 545000],
   [  'S3', 890000, 590000],
   [  'S4', 890000, 635000],
   [  'S5', 890000, 680000],
   [  'S6', 890000, 725000],
   [  'S7', 860000, 545000],
   [  'S8', 860000, 590000],
   [  'S9', 860000, 635000],
   [ 'S10', 860000, 680000],
   [ 'S11', 860000, 725000],
   [ 'S12', 830000, 545000],
   [ 'S13', 830000, 590000],
   [ 'S14', 830000, 635000],
   [ 'S15', 830000, 680000],
   [ 'S16', 830000, 725000],
   [ 'S17', 800000, 500000],
   [ 'S18', 800000, 545000],
   [ 'S19', 800000, 590000],
   [ 'S20', 800000, 635000],
   [ 'S21', 800000, 680000],
   [ 'S22', 800000, 725000],
   [ 'S23', 770000, 455000],
   [ 'S24', 770000, 500000],
   [ 'S25', 770000, 545000],
   [ 'S26', 770000, 590000],
   [ 'S27', 770000, 635000],
   [ 'S28', 770000, 680000],
   [ 'S29', 770000, 725000],
   [ 'S30', 740000, 455000],
   [ 'S31', 740000, 500000],
   [ 'S32', 740000, 545000],
   [ 'S33', 740000, 590000],
   [ 'S34', 740000, 635000],
   [ 'S35', 740000, 680000],
   [ 'S36', 740000, 725000],
   [ 'S37', 710000, 455000],
   [ 'S38', 710000, 500000],
   [ 'S39', 710000, 545000],
   [ 'S40', 710000, 590000],
   [ 'S41', 710000, 635000],
   [ 'S42', 710000, 680000],
   [ 'S43', 710000, 725000],
   [ 'S44', 680000, 455000],
   [ 'S45', 680000, 500000],
   [ 'S46', 680000, 545000],
   [ 'S47', 680000, 590000],
   [ 'S48', 680000, 635000],
   [ 'S49', 680000, 680000],
   [ 'S50', 650000, 410000],
   [ 'S51', 650000, 455000],
   [ 'S52', 650000, 500000],
   [ 'S53', 650000, 545000],
   [ 'S54', 650000, 590000],
   [ 'S55', 650000, 635000],
   [ 'S56', 650000, 680000],
   [ 'S57', 620000, 410000],
   [ 'S58', 620000, 455000],
   [ 'S59', 620000, 500000],
   [ 'S60', 620000, 545000],
   [ 'S61', 620000, 590000],
   [ 'S62', 620000, 635000],
   [ 'S63', 590000, 365000],
   [ 'S64', 590000, 410000],
   [ 'S65', 590000, 455000],
   [ 'S66', 590000, 500000],
   [ 'S67', 590000, 545000],
   [ 'S68', 590000, 590000],
   [ 'S69', 590000, 635000],
   [ 'S70', 560000, 320000],
   [ 'S71', 560000, 365000],
   [ 'S72', 560000, 410000],
   [ 'S73', 560000, 455000],
   [ 'S74', 560000, 500000],
   [ 'S75', 560000, 545000],
   [ 'S76', 560000, 590000],
   [ 'S77', 530000, 275000],
   [ 'S78', 530000, 320000],
   [ 'S79', 530000, 365000],
   [ 'S80', 530000, 410000],
   [ 'S81', 530000, 455000],
   [ 'S82', 530000, 500000],
   [ 'S83', 530000, 545000],
   [ 'S84', 530000, 590000],
   [ 'S85', 530000, 635000],
   [ 'S86', 500000, 230000],
   [ 'S87', 500000, 275000],
   [ 'S88', 500000, 320000],
   [ 'S89', 500000, 365000],
   [ 'S90', 500000, 410000],
   [ 'S91', 500000, 455000],
   [ 'S92', 500000, 500000],
   [ 'S93', 500000, 545000],
   [ 'S94', 500000, 590000],
   [ 'S95', 500000, 635000],
   [ 'S96', 470000, 185000],
   [ 'S97', 470000, 230000],
   [ 'S98', 470000, 275000],
   [ 'S99', 470000, 320000],
   ['S100', 470000, 365000],
   ['S101', 470000, 410000],
   ['S102', 470000, 455000],
   ['S103', 470000, 500000],
   ['S104', 440000, 140000],
   ['S105', 440000, 185000],
   ['S106', 440000, 230000],
   ['S107', 440000, 275000],
   ['S108', 440000, 320000],
   ['S109', 440000, 365000],
   ['S110', 440000, 410000],
   ['S111', 440000, 455000],
   ['S112', 410000, 140000],
   ['S113', 410000, 185000],
   ['S114', 410000, 230000],
   ['S115', 410000, 275000],
   ['S116', 410000, 320000],
   ['S117', 410000, 365000],
   ['S118', 410000, 410000],
   ['S119', 410000, 455000],
   ['S120', 380000,  95000],
   ['S121', 380000, 140000],
   ['S122', 380000, 185000],
   ['S123', 380000, 230000],
   ['S124', 380000, 275000],
   ['S125', 380000, 320000],
   ['S126', 380000, 365000],
   ['S127', 380000, 410000],
   ['S128', 380000, 455000],
   ['S129', 350000,  95000],
   ['S130', 350000, 140000],
   ['S131', 350000, 185000],
   ['S132', 350000, 230000],
   ['S133', 350000, 275000],
   ['S134', 350000, 320000],
   ['S135', 350000, 365000],
   ['S136', 350000, 410000],
   ['S137', 350000, 455000],
   ['S138', 320000,  50000],
   ['S139', 320000,  95000],
   ['S140', 320000, 140000],
   ['S141', 320000, 185000],
   ['S142', 320000, 230000],
   ['S143', 320000, 275000],
   ['S144', 320000, 320000],
   ['S145', 320000, 365000],
   ['S146', 320000, 410000],
   ['S147', 290000,  50000],
   ['S148', 290000,  95000],
   ['S149', 290000, 140000],
   ['S150', 290000, 185000],
   ['S151', 290000, 230000],
   ['S152', 290000, 275000],
   ['S153', 290000, 320000],
   ['S154', 290000, 365000],
   ['S155', 290000, 410000],
   ['S156', 260000,  50000],
   ['S157', 260000,  95000],
   ['S158', 260000, 140000],
   ['S159', 260000, 185000],
   ['S160', 260000, 230000],
   ['S161', 260000, 275000],
   ['S162', 260000, 320000],
   ['S163', 260000, 365000],
   ['S164', 260000, 410000],
   ['S165', 230000,  50000],
   ['S166', 230000,  95000],
   ['S167', 230000, 140000],
   ['S168', 230000, 185000],
   ['S169', 230000, 230000],
   ['S170', 230000, 275000],
   ['S171', 230000, 320000],
   ['S172', 230000, 365000],
   ['S173', 200000,  50000],
   ['S174', 200000,  95000],
   ['S175', 200000, 140000],
   ['S176', 200000, 185000],
   ['S177', 200000, 230000],
   ['S178', 200000, 275000],
   ['S179', 200000, 320000],
   ['S180', 200000, 365000],
   ['S181', 170000, 185000],
   ['S182', 170000, 230000],
   ['S183', 170000, 275000],
   ['S184', 170000, 320000],
   ['S185', 140000, 140000],
   ['S186', 140000, 185000],
   ['S187', 140000, 230000],
   ['S188', 110000, 140000],
   ['S189', 110000, 185000],
   ['S190',  80000, 140000],
   ['S191',  80000, 185000]
    ]};
    
my $sfindsheet;
my $nfindsheet;

sub find_sheet {
    my ( $series, $n, $e ) = @_;
    my $n1 = $n-30000;
    my $e1 = $e-45000;
    foreach my $s (@{$series->{sheets}}) {
       return $s if $n >= $s->[1] && $n1 < $s->[1] && 
                    $e >= $s->[2] && $e1 < $s->[2];
       }
    return undef;
    }

sub lookup_sheet {
    my( $series, $sheet ) = @_;
    if( ! $series->{lookup} ) {
      foreach my $s (@{$series->{sheets}} ) {
         $series->{lookup}->{$s->[0]} = $s;
         }
      }
    $sheet = uc($sheet);
    $sheet =~ s/([NS])0+/$1/;
    return $series->{lookup}->{$sheet};
    }
    
sub proj {
    my( $series ) = @_;
    my $proj = $series->{proj};
    return $proj if $proj;
    $ellipsoid = new LINZ::Geodetic::Ellipsoid(6378388.0,297.0) if ! $ellipsoid;
    $proj = new LINZ::Geodetic::TMProjection($ellipsoid,@{$series->{projprm}});
    $series->{proj} = $proj;
    return $proj;
    }

sub write {
   my( $lt, $ln ) = @_;
   my $series = ($lt > -40 || $ln > 174.5) ? $nseries : $sseries; 
   my $crd = &proj($series)->proj([$lt,$ln]);
   my $sheet = &find_sheet( $series, @$crd );
   die "Coordinates of range for NZMS1 map reference\n" if ! $sheet;
   my $nr = substr(int(10000+($crd->[0]+50)/100),-3);
   my $er = substr(int(10000+($crd->[1]+50)/100),-3);
   my $ref = $sheet->[0].' '.$er.' '.$nr;
   return ($ref);
   };

sub read {
   my( $ref ) = @_;
   $ref = uc($ref);
   $ref =~ /^([NS]\W*\d{1,3})\W+(\d\d\d)\W*(\d\d\d)$/
     || $ref =~ /^([NS]\W*\d{1,3})\W+(\d\d\d\d)\W*(\d\d\d\d)$/
     || die "Invalid NZMS1 map reference $ref\n";
   my( $sheet, $er, $nr ) = ($1,$2,$3);
   my $series = ($sheet =~ /^N/) ? $nseries : $sseries;
   $sheet = &lookup_sheet( $series, $sheet );
   die "Invalid NZMS1 map reference $ref\n" if ! $sheet;
   if( length($er) == 3 ) { $er *= 10; $nr *= 10; };
   $er *= 10; $nr *= 10;
   my $n0 = $sheet->[1]+15000;
   my $e0 = $sheet->[2]+22500;
   $nr = (int(($n0 - $nr)/100000+1.5)-1)*100000 + $nr;
   $er = (int(($e0 - $er)/100000+1.5)-1)*100000 + $er;
   my $crd = &proj($series)->geog([$nr,$er]);
   return @$crd;
   }

1;
