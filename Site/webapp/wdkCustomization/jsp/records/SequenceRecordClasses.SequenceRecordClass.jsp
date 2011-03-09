<%@ taglib prefix="site" tagdir="/WEB-INF/tags/site" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="w" uri="http://www.servletsuite.com/servlets/wraptag" %>
<%@ taglib prefix="wdk" tagdir="/WEB-INF/tags/wdk" %>

<%/* get wdkRecord from proper scope */%>
<c:set value="${requestScope.wdkRecord}" var="wdkRecord"/>
<c:set var="attrs" value="${wdkRecord.attributes}"/>
<c:set var="props" value="${applicationScope.wdkModel.properties}" />

<c:set var="primaryKey" value="${wdkRecord.primaryKey}"/>
<c:set var="pkValues" value="${primaryKey.values}" />
<c:set var="projectId" value="${pkValues['project_id']}" />
<c:set var="id" value="${pkValues['source_id']}" />

<c:set var="projectIdLowerCase" value="${fn:toLowerCase(projectId)}"/>

<c:set var="SRT_CONTIG_URL" value="/cgi-bin/contigSrt"/>

<c:set var="recordType" value="${wdkRecord.recordClass.type}" />

<c:catch var="err">
<%-- force RecordInstance.fillColumnAttributeValues() to run
      and set isValidRecord to false if appropriate. 
      wdkRecord.isValidRecord is tested in the project's RecordClass --%>
<c:set var="junk" value="${attrs['organism']}"/>
</c:catch>

<site:header title="${id}"
             divisionName="Genomic Sequence Record"
             refer="recordPage"
             division="queries_tools"/>

<c:choose>
<c:when test="${!wdkRecord.validRecord}">
  <h2 style="text-align:center;color:#CC0000;">The ${fn:toLowerCase(recordType)} '${id}' was not found.</h2>
</c:when>
<c:otherwise>

<c:set var="externalDbName" value="${attrs['externalDbName'].value}" />
<c:set var="organism" value="${wdkRecord.attributes['organism'].value}" />
<c:set var="is_top_level" value="${wdkRecord.attributes['is_top_level'].value}" />

<br/>

<%-- quick tool-box for the record --%>
<site:recordToolbox />

<h2>
<center>
<wdk:recordPageBasketIcon />
</center>
</h2>

<%--#############################################################--%>




<c:set var="append" value="" />

<c:set var="attr" value="${attrs['overview']}" />
<site:panel 
    displayName="${attr.displayName}"
    content="${attr.value}" />
<br>


<%------------------------------------------------------------------%>
<c:url var="commentsUrl" value="addComment.do">
  <c:param name="stableId" value="${id}"/>
  <c:param name="commentTargetId" value="genome"/>
  <c:param name="externalDbName" value="${attrs['externalDbName'].value}" />
  <c:param name="externalDbVersion" value="${attrs['externalDbVersion'].value}" />
  <c:param name="flag" value="0" /> 
</c:url>
<c:catch var="e">
      <wdk:wdkTable tblName="SequenceComments" isOpen="true"/>
      <a href="${commentsUrl}"><font size='-2'>Add a comment on ${id}</font></a>
</c:catch>
<c:if test="${e != null}">
     <site:embeddedError 
         msg="<font size='-1'><b>User Comments</b> is temporarily unavailable.</font>"
         e="${e}" 
     />
</c:if>
    
<br>


<%-- DNA CONTEXT ---------------------------------------------------%>
<%------------------------------------------------------------------%>
<%-- Gbrowse tracks defaults  --------------------------------------%>
<%------------------------------------------------------------------%>
<c:set var="gtracks" value="${attrs['gbrowseTracks'].value}" />
<%------------------------------------------------------------------%>
<%-- Gbrowse tracks defaults For Unannotated genomes  --------------%>
<%------------------------------------------------------------------%>
<c:if test="${attrs['gene_count'].value == 0}">
  <c:set var="gtracks" value="BLASTX+ORF600+TandemRepeat+LowComplexity" />

  <%------------------------------------------------------------------%>
  <c:choose>
    <c:when test="${projectId eq 'TriTrypDB' && attrs['length'].value > 300000}">
      <c:set var="gtracks" value="BLASTX+ORF600+TandemRepeat+LowComplexity" />
    </c:when>
    <c:when test="${projectId ne 'TriTrypDB' && attrs['length'].value < 100000}">
      <c:set var="gtracks" value="BLASTX+ORF+TandemRepeat+LowComplexity" />
    </c:when>
    <c:otherwise>
      <c:set var="gtracks" value="BLASTX+ORF300+TandemRepeat+LowComplexity" />
    </c:otherwise>
  </c:choose>
  <%------------------------------------------------------------------%>
  <%-- Gbrowse tracks defaults For Specific Genomes   ----------------%>
  <%------------------------------------------------------------------%>
  <c:if test="${ (fn:contains(organism,'Anncaliia') || fn:contains(organism,'Edhazardia') || fn:contains(organism,'Nosema') || fn:contains(organism,'Vittaforma')) && projectId eq 'MicrosporidiaDB'}">
    <c:set var="gtracks" value="" />
  </c:if>
