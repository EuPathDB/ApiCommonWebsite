package ApiCommonWebsite::Model::GoEnrichment;

use ApiCommonWebsite::Model::AbstractEnrichment;
@ISA = (ApiCommonWebsite::Model::AbstractEnrichment);

use strict;
use File::Basename;

sub new {
  my ($class)  = @_;

  my $self = {};
  bless( $self, $class );
  return $self;
}

sub run {
  my ($self, $outputFile, $geneResultSql, $modelName, $pValueCutoff, $subOntology, $evidCodes, $goSubset, $wordcloudFile, $secondOutputFile) = @_;

  die "Second argument must be an SQL select statement that returns the Gene result\n" unless $geneResultSql =~ m/select/i;
  die "Fourth argument must be a p-value between 0 and 1\n" unless $pValueCutoff > 0 && $pValueCutoff <= 1;

#  $self->{sources} = $sources;
  $self->{evidCodes} = $evidCodes;
  $self->{subOntology} = $subOntology;
  $self->{goSubset} = $goSubset;
  $self->SUPER::run($outputFile, $geneResultSql, $modelName, $pValueCutoff, $secondOutputFile);
}

sub getAnnotatedGenesCountBgd {
  my ($self, $dbh, $taxonId) = @_;

  my $sql = "
SELECT count(distinct ga.source_id)
FROM ApidbTuning.GoTermSummary gts, ApidbTuning.GeneAttributes ga
where ga.taxon_id = $taxonId
  and gts.gene_source_id = ga.source_id
  and gts.is_not is null
--  and gts.displayable_source in ($self->{sources})
  AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
 and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
        when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
        else 0
        end = 1
";

  print STDERR "SQL=$sql\n";

  my $stmt = $self->runSql($dbh, $sql);
  my ($geneCount) = $stmt->fetchrow_array();
  die "Got null gene count for bgd annotated genes count\n" unless $geneCount;
  return $geneCount;
}

sub getAnnotatedGenesCountResult {
  my ($self, $dbh, $geneResultSql) = @_;

  my $sql = "
SELECT count(distinct gts.gene_source_id)
FROM ApidbTuning.GoTermSummary gts,
     ($geneResultSql) r
where gts.gene_source_id = r.source_id
  and gts.is_not is null
--  and gts.displayable_source in ($self->{sources})
  AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
 and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
        when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
        else 0
        end = 1
";

  my $stmt = $self->runSql($dbh, $sql);
  my ($geneCount) = $stmt->fetchrow_array();
  die "Got null gene count for result annotated genes count\n" unless $geneCount;
  return $geneCount;
}
sub getAnnotatedGenesListResult {
    my ($self, $dbh, $geneResultSql) = @_;

  my $sql = "
SELECT distinct gts.gene_source_id
FROM ApidbTuning.GoTermSummary gts,
     ($geneResultSql) r
where gts.gene_source_id = r.source_id
  and gts.is_not is null
--  and gts.displayable_source in ($self->{sources})
  AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
 and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
        when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
        else 0
        end = 1
";

    my $stmt = $self->runSql($dbh, $sql);
    my ($geneList) = $stmt->fetchrow_array();
    die "Got null gene count for result annotated genes count\n" unless $geneList;
    return $geneList;
}


#sub getDataSql {
#  my ($self, $taxonId, $geneResultSql) = @_;

#return "
#select distinct bgd.go_id, bgdcnt, resultcnt, round(100*resultcnt/bgdcnt, 1) as pct_of_bgd, bgd.name
#from
# (SELECT gts.go_id, count(distinct gts.gene_source_id) as bgdcnt, gts.go_term_name as name
#            FROM apidbtuning.geneattributes gf,
#                 apidbtuning.gotermsummary gts
#            WHERE gf.taxon_id = $taxonId
#              AND gts.gene_source_id = gf.source_id
#              AND gts.ontology = '$self->{subOntology}'
#--              AND gts.displayable_source in ($self->{sources})
#                AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})

#              AND gts.is_not is null
#            group BY gts.go_id, gts.go_term_name
#   ) bgd,
#   (SELECT gts.go_id, count(distinct gts.gene_source_id) as resultcnt
#            FROM ApidbTuning.GoTermSummary gts,
#                 ($geneResultSql) r
#            WHERE gts.gene_source_id = r.source_id
#              AND gts.ontology = '$self->{subOntology}'
#--              AND gts.displayable_source in ($self->{sources})
#               AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})

