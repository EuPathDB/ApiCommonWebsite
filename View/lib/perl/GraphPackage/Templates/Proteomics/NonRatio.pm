package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;

sub restrictProfileSetsBySourceId { return 1;}

1;

package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio::tgonME49_quantitativeMassSpec_Wastling_strain_timecourses_RSRC;
use base qw( ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio );
use strict;

sub setMainLegend {
  my $self = @_;

  my $colors = [ '#144BE5' , '#70598F' , '#5B984D' , '#FA9B83' , '#EF724E' , '#E1451A' ];

  print STDERR "Got here, but it's not working";
  my $pch = [ '15', '16', '17', '18', '7:10', '0:6'];

  my $legend = ['GT1 16 hr time course','ME49 16 hr time course', 'ME49 44 hr time course', 'RH 36 hr time course', 'VEG 16 hr time course', 'VEG 44 hr time course'];


  my $hash = {colors => [ '#E9967A', '#87CEFA', '#00BFFF','#4169E1', '#0000FF', ], short_names => $legend, points_pch => $pch, cols=> 2};

  $self->SUPER::setMainLegend($hash);
}

1;

# for ToxoDB


package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio::DS_3c48f52edb;
use Data::Dumper;

sub getRemainderRegex {
  return qr/T\. ?gondii ?(.+) timecourse/;
}

sub keepSingleLegend {1}

sub finalProfileAdjustments {
  my ($self, $profile) = @_;

  $profile->setHasExtraLegend(1);
print STDERR Dumper($profile->getLegendLabels());
  if($profile->getLegendLabels()) {
    my @legendLabels = map {s/Quantitative protein expression of Tgondii proteins in infection of human cells - //;$_} @{$profile->getLegendLabels()};
    $profile->setLegendLabels(\@legendLabels);
    my $colorMap = "c(\"GT1 0 to 16 hour\" = \"#144BE5\", \"ME49 0 to 16 hour\" = \"#70598F\", \"ME49 0 to 44 hour\" = \"#5B984D\", \"RH 0 to 36 hour\" = \"#FA9B83\", \"VEG 0 to 16 hour\" = \"#EF724E\", \"VEG 0 to 44 hour\" = \"#E1451A\")";

    $profile->setColorVals($colorMap);
  }

  return $self;
}
1;


# for HostDB
package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio::DS_08fe07cd15;
sub finalProfileAdjustments {
  my ($self, $profile) = @_;
  my $legend = ['GT1 0 to 16 hr','ME49 0 to 16 hr','ME49 0 to 44 hr', 'RH 0 to 36 hr',
		'VEG 0 to 16 hr', 'VEG 0 to 44 hr'];
  $profile->setHasExtraLegend(1);
  $profile->setLegendLabels($legend);
  return $self;
}
1;


# for TriTrypDB
package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio::DS_bf9c234fd9;

sub finalProfileAdjustments {
  my ($self, $profile) = @_;

  $profile->setDefaultYMax(0.4);
  $profile->addAdjustProfile('profile.df.full = transform(profile.df.full, "LEGEND" = ifelse(NAME == "0.5 hrs" | NAME == " 3 hrs" | NAME == " 10 hrs" | NAME == " 11 hrs", "G1", ifelse(NAME == " 5 hrs" | NAME == " 6 hrs", "S", "G2")));');

  my $colorMap = "c(\"G1\" = \"#aed6f1\", \"S\" = \"#f9e79f\", \"G2\" = \"#a9dfbf\")";
  $profile->setColorVals($colorMap);

  my $plotTitle = $profile->getPlotTitle();
  $profile->setPlotTitle($plotTitle . " : Cell cycle phases" );

  return $self;
}

1;


# for PlasmoDB Apicoplast_ER Quant Proteomes
package ApiCommonWebsite::View::GraphPackage::Templates::Proteomics::NonRatio::DS_32db942cc7;


use EbrcWebsiteCommon::View::GraphPackage::ProfileSet;
use EbrcWebsiteCommon::View::GraphPackage::MixedPlotSet;
use EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthValues;
use EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthNames;


# @Override
sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $specs = $self->getSpecs();

  my @gos;
  foreach my $ps (@$specs) {
    my $go = $self->makeGraphObject($ps->{query}, $ps->{abbrev}, $ps->{name});
    push @gos, $go;
  }
  $self->setGraphObjects(@gos);

  return $self;
}

sub getSpecs {
  return [ {abbrev => "Apico",
            name => "Apicoplast Abundance",
            query => "SELECT ga.source_id, nafe.value
                      FROM apidbtuning.geneattributes ga, results.nafeatureexpression nafe
                      WHERE nafe.na_feature_id = ga.na_feature_id
                      AND nafe.protocol_app_node_id = 1091365",
           },
           {abbrev => "ER",
            name => "ER Abundance",
            query => "SELECT ga.source_id, nafe.value
                      FROM apidbtuning.geneattributes ga, results.nafeatureexpression nafe
                      WHERE nafe.na_feature_id = ga.na_feature_id
                      AND nafe.protocol_app_node_id = 1091374",
           },
      ];
}


sub makeGraphObject {
  my ($self, $sourceIdValueQuery, $abbrev, $name) = @_;

  my $id = $self->getId();

  my $goValuesCannedQueryGene = EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthValues->new
      ( SourceIdValueQuery => $sourceIdValueQuery, N => 200, Name => "_${abbrev}_gv", Id => $id);

  my $goNamesCannedQueryGene = EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthNames->new
      ( SourceIdValueQuery => $sourceIdValueQuery, N => 200, Name => "_${abbrev}_gen", Id => $id);


  my $goValuesCannedQueryCurve = EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthValues->new
      ( SourceIdValueQuery => $sourceIdValueQuery, N => 200, Name => "_${abbrev}_av", Id => 'ALL');

  my $goNamesCannedQueryCurve = EbrcWebsiteCommon::Model::CannedQuery::PhenotypeRankedNthNames->new
      ( SourceIdValueQuery => $sourceIdValueQuery, N => 200, Name => "_${abbrev}_aen", Id => 'ALL');


  my $goProfileSetGene = EbrcWebsiteCommon::View::GraphPackage::ProfileSet->new("DUMMY");
  $goProfileSetGene->setProfileCannedQuery($goValuesCannedQueryGene);
  $goProfileSetGene->setProfileNamesCannedQuery($goNamesCannedQueryGene);

  my $goProfileSetCurve = EbrcWebsiteCommon::View::GraphPackage::ProfileSet->new("DUMMY");
  $goProfileSetCurve->setProfileCannedQuery($goValuesCannedQueryCurve);
  $goProfileSetCurve->setProfileNamesCannedQuery($goNamesCannedQueryCurve);

  my $go = EbrcWebsiteCommon::View::GraphPackage::GGLinePlot->new(@_);

  $go->setDefaultYMin(0);
  $go->setDefaultYMax(0.2);
  $go->setProfileSets([$goProfileSetCurve, $goProfileSetGene]);
  $go->setYaxisLabel($name);
  $go->setColors(["grey", "red"]);
  #$go->setColors(["grey", "blue"]);
  $go->setPartName($abbrev);
  $go->setPlotTitle("$id - $name");
  $go->setXaxisLabel("");


  my $legend = ["All Genes", $id];

  $go->setHasExtraLegend(1);
  $go->setLegendLabels($legend);


  return $go;
}

1;



#--------------------------------------------------------------------------------

# TEMPLATE_ANCHOR proteomicsSimpleNonRatio