</c:if>
<%------------------------------------------------------------------%>





<c:set var="attribution">
</c:set>

<c:if test="${gtracks ne ''}">
    <c:set var="genomeContextUrl">
    http://${pageContext.request.serverName}/cgi-bin/gbrowse_img/${projectIdLowerCase}/?name=${id}:1..${attrs['length'].value};hmap=gbrowse;type=${gtracks};width=640;embed=1;h_feat=${feature_source_id}@yellow
    </c:set>
    <c:set var="genomeContextImg">
        <noindex follow><center>
        <c:catch var="e">
           <c:import url="${genomeContextUrl}"/>
        </c:catch>
        <c:if test="${e!=null}"> 
            <site:embeddedError 
                msg="<font size='-2'>temporarily unavailable</font>" 
                e="${e}" 
            />
        </c:if>
        </center>
        </noindex>

        <c:set var="labels" value="${fn:replace(gtracks, '+', ';label=')}" />
        <c:set var="gbrowseUrl">
            /cgi-bin/gbrowse/${projectIdLowerCase}/?name=${id}:1..${attrs['length'].value};label=${labels};h_feat=${id}@yellow
        </c:set>
        <a href="${gbrowseUrl}"><font size='-2'>View in Genome Browser</font></a>

    </c:set>

    <wdk:toggle 
        isOpen="true"
        name="genomicContext"
        displayName="Genomic Context"
        content="${genomeContextImg}"
        attribution="${attribution}"/>
    <br>
</c:if>


<br>

<c:if test="${projectId eq 'GiardiaDB' || projectId eq 'PlasmoDB' || projectId eq 'ToxoDB' || projectId eq 'TriTrypDB'}">
	<wdk:wdkTable tblName="Aliases" isOpen="true" attribution=""/>
</c:if>

<wdk:wdkTable tblName="Centromere" isOpen="true"
                 attribution=""/>

<wdk:wdkTable tblName="SequencePieces" isOpen="true"
                 attribution=""/>

<%------------------------------------------------------------------%>

<c:set var="content">
${externalLinks}
<form action="${SRT_CONTIG_URL}" method="GET">
 <table border="0" cellpadding="0" cellspacing="1">
  <tr class="secondary3"><td>
  <table border="0" cellpadding="0">
    <tr><td colspan="2"><h3>Retrieve this Contig with the Sequence Retrieval Tool</h3>
      <input type='hidden' name='ids' size='20' value="${id}" />
      <input type='hidden' name='project_id' size='20' value="${projectId}" />
    </td></tr>
    <tr><td colspan="2"><b>Nucleotide positions:</b> &nbsp;&nbsp;
        <input type="text" name="start" value="1" maxlength="10" size="10" />
     to <input type="text" name="end"   value="${attrs['length'].value}" maxlength="10" size="10" />
     &nbsp;&nbsp;&nbsp;&nbsp;
         <input type="checkbox" name="revComp" ${initialCheckBox}>Reverse & Complement
    </td></td>
    <tr><td><input type="submit" name='go' value='Get Sequence' /></td></tr>
  </table>
  </td></tr>
 </table>
</form>

<c:if test="${is_top_level eq '1' && ((projectId eq 'PlasmoDB' && fn:containsIgnoreCase(organism, 'falciparum')) || (projectId eq 'TriTrypDB' && !fn:contains(organism,'Crithidia') && !fn:contains(organism,'tarentolae')) || projectId eq 'CryptoDB' || projectId eq 'ToxoDB' || projectId eq 'AmoebaDB' || projectId eq 'MicrosporidiaDB')}">


  <br />
<h3>Retrieve Multiple Sequence Alignments by Contig / Genomic Sequence IDs</h3>
  <c:if test="${attrs['has_msa'].value == 1}">
   <site:mercatorMAVID cgiUrl="/cgi-bin" projectId="${projectId}" contigId="${id}"
      start="1" end="${attrs['length'].value}" bkgClass="secondary3" cellPadding="0"/>
  </c:if>
</c:if>
</c:set>

<wdk:toggle
    isOpen="true"
    name="Sequences"
    attribution=""
    displayName="Sequences"
    content="${content}" />

<%------------------------------------------------------------------%>
<%------------------------------------------------------------------%>


<%------- The Attribution Section is Organism Specific -------------%>

<%------------------------------------------------------------------%>
<%------------------------------------------------------------------%>


 <c:choose>
 <c:when test="${fn:containsIgnoreCase(organism, 'Cryptosporidium hominis') && projectId eq 'CryptoDB'}">
 <c:set var="reference">
    Xu P, Widmer G, Wang Y, Ozaki LS, Alves JM, Serrano MG, Puiu D, Manque P, 
    Akiyoshi D, Mackey AJ, Pearson WR, Dear PH, Bankier AT, Peterson DL, 
    Abrahamsen MS, Kapur V, Tzipori S, Buck GA. 
    <b>The genome of <i>Cryptosporidium hominis</i>.</b> 
    Nature. 2004 Oct 28;<a href="http://www.nature.com/nature/journal/v431/n7012/abs/nature02977.html"><b>431</b>(7012):1107-12</a>.
