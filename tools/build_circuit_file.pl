use strict;

my $inputfile='merid_buff.dump';
my $outputfile='nz_merid_circuit.dat';

open( my $if, "<$inputfile") || die "Cannot open $inputfile\n";


my %crdsys=(
    2=>'AMURTM2000',
    5=>'PLENTM2000',
    8=>'BLUFTM2000',
    11=>'BULLTM2000',
    15=>'CHATTM2000',
    18=>'COLLTM2000',
    21=>'GAWLTM2000',
    24=>'GREYTM2000',
    28=>'HAWKTM2000',
    30=>'HOKITM2000',
    33=>'JACKTM2000',
    36=>'KARATM2000',
    39=>'LINDTM2000',
    42=>'MARLTM2000',
    45=>'EDENTM2000',
    48=>'PLEATM2000',
    51=>'YORKTM2000',
    54=>'NICHTM2000',
    57=>'NELSTM2000',
    62=>'TAIETM2000',
    65=>'OBSETM2000',
    68=>'OKARTM2000',
    86=>'POVETM2000',
    91=>'TARATM2000',
    94=>'TIMATM2000',
    97=>'TUHITM2000',
    100=>'WAIRTM2000',
    103=>'WANGTM2000',
    106=>'WELLTM2000',
);

my @circuits=();
while( my $line=<$if> )
{
    next if $line !~ /^OGRFeature\(/;
    my $cosid=0;
    my $crds='';
    my $name='';
    while( $line = <$if> )
    {
        if( $line=~ /^\s*cos_id\s+\(.*\)\s*\=\s*(\d+)(\.0*)?\s*$/ )
        {
            $cosid=$1;
        }
        elsif( $line=~ /^\s*name\s+\(.*\)\s*\=\s*(.*?)\s*$/ )
        {
            $name=$1;
        }
        elsif( $line=~ /^\s*POLYGON\s*\(/ )
        {
            $crds=$';
            last;
        }
        elsif( $line =~ /^\s*$/ )
        {
            last;
        }
    }
    if( $cosid && $name && $crds )
    {
        if( ! exists($crdsys{$cosid}))
        {
            print "Don't know circuit $cosid\n";
            next;
        }
        my @ccrds=();
        my ($lnmin,$lnmax,$ltmin,$ltmax);
        while($crds=~ /[\(\,]([\d\.\-]+)\s+([\d\.\-]+)/g )
        {
            my $ln=sprintf("%.4f",$1);
            my $lt=sprintf("%.4f",$2);
            if( ! @ccrds ){ $lnmin=$lnmax=$ln; $ltmin=$ltmax=$lt; }
            if( $ln < $lnmin ){ $lnmin=$ln; } elsif ($ln > $lnmax) { $lnmax=$ln; }
            if( $lt < $ltmin ){ $ltmin=$lt; } elsif ($lt > $ltmax) { $ltmax=$lt; }
            push(@ccrds,[$ln,$lt]);
        }
        my $ncrd=scalar(@ccrds);
        print "$crdsys{$cosid} $lnmin $lnmax $ltmin $ltmax $ncrd\n";
        foreach my $x (@ccrds)
        {
            print $x->[0]," ",$x->[1],"\n";
        }
    }
}
