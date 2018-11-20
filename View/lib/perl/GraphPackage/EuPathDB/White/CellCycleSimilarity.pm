package ApiCommonWebsite::View::GraphPackage::EuPathDB::White::CellCycleSimilarity;

use strict;
use vars qw( @ISA );

@ISA = qw( EbrcWebsiteCommon::View::GraphPackage::MixedPlotSet );
use EbrcWebsiteCommon::View::GraphPackage::MixedPlotSet;
use EbrcWebsiteCommon::View::GraphPackage::SimilarityPlot;

use EbrcWebsiteCommon::View::GraphPackage::Util;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my @colors = ('blue', 'grey');
  my @legend = ('Match', 'Query');

  $self->setMainLegend({colors => \@colors, short_names => \@legend, cols => 2});
  $self->setPlotWidth(450);

  # Need to make 2 Profiles ... one for the primaryID and one for the Secondary
  my @profileArray = (['M.White Cell Cycle Microarray','values'],
                      ['M.White Cell Cycle Microarray','values'],
                     );

  my $profileSets = EbrcWebsiteCommon::View::GraphPackage::Util::makeProfileSets(\@profileArray);

  my $similarity = EbrcWebsiteCommon::View::GraphPackage::SimilarityPlot::LogRatio->new(@_);
  $similarity->setProfileSets($profileSets);
  $similarity->setColors(\@colors);
  $similarity->setPointsPch([15,15]);
  $similarity->setElementNameMarginSize(6.5);
  $similarity->setXaxisLabel("Time Point (hours)");

  $self->setGraphObjects($similarity);

  return $self;
}

1;