</c:set>
</c:when>
<c:when test="${fn:containsIgnoreCase(organism, 'Cryptosporidium muris') && projectId eq 'CryptoDB'}">
<c:set var="reference">
    The Cryptosporidium muris genome sequencing project has been funded by the
    National Institute of Allergy and Infections Diseases (NIAID), through the
    Microbial Sequencing Center program at the Institute for Genomic Research (TIGR). 
</c:set>
</c:when>
 <c:when test="${fn:containsIgnoreCase(organism, 'Cryptosporidium parvum Iowa II') && (id eq 'CM000429' || id eq 'CM000430' || id eq 'CM000431' || id eq 'CM000432' || id eq 'CM000433' || id eq 'CM000434' || id eq 'CM000435' || id eq 'CM000436') && projectId eq 'CryptoDB'}">
<c:set var="reference">
    Mapping of gene coordinates from contigs to chromosomes for <i>C. parvum</i> generated 
    from Genbank chromosome records.
</c:set>
</c:when>
<c:when test="${fn:containsIgnoreCase(organism, 'Cryptosporidium parvum Iowa II') && projectId eq 'CryptoDB'}">
<c:set var="reference">
    Abrahamsen MS, Templeton TJ, Enomoto S, Abrahante JE, Zhu G, Lancto CA, 
    Deng M, Liu C, Widmer G, Tzipori S, Buck GA, Xu P, Bankier AT, Dear PH, 
    Konfortov BA, Spriggs HF, Iyer L, Anantharaman V, Aravind L, Kapur V. 
    <b>Complete genome sequence of the apicomplexan, <i>Cryptosporidium parvum</i>.</b> 
    Science. 2004 Apr 16;
    <a href="http://www.sciencemag.org/cgi/content/full/304/5669/441"><b>304</b>(5669):441-5</a>.
</c:set>
</c:when>
<c:when test="${fn:containsIgnoreCase(organism, 'Cryptosporidium parvum') && projectId eq 'CryptoDB'}">
<%-- sequence_source_id = BX526834 --%>
<c:set var="reference">
    Bankier AT, Spriggs HF, Fartmann B, Konfortov BA, Madera M, Vogel C, 
    Teichmann SA, Ivens A, Dear PH. 
    <b>Integrated mapping, chromosomal sequencing and sequence analysis of <i>Cryptosporidium parvum</i>. 
    </b>Genome Res. 2003 Aug;<a href="http://www.genome.org/cgi/content/full/13/8/1787">13(8):1787-99</a>
</c:set>
</c:when>

<c:when test="${fn:containsIgnoreCase(organism, 'vivax') && (id eq 'AY598140') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b><i>P. vivax</i> mitochondrial sequence and annotation was obtained from Genbank</b>
    </c:set>
    </c:when>
<c:when test="${fn:containsIgnoreCase(organism, 'vivax') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b><i>P. vivax</i> was sequenced by 
        <a href="http://www.tigr.org/tdb/e2k1/pva1/">The
        Institute for Genomic Research</a></b>
    </c:set>
    </c:when>
<c:when test="${fn:containsIgnoreCase(organism, 'yoelii') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b><i>P. yoelii</i> was sequenced by
        <a href="http://www.tigr.org/tdb/edb2/pya1/htmls/">The Institute for Genomic Research</a></b>
    </c:set>
    </c:when>

    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && (id eq 'Pf3D7_02' || id eq 'Pf3D7_10' || id eq 'Pf3D7_11' || id eq 'Pf3D7_14') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum 2, 10, 11, 14 = TIGR --%>
        <b>Chromosome ${id} of <i>P. falciparum</i> 3D7 was
        sequenced at 
        <a href="http://www.tigr.org/tdb/edb2/pfa1/htmls/">The
        Institute for Genomic Research</a>
        and the
        <a href="http://www.nmrc.navy.mil/">Naval
        Medical Research Center</a></b>.
<br>The new annotation for <i>P. falciparum</i> 3D7 genome started in October 2007 with a week-long workshop co-organized by staff from the Wellcome Trust Sanger Institute (WTSI) and the EuPathDB team. Ongoing annotation and error checking is being carried out by the GeneDB group from WTSI.
    </c:set>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && (id eq 'Pf3D7_01' || id eq 'Pf3D7_03' || id eq 'Pf3D7_04' || id eq 'Pf3D7_05' || id eq 'Pf3D7_06' || id eq 'Pf3D7_07' || id eq 'Pf3D7_08' || id eq 'Pf3D7_09' || id eq 'Pf3D7_13') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum 1, 3-9, 13 = Sanger --%>
        <b>Chromosome ${id} of <i>P. falciparum</i> 3D7 was
        sequenced at the 
        <a href="http://www.sanger.ac.uk/Projects/P_falciparum/">Sanger
        Institute</a></b>.
