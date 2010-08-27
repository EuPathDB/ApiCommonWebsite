package ApiCommonWebsite::View::GraphPackage::PlasmoDB::Stunnenberg::PfRBCRnaSeq;

use strict;
use vars qw( @ISA );


@ISA = qw( ApiCommonWebsite::View::GraphPackage::LinePlot );
use ApiCommonWebsite::View::GraphPackage::LinePlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setScreenSize(250);
  $self->setBottomMarginSize(8);
#  $self->setLegendSize(60);

  my $colors =['#E9967A'];

  $self->setProfileSetsHash
    ({coverage => {profiles => ['Profiles of P.falciparum Stunnenberg mRNA Seq data'],
                   y_axis_label => 'Normalized Coverage (log2)',
                   x_axis_label => 'Hours Post Infection',
                   default_y_max => 15,
                   r_adjust_profile => 'for(idx in length(profile)) {if(profile[idx] < 1) {profile[idx] = 1}}; profile = log2(profile); ',
                   colors => $colors,
                  },
      pct => {profiles => ['Percents of P. falciparum Stunnenberg mRNA Seq data'],
              y_axis_label => 'Percentile',
              x_axis_label => 'Hours Post Infection',
              default_y_max => 50,
              colors => $colors,
             },
     });

  return $self;
}

1;
