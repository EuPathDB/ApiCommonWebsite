package ApiCommonWebsite::View::GraphPackage::Templates::SpliceSites;


use strict;
use vars qw( @ISA );

@ISA = qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );
use ApiCommonWebsite::View::GraphPackage::Templates::Expression;
use Data::Dumper;

# @Override
sub getGroupRegex {
  return qr/\[counts\]/;
}

# @Override
sub getRemainderRegex {
  return qr/(\S+) \[counts\]/;
}




1;

package ApiCommonWebsite::View::GraphPackage::Templates::SpliceSites::DS_82d2e9dd6c;
use base qw( ApiCommonWebsite::View::GraphPackage::Templates::Expression );

sub finalProfileAdjustments {
  my ($self, $profile) = @_;

  my $legend = ['spliced leader sites '];
  $profile->setSampleLabels($legend);
}
1;


#--------------------------------------------------------------------------------


# TEMPLATE_ANCHOR spliceSitesGraph