<br>The new annotation for <i>P. falciparum</i> 3D7 genome started in October 2007 with a week-long workshop co-organized by staff from the Wellcome Trust Sanger Institute (WTSI) and the EuPathDB team. Ongoing annotation and error checking is being carried out by the GeneDB group from WTSI.
    </c:set>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && id eq 'Pf3D7_12' && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum 12 = Stanford --%>
        <b>Chromosome ${id} of <i>P. falciparum</i> 3D7 was
        sequenced at the
        <a href="http://sequence-www.stanford.edu/group/malaria/">Stanford
        Genome Technology Center</a></b>.
<br>The new annotation for <i>P. falciparum</i> 3D7 genome started in October 2007 with a week-long workshop co-organized by staff from the Wellcome Trust Sanger Institute (WTSI) and the EuPathDB team. Ongoing annotation and error checking is being carried out by the GeneDB group from WTSI.
    </c:set>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && id eq 'M76611' && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum mitochondrial genome --%>
        <b>The <i>P. falciparum</i> mitochondrial genome was obtained from the Wellcome Trust Sanger Institute (WTSI).</b>
<br>The new annotation for <i>P. falciparum</i> 3D7 genome started in October 2007 with a week-long workshop co-organized by staff from the WTSI and the EuPathDB team. Ongoing annotation and error checking is being carried out by the GeneDB group from WTSI.
    </c:set>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && id eq 'PFC10_API_IRAB' && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum plastid genome --%>
        <b>The <i>P. falciparum</i> plastid genome was obtained from the Wellcome Trust Sanger Institute (WTSI).</b>
<br>The new annotation for <i>P. falciparum</i> 3D7 genome started in October 2007 with a week-long workshop co-organized by staff from the WTSI and the EuPathDB team. Ongoing annotation and error checking is being carried out by the GeneDB group from WTSI.
    </c:set>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(organism, 'falciparum') && id eq 'AJ276844' && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum mitochondrion = University of London --%>
        <b>The mitochondrial genome of <i>P. falciparum</i> was
        sequenced at the
        <a href="http://www.lshtm.ac.uk/pmbu/staff/dconway/dconway.html">London
        School of Hygiene & Tropical Medicine</a></b>
    </c:set>

    </c:when>
    <c:when test="${organism eq '<i>P.&nbsp;falciparum 3D7</i>' && (id eq 'X95275' || id eq 'X95276') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- P. falciparum plastid --%>
        <b>The <i>P. falciparum</i> plastid was
        sequenced at the 
        <a href="http://www.nimr.mrc.ac.uk/parasitol/wilson/">National
        Institute for Medical Research</a></b>
    </c:set>
    </c:when>
    <c:when test="${fn:contains(organism,'berghei') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- e.g.PB000938.03.0 --%>
        <b>The <i>P. berghei</i> genome was sequenced by the
        <a href="http://www.sanger.ac.uk/Projects/P_berghei">Sanger
        Institute</a></b>
<br><b>The Wellcome Trust Sanger Institute plans on publishing the completed and annotated sequences (i.e. 8X assembly and updated annotation) of P. chabaudi AS in a peer-reviewed journal as soon as possible. Permission of the principal investigator should be obtained before publishing analyses of the sequence/open reading frames/genes on a chromosome or genome scale.</b>
    </c:set>
    </c:when>
    <c:when test="${fn:contains(organism,'knowlesi') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b>The <i>P.knowlesi </i> genome was sequenced by the
        <a href="http://www.sanger.ac.uk/Projects/P_knowlesi">Sanger
        Institute</a></b>
    </c:set>
    </c:when>
    <c:when test="${fn:contains(organism,'reichenowi') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b>The <i>P. reichenowi</i> genome was sequenced by the
        <a href="http://www.sanger.ac.uk/Projects/P_reichenowi">Sanger
        Institute</a></b>
    </c:set>
    </c:when>
    <c:when test="${fn:contains(organism,'gallinaceum') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <b>The <i>P. gallinaceum</i> genome was sequenced by the
        <a href="http://www.sanger.ac.uk/Projects/P_gallinaceum">Sanger
        Institute</a></b>
    </c:set>
    </c:when>
    <c:when test="${fn:contains(organism,'chabaudi') && projectId eq 'PlasmoDB'}">
    <c:set var="reference">
        <%-- e.g. PC000000.00.0 --%>