#              AND gts.is_not is null
#            group BY gts.go_id
#      ) rslt
#where bgd.go_id = rslt.go_id
#";
#}
sub getDataListSql {
  my ($self, $taxonId, $geneResultSql, $dbh) = @_;
  $dbh->{LongReadLen} = 66000;
  $dbh->{LongTruncOk} = 1;
return "
select bgd.go_id, bgdcnt, resultcnt, resultlist, round(100*resultcnt/bgdcnt, 1) as pct_of_bgd, bgd.name
from
 (SELECT gts.go_id, count(distinct gts.gene_source_id) as bgdcnt, gts.go_term_name as name
            FROM apidbtuning.geneattributes gf,
                 apidbtuning.gotermsummary gts
            WHERE gf.taxon_id = $taxonId
              AND gts.gene_source_id = gf.source_id
              AND gts.ontology = '$self->{subOntology}'
--              AND gts.displayable_source in ($self->{sources})
                AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
                and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
                when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
                else 0
                end = 1

              AND gts.is_not is null
            group BY gts.go_id, gts.go_term_name
   ) bgd,
   (SELECT gts.go_id, count(distinct gts.gene_source_id) as resultcnt
            FROM ApidbTuning.GoTermSummary gts,
                 ($geneResultSql) r
            WHERE gts.gene_source_id = r.source_id
              AND gts.ontology = '$self->{subOntology}'
--              AND gts.displayable_source in ($self->{sources})
               AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
               and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
                   when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
                   else 0
                   end = 1

              AND gts.is_not is null
            group BY gts.go_id
      ) rslt,
--CREATE or replace FUNCTION listagg_clob (input varchar2) RETURN clob
--PARALLEL_ENABLE AGGREGATE USING listagg_clob_t
 (SELECT gts.go_id, rtrim(xmlagg(xmlelement(e,gts.gene_source_id,',').extract('//text()') order by gts.gene_source_id).GetClobVal(),',') AS resultlist
            FROM ApidbTuning.GoTermSummary gts,
                 ($geneResultSql) r
            WHERE gts.gene_source_id = r.source_id
              AND gts.ontology = '$self->{subOntology}'
--              AND gts.displayable_source in ($self->{sources})
               AND decode(gts.evidence_code, 'IEA', 'Computed', 'Curated') in ($self->{evidCodes})
               and case when $self->{goSubset} = 'Yes' and gts.is_go_slim = '1' then 1 
                   when ($self->{goSubset} = 'No' and (gts.is_go_slim = '1' or gts.is_go_slim = '0')) then 1
                   else 0
                   end = 1

              AND gts.is_not is null
            group BY gts.go_id
      ) rsltl
where bgd.go_id = rslt.go_id
and rslt.go_id = rsltl.go_id
and bgd.go_id = rsltl.go_id
";
}

sub usage {
  my $this = basename($0);

  die "
Find pathways that are enriched in the provided set of Genes.

Usage: $this outputFile sqlToFindGeneList modelName pValueCutoff subOntologyName annotationSources

Where:
  sqlToFindGeneList:    a select statement that will return all the rows in the db containing the genes result. Must have a source_id column.
  pValueCutoff:         the p-value exponent to use as a cutoff.  terms with a larger exponent are not returned
  outputFile:           the file in which to write results
  modelName:            eg, PlasmoDB.  Used to find the database connection.
  subOntologyName:      'Molecular Function' etc
  annotationSources:    a list of annotation sources in format compatible with an sql in clause. only include annotation that comes from these one or more sources.  (Eg, GeneDB, InterproScan).

The gene result must only include genes from a single taxon.  It is an error otherwise.

The output file is tab-delimited, with these columns (sorted by e-value)
      - Gene Ontology ID,
      - Gene Ontology Term,
      - Number of genes with this term in this organism,
      - Number of genes with this term in your result,
      - Percentage of genes in the organism with this term that are present in your result,
      - Ratio of the fraction of genes annotated by the term in result set to fraction of annotated genes in the organism,
      - Odds ratio statistic from the Fisher's exact test,
      - P-value from Fisher's exact test,
      - Benjamini-Hochberg FDR,
      - Bonferroni adjusted p-value

";
}

1;
