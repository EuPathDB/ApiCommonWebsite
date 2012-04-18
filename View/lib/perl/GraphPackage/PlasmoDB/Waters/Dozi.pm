package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Waters::Dozi;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::BarPlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors = ['#B22222', 'darkblue' ];


  my @profileSetNames = (['P. berghei DOZI array data', 'standard error - P. berghei DOZI array data']);
  my @percentileSetNames = (['red percentile - P. berghei DOZI array data'],
                            ['green percentile - P. berghei DOZI array data']
                           );

  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetNames);
  my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@percentileSetNames);

  my $ratio = ApiCommonWebsite::View::GraphPackage::BarPlot::LogRatio->new(@_);
  $ratio->setProfileSets($profileSets);
  $ratio->setColors([$colors->[0]]);
  $ratio->setForceHorizontalXAxis(1);

  my $percentile = ApiCommonWebsite::View::GraphPackage::BarPlot::Percentile->new(@_);
  $percentile->setProfileSets($percentileSets);
  $percentile->setColors($colors);
  $percentile->setForceHorizontalXAxis(1);

  $self->setGraphObjects($ratio, $percentile);

  return $self;
}



1;