Annotation of the P. chabaudi AS chromosomes was obtained from the Pathogen Sequencing Unit at the <a href="http://www.sanger.ac.uk/Projects/P_chabaudi">Wellcome Trust Sanger Institute</a>, 2009-03-24. It included sequence and gene models. 
<br><b>The Wellcome Trust Sanger Institute plans on publishing the completed and annotated sequences (i.e. 8X assembly and updated annotation) of P. chabaudi AS in a peer-reviewed journal as soon as possible. Permission of the principal investigator should be obtained before publishing analyses of the sequence/open reading frames/genes on a chromosome or genome scale.</b>
    </c:set>
    </c:when>

    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'ME49')}">
    <c:set var="reference">
     <b><i>Toxoplasma gondii</i> ME49  sequence and annotation from Lis Caler at the J. Craig Venter Institute (<a href="http://msc.jcvi.org/t_gondii/index.shtml"Target="_blank">JCVI</a>).</b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'GT1')}">
    <c:set var="reference">
     <b><i>Toxoplasma gondii</i> GT1  sequence and annotation from Lis Caler at the J. Craig Venter Institute (<a href="http://msc.jcvi.org/t_gondii/index.shtml"Target="_blank">JCVI</a>).</b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'VEG')}">
    <c:set var="reference">
     <b><i>Toxoplasma gondii</i> VEG  sequence and annotation from Lis Caler at the J. Craig Venter Institute (<a href="http://msc.jcvi.org/t_gondii/index.shtml"Target="_blank">JCVI</a>).</b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'RH') && id eq 'NC_001799'}">
    <c:set var="reference">
     <b>Genome sequence and annotation for <i>T. gondii</i> apicoplast provided by David Roos (University of Pennsylvania), Jessica Kissinger (University of Georgia).The apicoplast genome of <i>T. gondii</i> RH (Type I) strain is 34996 bps long (GeneBank accession #: <a href="http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?db=nucleotide&val=NC_001799"TARGET="_blank">NC_001799</a>). Click <a href="http://roos.bio.upenn.edu/%7Erooslab/jkissing/plastidmap.html"TARGET="_blank">here</a> to view a map of the <i>T. gondii</i> apicoplast. </b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'RH')}">
    <c:set var="reference">
     <b>Scaffold genome sequence for <i>Toxoplasma gondii</i> type I RH strain (Chromosomes Ia and Ib only) provided on 2006-09-25, by Matt Berriman (The Wellcome Trust Sanger Institute), Jim Ajioka (University of Cambridge).</b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'caninum')}">
    <c:set var="reference">
<b>Chromosome sequences and annotation for <i>Neospora caninum</i> obtained from the Pathogen Sequencing Unit at the Wellcome Trust Sanger Institute.</b>
    </c:set>
    </c:when>
    <c:when test="${projectId eq 'ToxoDB' && fn:contains(organism,'TgCkUg2')}">
    <c:set var="reference">
      <b>Whole genome sequence of the natural recombinant Toxoplasma gondii strain TgCkUg2 was provided by Irene Lindstrom Bontell and Judith E Smith, Institute of Integrative and Comparative Biology, Clarendon Way, University of Leeds, Leeds, LS2 9JT, UK.  Further information may be obtained from the following publication: Genome Biol. 2009 May 20;10(5):R53. PMID 19457243.</b>
   </c:set>
   </c:when>


    <c:when test="${projectId eq 'TrichDB'}">
    <c:set var="reference">
     T. vaginalis sequence from Jane Carlton (NYU,TIGR). PMID: 17218520
    </c:set>
    </c:when>

  <c:when test="${projectId eq 'GiardiaDB' && fn:contains(organism,'ATCC 50803')}">
     <c:set var="reference">
<b>Genomic minimalism in the early diverging intestinal parasite <i>Giardia lamblia</i>. </b>
Hilary G. Morrison, Andrew G. McArthur, Frances D. Gillin, Stephen B. Aley, Rodney D. Adam, Gary J. Olsen, Aaron A. Best, W. Zacheus Cande, Feng Chen, Michael J. Cipriano, Barbara J. Davids, Scott C. Dawson, Heidi G. Elmendorf, Adrian B. Hehl, Mic
hael E. Holder, Susan M. Huse, Ulandt U. Kim, Erica Lasek-Nesselquist, Gerard Manning, Anuranjini Nigam, Julie E. J. Nixon, Daniel Palm, Nora E. Passamaneck, Anjali Prabhu, Claudia I. Reich, David S. Reiner, John Samuelson, Staffan G. Svard, and M
itchell L. Sogin.  <font color="blue">Science 28 September 2007, Volume 317, pp. 1921-1926.</font>
    </c:set>
  </c:when>
  <c:when test="${projectId eq 'GiardiaDB' && fn:contains(organism,'ATCC 50581')}"> 
     <c:set var="reference">
<b>Draft Genome Sequencing of <i>Giardia intestinalis</i> Assemblage B Isolate GS: Is Human Giardiasis Caused by Two Different Species ?</b>  Franzen O, Jerlstrom-Hultqvist J, Castro E, Sherwood E, Ankarklev J, Reiner DS, Palm D, Andersson JO, Andersson B, Svard SG. http://www.ncbi.nlm.nih.gov/pubmed/19696920
     </c:set>
  </c:when>
  <c:when test="${projectId eq 'GiardiaDB' && fn:contains(organism,'P15')}"> 
     <c:set var="reference">
Sequence and annotation of <i>Giardia</i> Assemblage E isolate P15 was provided by J. Jerlstrom-Hultqvist. O. Franzen, E.Castro, J. Ankarklev, D. Palm, J. O. Andersson, S.G. Svard and B. Andersson (Karolinska Institutet, Stockholm, Sweden and Uppsala University, Uppsala, Sweden).  The genome sequence and annotation was provided to GiardiaDB prepublication and is expected to be published in a peer-reviewed journal as soon as possible. Permission should be obtained from the authors before publishing analyses of the sequence/open reading frames/genes on a chromosome or genome scale.
     </c:set>
  </c:when>

