package ApiCommonWebsite::View::GraphPackage::TriTrypDB::Papadopoulou::LiAxenicVsIntracellular;

use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::BarPlot );
use ApiCommonWebsite::View::GraphPackage::BarPlot;


sub init {
  my $self = shift;

  $self->SUPER::init(@_);

  $self->setBottomMarginSize(5);
  $self->setLegendSize(40);

  my $colors =['#43C6DB', '#4AA02C'];

  my $legend = ["Intracellular Amastigote vs Promastigote", "Axenic Amastigote vs Promastigote"];

  $self->setMainLegend({colors => ['#43C6DB', '#4AA02C'], short_names => $legend, cols => 1});

  $self->setProfileSetsHash
    ({'expr_val' => {profiles => ['Profiles of Linfantum axenic and intracellular amastigote array data'],
                           y_axis_label => 'Expression Value',
                           colors => $colors,
                           r_adjust_profile => 'profile = cbind(profile[1,1:3], profile[1,4:6]);',
                           default_y_max => 1.5,
                           default_y_min => -1.5,
                           force_x_axis_label_horizontal => 1,
                           make_y_axis_fold_incuction => 1,
                           x_axis_labels => ['I.C Amastigote vs Promastigote', 'Ax. Amastigote vs Promastigote'],
                           plot_title => 'Comparison of Axenic and Intracellular Amastigotes (with Promastigotes) with Transcript profiling',
                          },
      pct => {profiles => ['Linfantum axenic and intracellular amastigote array data profile percents(red)',
                           'Linfantum axenic and intracellular amastigote array data profile percents(green)'],
                           y_axis_label => 'Percentile',
                           default_y_max => 50,
                           colors => $colors,
                           x_axis_labels => ['I.C Amastigote vs Promastigote', 'Ax. Amastigote vs Promastigote'],
                           plot_title => 'Comparison of Axenic and Intracellular Amastigotes (with Promastigotes) with Transcript profiling',
             },
     });

  return $self;
}



1;
