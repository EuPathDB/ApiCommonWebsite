package ApiCommonWebsite::View::GraphPackage::ToxoDB::Dzierszinski::TzBz;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::MixedPlotSet );
use ApiCommonWebsite::View::GraphPackage::MixedPlotSet;
use ApiCommonWebsite::View::GraphPackage::LinePlot;

sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  my $colors = ['#CD853F', '#8FBC8F'];

  my $pch = [19,24];

  my $legend = ['VEG CO2-starvation', 'Pru CO2-starvation'];

  $self->setMainLegend({colors => $colors, short_names => $legend, points_pch => $pch});

     my @profileSetsArray = (['expression profiles of VEG strain CO2-starvation bradyzoite inducing conditions : 2-6 days (by Florence Dzierszinski)','', ''],
	 ['expression profiles of Pru dHXGPRT strain CO2-starvation bradyzoite inducing conditions : 2-14 days (by Florence Dzierszinski)', '', '']
	 );
  my @percentileSetsArray = (['percentile - expression profiles of VEG strain CO2-starvation bradyzoite inducing conditions', '',''],['percentile - expression profiles of Pru dHXGPRT strain CO2-starvation bradyzoite inducing conditions : 2-14 days (by Florence Dzierszinski)','','']);

  my $profileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@profileSetsArray);
  my $percentileSets = ApiCommonWebsite::View::GraphPackage::Util::makeProfileSets(\@percentileSetsArray);

  my $rma = ApiCommonWebsite::View::GraphPackage::LinePlot::RMA->new(@_);
  $rma->setProfileSets($profileSets);
  $rma->setColors($colors);
  $rma->setPointsPch($pch);
  $rma->setDefaultYMax(10);
  $rma->setDefaultYMin(4);

  my $percentile = ApiCommonWebsite::View::GraphPackage::LinePlot::Percentile->new(@_);
  $percentile->setProfileSets($percentileSets);
  $percentile->setColors($colors);
  $percentile->setPointsPch($pch);
  
  $self->setGraphObjects($rma, $percentile);

  return $self;
}

1;