<c:when test="${fn:contains(organism,'brucei gambiense') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
  Chromosome sequences and annotations for <i>Trypanosoma brucei gambiense</i> obtained from the Pathogen Sequencing Unit at the Wellcome Trust Sanger Institute
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'brucei TREU927') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Sequence data for <i>Trypanosome brucei</i> strain TREU (Trypanosomiasis Research Edinburgh University) 927/4 were downloaded from <a href="http://www.genedb.org/genedb/tryp/">GeneDB</a> (sequence and annotated features).<br>
Sequencing of <i>T. brucei</i> was conducted by <a href="http://www.sanger.ac.uk/Projects/T_brucei/">The Sanger Institute pathogen sequencing unit</a> and <a href="http://www.tigr.org/tdb/e2k1/tba1/">TIGR</a>.
     </c:set>
  </c:when>
<c:when test="${fn:contains(organism,'brucei strain 427') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
  <i>Trypanosoma brucei</i> strain Lister 427 genome sequence and assembly was provided prepublication by Dr. George Cross. For additional information please see information in the <a href="showXmlDataContent.do?name=XmlQuestions.DataSources&datasets=Tbrucei427_chromosomes_RSRC&title=Query#Tbrucei427_chromosomes_RSRC">data sources</a> page.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'congolense') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
