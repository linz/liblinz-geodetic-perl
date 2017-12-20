use lib '../lib';
use LINZ::Geodetic::CoordSysList qw/GetCoordSys/;
use File::Which;
use File::Path qw/make_path remove_tree/;

if( @ARGV )
{
    my($from,$to,$date,$infile,$outfile)=@ARGV;
    print "PERLTEST: $from $to $date $infile $outfile\n";
    my $csfrom=GetCoordSys($from);
    my $csto=GetCoordSys($to);
    my $ndp=$csto->type==LINZ::Geodetic::GEODETIC ? 9 : 4;
    my $swapin=$csfrom->type==LINZ::Geodetic::CARTESIAN;
    my $swapout=$csto->type==LINZ::Geodetic::CARTESIAN;
    open(my $fi,$infile) || die "Cannot open $infile\n";
    open(my $fo,">",$outfile) || die "Cannot open $outfile\n";
    while( my $l=<$fi> )
    {
        my($id,$e,$n,$h)=split(' ',$l);
        if( $swapin ){ my $t=$n; $n=$e, $e=$t; }
        my $crd=$csfrom->coord($n,$e,$h);
        if( $date ne '0' )
        {
            $crd=$crd->as($csto,$date);
        }
        else
        {
            $crd=$crd->as($csto);
        }
        ($n,$e,$h)=@$crd;
        if( $swapout ){ my $t=$n; $n=$e, $e=$t; }
        printf $fo "%s %.*f %.*f %.4f\n",$id,$ndp,$e,$ndp,$n,$h;
    }
    close($fi);
    close($fo);
    exit;
}

my $concord=which('concord');
my $script=$0;
my $ccdir='cc_test';
my $perldir='perl_test';
remove_tree($ccdir);
remove_tree($perldir);
make_path($ccdir);
make_path($perldir);

sub WriteTestFile
{
    my($testfile,$testdata)=@_;
    open( my $ft, ">", $testfile) || die "Cannot open $testfile\n";
    my $np=0;
    foreach my $td (@$testdata)
    {
        $np++;
        print $ft "$np ",join(" ",@$td),"\n";
    }
    close($ft);
}

sub CsParam
{
    my ($code, $type)=@_;
    my $param="$code";
    $param.=":ENH" if $type ne 'X';
    $param.=":D" if $type eq 'G';
    return $param;
}

sub RunConcord
{
    my($testno,$test,$testdata)=@_;
    my($codes,$date,$dataset,$types)=@$test;
    my $tfbase="$ccdir/test$testno";
    WriteTestFile($tfbase.".in",$testdata->{$dataset});
    my ($from,$to)=split(':',$codes);
    my ($tfrom,$tto)=split(':',$types);
    my $command=$concord;
    $command .= ' -i'.CsParam($from,$tfrom);
    $command .= ' -o'.CsParam($to,$tto);
    $command .= ' -n3';
    $command .= ' -p'.($tto eq 'G' ? 9 : 4);
    $command .= " -y $date" if $date ne '0';
    $command .= " $tfbase.in";
    $command .= " $tfbase.out1";
    system($command);
    $command=$concord;
    $command .= ' -i'.CsParam($to,$tto);
    $command .= ' -o'.CsParam($from,$tfrom);
    $command .= ' -n3';
    $command .= ' -p'.($tfrom eq 'G' ? 9 : 4);
    $command .= " -y $date" if $date ne '0';
    $command .= " $tfbase.out1";
    $command .= " $tfbase.out2";
    system($command);
}

sub RunPerl
{
    my($testno,$test,$testdata)=@_;
    my($codes,$date,$dataset,$types)=@$test;
    my $tfbase="$perldir/test$testno";
    WriteTestFile($tfbase.".in",$testdata->{$dataset});
    my ($from,$to)=split(':',$codes);
    system("perl $script $from $to $date $tfbase.in $tfbase.out1");
    system("perl $script $to $from $date $tfbase.out1 $tfbase.out2");
}

my $testfile='test.dat';
open(my $fh,$testfile) || die "Cannot open test file\n";
my $testdata={};
my $tests=();
my $data;
while(my $l=<$fh>)
{
    if( $l =~ /^\s*test\s+(\w+)\s*$/ )
    {
        $data=[];
        $testdata->{$1}=$data;
    }
    elsif( $data )
    {
        my @crds=split(' ',$l);
        push(@$data,\@crds);
    }
    else
    {
        my @parts=split(' ',$l);
        push(@$tests,\@parts);
    }
}

my $nt=0;
foreach my $test (@$tests)
{
    $nt++;
    print "TEST$nt: ",join(" ",@$test),"\n";
    RunConcord($nt,$test,$testdata);
    RunPerl($nt,$test,$testdata);
}


