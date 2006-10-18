<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<table width="100%" border="0" cellspacing="2" cellpadding="2" style="border-style:outset; border-color:black;border-width:1px;">
<tr><td width="34%"></td><td width="33%"></td><td width="33%"></td></tr>
    <tr>
        <td colspan="2"><h7><b><i>Identify Genes Based On:</i></b></h7></td>
        <td></td>
    </tr>
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Genomic Position" qtype="Gene"/>  
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByLocation" linktext="Chromosomal Location" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByCentromereProximity" linktext="Proximity to Centromeres" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="Proximity to Telomeres" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="Non-nuclear Genomes" />
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Gene Attributes" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByGeneType" linktext="Type (e.g. rRNA, tRNA)"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByExonCount" linktext="Exon/Intron Structure" />
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Predicted Proteins" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByMolecularWeight" linktext="Molecular Weight" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByIsoelectricPoint" linktext="Isoelectric Point" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesBySecondaryStructure" linktext="Secondary Structure" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByPdbSimilarity" linktext="Crystal Structure"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesWithStructurePrediction" linktext="Predicted 3D Structure"/>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Putative Function" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByGoTerm" linktext="GO Term" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByEcNumber" linktext="EC Number" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByMetabolicPathway" linktext="Metabolic Pathway" />
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByProteinProteinInteraction" linktext="Y2H Interaction"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByFunctionalInteraction" linktext="Predicted Interaction"/>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Similarity/Pattern" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByMotifSearch" linktext="Protein Motif" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByPfamDomain" linktext="Pfam Domain" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesBySimilarity" linktext="BLAST similarity" existsOn="A C P T"/>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Transcript Expression" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByESTClusterOverlap" linktext="EST Evidence"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="SAGE Tag Evidence"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="Microarray Evidence"/>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Protein Expression" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByMassSpec" linktext="Mass Spec. Evidence"/>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Cellular Location" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesWithSignalPeptide" linktext="Signal Peptide"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByTransmembraneDomains" linktext="Transmembrane Domain"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesBySubcellularLocalization" linktext="Organellar Compartment"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByExportPrediction" linktext="Exported to Host"/>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Evolution" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesOrthologousToAGivenGene" linktext="Orthologs/Paralogs"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByOrthologPattern" linktext="Orthology Profile"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByPhyleticProfile" linktext="Homology Profile"/>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Population Biology" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="SNPs"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="NA" linktext="Microsatellites"/>
                </tr>
            </table>
        </td>

        <td colspan="2" valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr class="rowDarkBold">
                    <site:makeTitle qcat="Other Attributes" qtype="Gene"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByTextSearch" linktext="Text (search product name, notes, etc.)"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GeneByLocusTag" linktext="Identifier (e.g. ApiDB ID, GenBank ID, SwissProt ID, etc.)"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByTaxon" linktext="Species"/>
                </tr>
                <tr>
                    <site:makeURL qset="GeneQuestions" qname="GenesByMr4Reagents" linktext="Reagents Available (e.g. antibodies from MR4)"/>
                </tr>

              
            </table>
        </td>
    </tr>

<tr><br></td></tr>

    <tr>
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr>
                    <td colspan="4"><h7><i><b>Identify Genomic Sequences Based On:</b></i></h7></td>
                </tr>
                <tr class="rowDarkBold">
                        <site:makeTitle qcat="Similarity/Pattern" qtype="Contig"/>

                </tr>
               
                <tr>
                    <site:makeURL qset="GenomicSequenceQuestions" qname="SequencesBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"  />
                </tr>
                <tr>
                    <site:makeURL qset="GenomicSequenceQuestions" qname="NA" linktext="DNA Sequence Motif"/>
                </tr>
               <tr class="rowDarkBold">
                         <site:makeTitle qcat="Other Attributes" qtype="Contig"/>
                        
                </tr>
                <tr>
                    <site:makeURL qset="GenomicSequenceQuestions" qname="SequenceBySourceId" linktext="Identifier (e.g. ApiDB ID, GenBank ID, etc)"  existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="GenomicSequenceQuestions" qname="SequencesByTaxon" linktext="Species"/>
                </tr>
            </table>
        </td>

        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr>
                    <td colspan="4"><h7><b><i>Identify ESTs Based On:</i></b></h7></td>
                </tr>
                <tr class="rowDarkBold">
                     <site:makeTitle qcat="Similarity/Pattern" qtype="EST"/>
                </tr>
                
                <tr>
                    <site:makeURL qset="EstQuestions" qname="EstsBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="EstQuestions" qname="NA" linktext="EST Sequence Motif"/>
                </tr>
                <tr class="rowDarkBold">
                       <site:makeTitle qcat="Other Attributes" qtype="EST"/>
                </tr>
                <tr>
                    <site:makeURL qset="EstQuestions" qname="EstsByTaxon" linktext="Species"/>
                </tr>
            </table>
        </td>
 
 
        <td valign="top">
            <table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr>
                    <td colspan="4"><h7><b><i>Identify ORFs Based On:</i></b></h7></td>
                </tr>
                <tr class="rowDarkBold">
                     <site:makeTitle qcat="Similarity/Pattern" qtype="ORF"/>
                </tr>
                
                <tr>
                    <site:makeURL qset="OrfQuestions" qname="OrfsBySimilarity" linktext="BLAST Similarity" existsOn="A C P T"/>
                </tr>
                <tr>
                    <site:makeURL qset="OrfQuestions" qname="OrfsByMotifSearch" linktext="ORF Sequence Motif" existsOn="A C P T"/>
                </tr>
                <tr class="rowDarkBold">
                         <site:makeTitle qcat="Other Attributes" qtype="ORF"/>
                </tr>
                <tr>
                    <site:makeURL qset="OrfQuestions" qname="OrfsByTaxon" linktext="Species"/>
                </tr>
            </table>
        </td>
    </tr>
<tr><td><br></td></tr>

</table>