Chromosome and unassigned contig sequences and annotations for <i>Trypanosoma congolense</i> obtained from the Pathogen Sequencing Unit at the Wellcome Trust Sanger Institute
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'CL Brener') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
      Sequence data for <i>Trypanosoma cruzi</i> strain CL Brener contigs were downloaded from Genbank (sequence and annotated features).<br>  Sequencing of <i>T. cruzi</i> was conducted by the <i>Trypanosoma cruzi</i> sequencing consortium (<a href="http://www.tigr.org/tdb/e2k1/tca1/">TIGR</a>, <a href="http://www.sbri.org/">Seattle Biomedical Research Institute</a> and <a href="http://ki.se/ki/jsp/polopoly.jsp?d=130&l=en">Karolinska Institute</a>.
<br/>Mapping of gene coordinates from contigs to chromosomes for T. cruzi strain CL Brener chromosomes, generated by Rick Tarleton lab (UGA).
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'strain esmeraldo') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
Sequence from <i>Trypanosoma cruzi</i> Esmeraldo strain cl3 was obtained from Dr. Gregory Buck, Center for the Study of Biological Complexity, Microbiology and Immunology, Virginia Commonwealth University. <br><br>It is requested that users of this <i>Trypanosoma cruzii</i> Esmeraldo cl3 strain sequence assembly acknowledge Gregory A. Buck, Virginia Commonwealth University, and The Genome Center, Washington University School of Medicine in any publications that result from use of this sequence assembly.<br><br>Any publications that propose to use whole genome or chromosome data should contact The Genome Center at Washington University (gweinsto@wustl.edu or wwarren@wustl.edu) for the use of pre-publication data.  Please refer to the <a href="http://genome.wustl.edu/data/data_use_policy">Genome Center Data Use Policy</a> for further information regarding proper use of data and proper citation.<br><br> For additional information on this <i>Trypanosoma cruzi</i> assembly, please visit the <a href="showXmlDataContent.do?name=XmlQuestions.DataSources&datasets=TcruziEsmeraldo_scaffold_RSRC&title=Query#TcruziEsmeraldo_scaffold_RSRC">data source</a>. 
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'braziliensis') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Sequence data for <i>Leishmania braziliensis</i> clone M2904 (MHOM/BR/75M2904) were downloaded from <a href="http://www.genedb.org/genedb/lbraziliensis/">GeneDB</a> (sequence and annotated features).<br>
Sequencing of <i>L. braziliensis</i> was conducted by <a href="http://www.sanger.ac.uk/Projects/L_braziliensis/">The Sanger Institute pathogen sequencing unit</a>.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'infantum') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Sequence data for <i>Leishmania infantum</i> clone JPCM5 (MCAN/ES/98/LLM-877) were downloaded from <a href="http://www.genedb.org/genedb/linfantum/">GeneDB</a> (sequence and annotated features).<br> 
Sequencing of <i>L. infantum</i> was conducted by <a href="http://www.sanger.ac.uk/Projects/L_infantum/">The Sanger Institute pathogen sequencing unit</a>. 
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'SD 75.1') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">   
Sequence from <i>Leishmania major strain SD 75.1</i> was generated by the Washington University Genome Center and has been provided <a href="http://genome.wustl.edu/data/data_use_policy">prepublication</a>. Permission should be obtained from Steve Beverley (beverley@borcim.wustl.edu) before publishing analyses of the sequence/open reading frames/genes on a genome scale. <br><br>Please read <a href="http://www.ncbi.nlm.nih.gov/pubmed/19741685">this paper for policies on pre-publication data sharing</a>. <br><br>For additional information on the <i>SD 75.1</i> assembly, please visit the <a href="showXmlDataContent.do?name=XmlQuestions.DataSources&datasets=Lmajor_SD_75.1"&title=Query#Lmajor_SD_75.1">data source</a>.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'major strain Friedlin') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Sequence data for <i>Leishmania major</i> Friedlin (reference strain - MHOM/IL/80/Friedlin, zymodeme MON-103) were downloaded from <a href="http://www.genedb.org/genedb/leish/">GeneDB</a> (sequence and annotated features).<br>
Sequencing of <i>L. major</i> was conducted by <a href="http://www.sanger.ac.uk/Projects/L_major/">The Sanger Institute pathogen sequencing unit</a>, <a href="http://www.sbri.org/">Seattle Biomedical Research Institute</a> and <a href="http://www.sanger.ac.uk/Projects/L_major/EUseqlabs.shtml">The European Leishmania major Friedlin Genome Sequencing Consortium</a>.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'mexicana') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Chromosome and unassigned contig sequences for <i>L.mexicana</i> were obtained from the Pathogen Sequencing Unit at the Wellcome Trust Sanger Institute.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'tarentolae') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
Chromosome sequence for <i>Leishmania tarentolae</i> is provided by  the CIHR Group on host pathogen interactions (Marc Ouellette, Jacques Corbeil, Barbara Papadopoulou, Michel J. Tremblay, Fr&#233;d&#233;ric Raymond, S&#233;bastien Boisvert from Universit&#233; Laval, and Martin Olivier from McGill University). The CIHR group plans on publishing the completed and annotated sequences in a peer-reviewed journal as soon as possible. Permission  should be obtained from Marc Ouellette before publishing analyses of the  sequence/open reading frames/genes on a chromosome or genome scale.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Crithidia') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
Sequence from <i>Crithidia fasciculata</i> was generated by the Washington University Genome Center and has been provided <a href="http://genome.wustl.edu/data/data_use_policy">prepublication</a>. Permission should be obtained from Steve Beverley (beverley@borcim.wustl.edu) before publishing analyses of the sequence/open reading frames/genes on a genome scale. <br><br>Please read <a href="http://www.ncbi.nlm.nih.gov/pubmed/19741685">this paper for policies on pre-publication data sharing</a>. <br><br>For additional information on the <i>Crithidia</i> assembly, please visit the <a href="showXmlDataContent.do?name=XmlQuestions.DataSources&datasets=Crithidia_fasciculata_9.1&title=Query#Crithidia_fasciculata_9.1">data source</a>.
  </c:set>
</c:when>
<c:when test="${!fn:contains(organism,'cruzi') && !fn:contains(organism,'tarentolae') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
Sequence data from GeneDB for <i>${organism}</i> chromosomes in EMBL format were generated at the Wellcome Trust Sanger Institute, TIGR/NRMC, and Stanford University. 
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'vivax') && projectId eq 'TriTrypDB'}">
  <c:set var="reference">
   Chromosome sequences for <i>T.vivax</i> obtained from the Pathogen Sequencing Unit at the Wellcome Trust Sanger Institute.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Entamoeba dispar') && projectId eq 'AmoebaDB'}">
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>E. dispar</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica HM-1:IMSS"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>E. histolytica</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica DS4"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica DS4</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica MS96"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica MS96</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica KU48"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica KU48</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica KU50"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica KU50</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica KU27"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica</i> KU27 obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test='${organism eq "Entamoeba histolytica HM-1:CA"}'>
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>Entamoeba histolytica HM-1:CA</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
<br>Users should acknowledge the J. Craig Venter Institute and the National Institute of Allergy and Infectious Diseases, National Institutes of Health, Department of Health and Human Services in any publications that result from use of this draft sequence assembly. Any investigaors who propose to publish analyses of the sequence/open reading frames/genes on a genome scale should contact the J. Craig Venter Institute for the use of pre-publication data. 
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Entamoeba invadens') && projectId eq 'AmoebaDB'}">
  <c:set var="reference">
 Whole genome shotgun sequence and annotations for <i>E. invadens</i> obtained from Lis Caler at the J. Craig Venter Institute (<a href="http://pathema.jcvi.org/cgi-bin/Entamoeba/PathemaHomePage.cgi"Target="_blank">JCVI</a>).
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Encephalitozoon cuniculi') && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
   Sequence and annotations from BioHealthBase for <i>Encephalitozoon cuniculi GB-M1</i> chromosomes in Genbank (sequence and annotated features) format. 
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Encephalitozoon intestinalis') && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
   Sequence and annotations from Patrick Keeling(pkeeling@interchange.ubc.ca)at Canadian Institute for Advanced Research, Evolutionary Biology Program, Department of Botany, University of British Columbia. Please note that the <i>E. intestinalis</i> genome sequence has not yet been published. You are welcome to browse this data and use information on individual genes for your research ... but using this site constitutes your implicit agreement to refrain from genome-wide analysis pending publication of the <i>E. intestinalis</i> genome. Please contact Patrick Keeling (pkeeling@interchange.ubc.ca) with any questions.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'Enterocytozoon bieneusi H348') && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
   Sequence and annotations from Genbank for Enterocytozoon bieneusi H348 contigs.
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'bayeri') && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
WGS assembly for Octosporea bayeri OER-3-3 was described by <a target="_blank" href="http://www.ncbi.nlm.nih.gov/pubmed/19807911">Corradi et. al.</a> and downloaded from Genbank (<a target="_blank" href="http://www.ncbi.nlm.nih.gov/nuccore/ACSZ00000000.1">O.bayeri Genbank Record</a>)
  </c:set>
