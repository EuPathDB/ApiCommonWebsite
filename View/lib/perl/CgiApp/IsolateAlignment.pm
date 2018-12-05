package ApiCommonWebsite::View::CgiApp::IsolateAlignment;

@ISA = qw( EbrcWebsiteCommon::View::CgiApp );

use strict;
use Tie::IxHash;
use EbrcWebsiteCommon::View::CgiApp;
use Data::Dumper;

use Bio::Graphics::Browser2::PadAlignment;

sub run {
  my ($self, $cgi) = @_;

  my $dbh = $self->getQueryHandle($cgi);

  print $cgi->header('text/html');

  $self->processParams($cgi, $dbh);
  $self->handleIsolates($dbh, $cgi);

  exit();
}

sub processParams {
  my ($self, $cgi, $dbh) = @_;


  my $type  = $cgi->param('type');

  if($type eq 'geneOrthologs') {
    my @ids = $cgi->param('gene_ids');
    $self->{ids} = join(',', @ids);
  }

  # JB: not sure why this is splitting then concatenating.  Seems like all this is doing is stripping the trailing comma
  else {
    my $p = $cgi->param('isolate_ids');
    $p =~ s/,$//;
    my @ids = split /,/, $p;
    my $list;
    foreach my $id (@ids){

      $list = $list.  "'" . $id. "',";
    }
    $list =~ s/\,$//;

    $self->{ids} = $list;
  }
}

sub handleIsolates {
  my ($self, $dbh, $cgi) = @_;

  my $ROOT = $ENV{'DOCUMENT_ROOT'};
  my $GUS_HOME = $ENV{'GUS_HOME'};

  my $ids = $self->{ids};

  my $type  = $cgi->param('type');
  my $start = $cgi->param('start');
  my $end   = $cgi->param('end');
  my $sid   = $cgi->param('sid');
  my $project_id = $cgi->param('project_id');

  $start =~ s/,//g;
  $end =~ s/,//g;

  if($end !~  /\d/) {
    $end   = $start + 50;
    $start = $start - 50;
  }
  my $sql = "";

  if($type =~ /htsSNP/i) {
    $ids =~ s/'(\w)/'$sid\.$1/g;
    $ids .= ",'$sid'";   # always compare with reference isolate
    $sql = <<EOSQL;
SELECT source_id, 
       substr(nas.sequence, $start,$end-$start+1) as sequence 
FROM   dots.nasequence nas
WHERE  nas.source_id in ($ids) 
EOSQL
  } elsif($type eq 'geneOrthologs') {
    $ids = join(',', map { "'$_'" } split(',', $ids));
    $sql = <<EOSQL;
select ps.source_id, ps.sequence
from apidbtuning.proteinsequence ps, apidbtuning.transcriptattributes ta
where ta.protein_source_id = ps.source_id
and ta.project_id = ps.project_id
and ta.gene_source_id in ($ids)
EOSQL
  } else {  # regular isolates
    $sql = <<EOSQL;
SELECT etn.source_id, etn.sequence
FROM   ApidbTuning.PopsetSequence etn
WHERE etn.source_id in ($ids)
EOSQL
  }


  my $sequence;
  my $sth = $dbh->prepare($sql);
  $sth->execute();
  while(my ($id, $seq) = $sth->fetchrow_array()) {

    $id =~ s/^$sid\.// unless ($id eq $sid);
    my $noN = $seq;
    $noN =~ s/[ACGT]//g;
    next if length($noN) == length($seq);
    $sequence .= ">$id\n$seq\n";
  }

  my $range = 10000000;
  my $random = int(rand($range));

  my $infile  = "/tmp/isolate_clustalo_tmp$random.fas";
  my $outfile = "/tmp/isolate_clustalo_tmp$random.aln";
  my $dndfile = "/tmp/isolate_clustalo_tmp$random.dnd";
  my $tmpfile = "/tmp/isolate_clustalo_tmp$random.tmp";
  
  open(OUT, ">$infile");
  print OUT $sequence;
  close OUT;

  my $cmd = "/usr/bin/clustalo -v --infile=$infile --outfile=$outfile --outfmt=clu --output-order=tree-order --guidetree-out=$dndfile --force > $tmpfile";
  system($cmd);
  my %origins = ();
#  my @alignments = ();
  &createHTML($outfile,$cgi,%origins);
     
  open(D, "$dndfile");
  print "<pre>";
  print "<hr>.dnd file\n\n";
  while(<D>) {
    print $_;
  }
  close D;
  print "</pre>";
}

sub error {
  my ($msg) = @_;

  print "ERROR: $msg\n\n";
  exit(1);
}


sub createHTML {
    my ($outfile, $cgi, %origins) = @_;
  open(O, "$outfile") or die "cant open $outfile for reading:$!";
  my %hash;
  tie %hash, "Tie::IxHash";

  while(<O>) {
    chomp;
    if ($_ =~/CLUSTAL O/) {
  print $cgi->pre("Clustal Omega 1.2.3 Multiple Sequence Alignments\n");
  next;
    }
    elsif($_=~/^CLUSTAL/) {
  print $cgi->pre("Clustal 2.1 Multiple Sequence Alignments\n");
    next;
    }
    next if (/^\s+$/ || /\*{1,}+/);
    my ($id, $seq) = split /\s+/, $_;
    $id =~ s/\s+//g; 
    next if $id eq ""; # not sure why empty ids are not skipped.
    push @{$hash{$id}}, $seq;
  }
  close O;

  my @dnas;
  
  my @alignments2;
  while(my ($id, $seqs) = each %hash) {
    my $seq = join '', @{$hash{$id}};
    my $new_seq = $seq;
    $new_seq =~ s/_//g;
    my $length = length($new_seq);
    push @alignments2, [$id, 0, $length, 0, $length]; 
    push @dnas, $id, $seq;
  }

  my $align = Bio::Graphics::Browser2::PadAlignment->new(\@dnas,\@alignments2);

#  my %origins = ();

#  print $cgi->pre("CLUSTAL 2.1 Multiple Sequence Alignments\n");
  print $cgi->pre($align->alignment( \%origins, { show_mismatches   => 1,
                                                   show_similarities => 1, 
                                                   show_matches      => 1})); 

}


1;