</c:when>
<c:when test="${fn:contains(organism,'parisii') && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
Nematocida parisii strain ERTm1, whole genome shotgun sequence was generated by The Broad Institute Genome Sequencing Platform with Federal funds from the National Institute of Allergy and Infectious Diseases National under Contract No.: HHSN2722009000018C and obtained from GenBank (<a href="http://www.ncbi.nlm.nih.gov/nuccore/AEFF00000000">http://www.ncbi.nlm.nih.gov/nuccore/AEFF00000000</a>).
  </c:set>
</c:when>
<c:when test="${(fn:contains(organism,'Anncaliia') || fn:contains(organism,'Edhazardia') || fn:contains(organism,'Nosema') || fn:contains(organism,'Vittaforma')) && projectId eq 'MicrosporidiaDB'}">
  <c:set var="reference">
   Microsporidia sequences from the Genome Survey Sequences Database (GSS) division of Genbank  
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus clavatus NRRL 1"}'>
  <c:set var="reference">                                                  Aspergillus clavatus genomic annotations. Source: J. Craig Venter Institute via Broad Institute Aspergillus Comparative Site                                               
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus flavus"}'>
  <c:set var="reference">                                             Aspergillus flavus (NRRL 3357) genomic annotations. Source: J. Craig Venter Institute via Broad Institute Aspergillus Comparative Site                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus fumigatus Af293"}'>
  <c:set var="reference">                                     Aspergillus fumigatus (AF293) genomic annotations. Source: JCVI via AspGD.                              
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus niger"}'>
  <c:set var="reference">                                               Aspergillus niger (ATCC 1015) genomic annotations. Source: DOE JGI sequence via Broad Institute Aspergillus Comparative Site                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus terreus"}'>
  <c:set var="reference">                                             Aspergillus terreus (NIH 2624) genomic annotations. Source: Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Candida albicans SC5314"}'>
  <c:set var="reference">                                     Candida albicans (SC5314) genomic annotations. Source: Candida Genome Database.                              
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Coccidioides immitis H538.4"}'>
  <c:set var="reference">                                             Coccidioides immitis (H5384) genomic annotations. Source: Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Coccidioides immitis RS"}'>
  <c:set var="reference">                                             Coccidioides immitis (RS) genomic annotations. Source: Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Cryptococcus neoformans var. grubii H99"}'>
  <c:set var="reference">                                             Cryptococcus neoformans var. grubii (H99) genomic annotations. Source: The Broad Institute and Duke University.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Fusarium graminearum species complex"}'>
  <c:set var="reference">                                             Fusarium graminearium (PH-1) genomic annotations. Source: Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Fusarium oxysporum"}'>
  <c:set var="reference">                                             Fusarium oxysporum f. sp. lycopersici (4287) genomic annotations. Source: Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Magnaporthe oryzae 70-15"}'>
  <c:set var="reference">                                                          Magnaporthe oryzae (70-15) genomic sequence. Source: Broad Institute                                               
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Neurospora crassa OR74A"}'>
  <c:set var="reference">                                        Neurospora crassa (OR74A) genomic annotations. Source: Broad Institute.                                   
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Saccharomyces cerevisiae S288c"}'>
  <c:set var="reference">Sequence and annotations from SGD for <i>Saccharomyces cerevisiae S288C</i>.
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Aspergillus nidulans FGSC A4"}'>
  <c:set var="reference">                                             Aspergillus nidulans (A4) genomic annotations. Source: The Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Puccinia graminis f. sp. tritici CRL 75-36-700-3"}'>
  <c:set var="reference">                                             Puccinia graminis genomic annotations. Source: The Broad Institute.                                        
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Rhizopus oryzae RA 99-880"}'>
  <c:set var="reference">TODO
  </c:set>
</c:when>

<c:when test='${projectId eq "FungiDB" && organism eq "Gibberella moniliformis"}'>
  <c:set var="reference">TODO
  </c:set>
</c:when>




<c:otherwise>
    <c:set var="reference">
  <b>ERROR: can't find attribution information for organism "${organism}",
     sequence "${id}"</b>
    </c:set>
</c:otherwise>

</c:choose>



<site:panel 
    displayName="Genome Sequencing and Annotation by:"
    content="${reference}" />
<br>

<%------------------------------------------------------------------%>
</c:otherwise>
</c:choose> <%/* if wdkRecord.attributes['organism'].value */%>

<script type='text/javascript' src='/gbrowse/apiGBrowsePopups.js'></script>
<script type='text/javascript' src='/gbrowse/wz_tooltip.js'></script>

<site:footer/>
