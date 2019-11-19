import React, { FunctionComponent, ReactNode, useCallback, useEffect, useMemo, useState } from 'react';
import { connect } from 'react-redux';

import { get, memoize } from 'lodash';

import { ErrorBoundary } from 'wdk-client/Controllers';
import { RootState } from 'wdk-client/Core/State/Types';
import { CategoryTreeNode } from 'wdk-client/Utils/CategoryUtils';
import { arrayOf, decode, string } from 'wdk-client/Utils/Json';

import { Footer } from 'ebrc-client/components/homepage/Footer';
import { Header, HeaderMenuItem } from 'ebrc-client/components/homepage/Header';
import { Main } from 'ebrc-client/components/homepage/Main';
import { NewsPane } from 'ebrc-client/components/homepage/NewsPane';
import { SearchPane, SearchCheckboxTree } from 'ebrc-client/components/homepage/SearchPane';
import { Twitter, YouTube, Facebook } from 'ebrc-client/components/homepage/SocialMediaIcons';
import { combineClassNames } from 'ebrc-client/components/homepage/Utils';

import { makeVpdbClassNameHelper } from './Utils';

import { projectId } from '../../config';

import './VEuPathDBHomePage.scss';

const vpdbCx = makeVpdbClassNameHelper('');

type StateProps = {
  searchTree?: CategoryTreeNode,
  twitterUrl?: string,
  facebookUrl?: string,
  youtubeUrl?: string
}

type Props = StateProps;

const GENE_ITEM_ID = 'category:transcript-record-classes-transcript-record-class';
const SEARCH_TERM_SESSION_KEY = 'homepage-header-search-term';
const EXPANDED_BRANCHES_SESSION_KEY = 'homepage-header-expanded-branch-ids';

const VEuPathDBHomePageView: FunctionComponent<Props> = props => {
  const [ siteSearchSuggestions, setSiteSearchSuggestions ] = useState<string[] | undefined>(undefined);
  const [ additionalSuggestions, setAdditionalSuggestions ] = useState<{ key: string, display: ReactNode }[]>([]);
  const [ headerExpanded, setHeaderExpanded ] = useState(true);
  const [ searchTerm, setSearchTerm ] = useSessionBackedState(
    '', 
    SEARCH_TERM_SESSION_KEY, 
    encodeSearchTerm, 
    parseSearchTerm
  );

  const [ expandedBranches, setExpandedBranches ] = useSessionBackedState(
    [ GENE_ITEM_ID ], 
    EXPANDED_BRANCHES_SESSION_KEY, 
    encodeExpandedBranches, 
    parseExpandedBranches
  );

  const projectId = useProjectId();
  const headerMenuItems = useHeaderMenuItems(
    props.searchTree, 
    searchTerm, 
    expandedBranches, 
    setSearchTerm, 
    setExpandedBranches,
    props.twitterUrl,
    props.facebookUrl,
    props.youtubeUrl,
  );

  const updateHeaderExpanded = useCallback(() => {
    // FIXME - find a better way to update the header height - this resizing is "jerky" when 
    // the scroll bar is left near the scroll threshold
    setHeaderExpanded(document.body.scrollTop <= 80 && document.documentElement.scrollTop <= 80);
  }, []);

  useEffect(() => {
    window.addEventListener('scroll', updateHeaderExpanded, { passive: true });
    window.addEventListener('touch', updateHeaderExpanded, { passive: true });
    window.addEventListener('wheel', updateHeaderExpanded, { passive: true });

    return () => {
      window.removeEventListener('scroll', updateHeaderExpanded);
      window.removeEventListener('touch', updateHeaderExpanded);
      window.removeEventListener('wheel', updateHeaderExpanded);
    };
  }, [ updateHeaderExpanded ]);

  const preloadedSuggestions = useMemo(
    () => [
      'protein',
      'protein motifs',
      'proteomics',
      'protozoa',
    ],
    []
  );

  const loadSuggestions = useCallback((searchTerm: string) => {
    if (searchTerm) {
      setSiteSearchSuggestions(
        [
          searchTerm,
          ...preloadedSuggestions
        ].sort()
      );
    } else {
      setSiteSearchSuggestions(undefined);
    }
  }, []);

  const rootContainerClassName = combineClassNames(
    vpdbCx('RootContainer', headerExpanded ? 'header-expanded' : 'header-collapsed'), 
    projectId
  );
  const headerClassName = vpdbCx('Header', headerExpanded ? 'expanded' : 'collapsed');
  const searchPaneClassName = combineClassNames(vpdbCx('SearchPane'), vpdbCx('BgWash'), vpdbCx('BdDark'));
  const mainClassName = vpdbCx('Main');
  const newsPaneClassName = vpdbCx('NewsPane');
  const footerClassName = vpdbCx('Footer'); 

  return (
    <div className={rootContainerClassName}>
      <ErrorBoundary>
        <Header 
          // FIXME: use project logos for component site branding 
          branding={projectId}
          menuItems={headerMenuItems} 
          containerClassName={headerClassName} 
          loadSuggestions={loadSuggestions}
          siteSearchSuggestions={siteSearchSuggestions}
          additionalSuggestions={additionalSuggestions}
        />
      </ErrorBoundary>
      <ErrorBoundary>
        <SearchPane 
          containerClassName={searchPaneClassName} 
          searchTree={props.searchTree}
        />
      </ErrorBoundary>
      <Main containerClassName={mainClassName}>
        {props.children}
      </Main>
      <ErrorBoundary>
        <NewsPane containerClassName={newsPaneClassName} />
      </ErrorBoundary>
      <ErrorBoundary>
        <Footer containerClassName={footerClassName} />
      </ErrorBoundary>
    </div>
  );
}

type Encoder<T> = (t: T) => string;
type Parser<T> = (s: string) => T;

const encodeSearchTerm = (s: string) => s;
const parseSearchTerm = encodeSearchTerm;

const encodeExpandedBranches = JSON.stringify;
const parseExpandedBranches = memoize((s: string) => decode(
  arrayOf(string),
  s
));

function useSessionBackedState<T>(
  defaultValue: T,
  key: string,
  encode: Encoder<T>,
  parse: Parser<T>,
): [ T, (newState: T) => void ] {
  let initialValue = defaultValue;

  try {
    const storedStringValue = window.sessionStorage.getItem(key);

    if (storedStringValue !== null) {
      initialValue = parse(storedStringValue);
    }
  } catch (e) {
    console.warn(
      `Failed attempt to retrieve state value at session key ${key}: ${e}; falling back to component state`
    );
  }

  const [ state, setState ] = useState(initialValue);

  const setSessionBackedState = useCallback((newValue: T) => {
    try {
      window.sessionStorage.setItem(key, encode(newValue));
    } catch {
      console.warn(`Failed attempt to persist state value ${newValue} at session key ${key}; falling back to component state`);
    }
    setState(newValue);
  }, [ encode ]);

  return [ state, setSessionBackedState ];
};

const PlasmoDB = 'PlasmoDB';
const TriTrypDB = 'TriTrypDB';
const CryptoDB = 'CryptoDB';
const ToxoDB = 'ToxoDB';
const FungiDB  = 'FungiDB';
const EuPathDB = 'EuPathDB';

const useProjectId = (): string => {
  // FIXME: Pull this from global data
  return projectId;
};

type HeaderMenuItemEntry = HeaderMenuItem<{
  include?: string[],
  exclude?: string[]
}>;

const useHeaderMenuItems = (
  searchTree: CategoryTreeNode | undefined, 
  searchTerm: string, 
  expandedBranches: string[],
  setSearchTerm: (newSearchTerm: string) => void,
  setExpandedBranches: (newExpandedBranches: string[]) => void,
  twitterUrl?: string,
  facebookUrl?: string,
  youtubeUrl?: string
): HeaderMenuItem[] => {
  const projectId = useProjectId();

  const menuItemEntries: HeaderMenuItemEntry[] = [
    {
      key: 'searchContainer',
      display: 'Searches',
      type: 'subMenu',
      items: [
        {
          key: 'searches',
          display: (
            <SearchCheckboxTree 
              searchTree={searchTree} 
              searchTerm={searchTerm}
              expandedBranches={expandedBranches}
              setSearchTerm={setSearchTerm}
              setExpandedBranches={setExpandedBranches}
            />
          ),
          type: 'custom'
        }
      ]
    },
    {
      key: 'tools',
      display: 'Tools',
      type: 'subMenu',
      items: [
        {
          key: 'blast',
          display: 'BLAST',
          type: 'reactRoute',
          url: '/search/transcript/UnifiedBlast'
        },
        {
          key: 'analysis',
          display: 'Results analysis',
          type: 'webAppRoute',
          url: '/analysisTools.jsp'
        },
        {
          key: 'srt',
          display: 'Sequence Retrieval',
          type: 'webAppRoute',
          url: '/srt.jsp'
        },
        {
          key: 'galaxy',
          display: 'Analyze my experiment',
          type: 'reactRoute',
          url: '/galaxy-orientation'
        },
        {
          key: 'companion',
          display: 'Companion',
          type: 'externalLink',
          tooltip: 'Annotate your sequence and determine orthology, phylogeny & synteny',
          url: 'http://companion.gla.ac.uk/',
          target: '_blank',
          metadata: {
            exclude: [ FungiDB ]
          }
        },
        {
          key: 'companion--fungi',
          display: 'Companion',
          type: 'externalLink',
          tooltip: 'Annotate your sequence and determine orthology, phylogeny & synteny',
          url: 'http://fungicompanion.gla.ac.uk/',
          target: '_blank',
          metadata: {
            include: [ FungiDB ]
          }
        },
        {
          key: 'LeishGEdit',
          display: 'LeishGEdit',
          tooltip: 'Your online resource for CRISPR Cas9 T7 RNA Polymerase gene editing in kinetoplastids',
          type: 'externalLink',
          url: 'http://www.leishgedit.net',
          target: '_blank',
          metadata: {
            include: [ TriTrypDB ]
          }
        },
        {
          key: 'EuPaGDT',
          display: 'EuPaGDT',
          type: 'externalLink',
          tooltip: 'Eukaryotic Pathogen CRISPR guide RNA/DNA Design Tool',
          url: 'http://grna.ctegd.uga.edu',
          target: '_blank'
        },
        {
          key: 'pubcrawler',
          display: 'PubMed and Entrez',
          type: 'externalLink',
          url: `/pubcrawler/${projectId}`
        },
        {
          key: 'jbrowse',
          display: 'Genome Browser',
          type: 'externalLink',
          url: '/a/jbrowse.jsp?data=/a/service/jbrowse/tracks/default&tracks=gene',
          metadata: {
            exclude: [ EuPathDB ]
          }
        },
        {
          key: 'plasmoap',
          display: 'PlasmoAP',
          type: 'webAppRoute',
          url: '/plasmoap.jsp',
          metadata: {
            include: [ PlasmoDB ]
          }
        },
        {
          key: 'pats',
          display: 'PATS',
          type: 'externalLink',
          url: 'http://modlabcadd.ethz.ch/software/pats/',
          target: '_blank',
          metadata: {
            include: [ PlasmoDB ]
          }
        },
        {
          key: 'ancillary-genome-browser',
          display: 'Ancillary Genome Browser',
          type: 'externalLink',
          url: 'http://ancillary.toxodb.org',
          target: '_blank',
          metadata: {
            include: [ ToxoDB ]
          }
        },
        {
          key: 'webservices',
          display: 'Searches via Web Services',
          type: 'externalLink',
          url: '/documents/WebServicesURLBuilderHELPPAGE.pdf'
        }
      ]
    },
    {
      key: 'workspace',
      display: 'Workspace',
      type: 'subMenu',
      items: [
        {
          key: 'search-strategies',
          display: 'My search strategies',
          type: 'reactRoute',
          url: '/workspace/strategies'
        },
        {
          key: 'user-data-sets',
          display: 'My data sets',
          type: 'reactRoute',
          url: '/workspace/datasets'
        },
        {
          key: 'basket',
          display: 'My basket',
          type: 'reactRoute',
          url: '/workspace/basket'
        },
        {
          key: 'galaxy-analyses',
          display: 'My Galaxy analyses',
          type: 'reactRoute',
          url: '/galaxy-orientation'
        }
      ]
    },
    {
      key: 'data',
      display: 'Data',
      type: 'subMenu',
      items: [
        {
          key: 'datasets',
          display: 'Data sets',
          type: 'reactRoute',
          url: '/search/dataset/AllDatasets/result'
        },
        {
          key: 'analysis-methods',
          display: 'Methods',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.Methods.jsp'
        },
        {
          key: 'annotation-sops',
          display: <>SOPs for <i>C.parvum</i> Annotation</>,
          type: 'externalLink',
          url: 'http://cryptodb.org/static/SOP/',
          metadata: {
            include: [ CryptoDB ],
          }
        },
        {
          key: 'genomes-and-data-types',
          display: 'Organisms - Data type summary',
          tooltip: `Table summarizing all the genomes and their different data types available in ${projectId}`,
          type: 'reactRoute',
          url: '/search/organism/GenomeDataTypes'
        },
        {
          key: 'gene-metrics',
          display: 'Organisms - Gene metrics',
          tooltip: 'Table summarizing gene counts for all the available genomes, and evidence supporting them',
          type: 'reactRoute',
          url: '/search/organism/GeneMetrics'
        },
        {
          key: 'data-files-eupathdb',
          display: 'Download data files',
          type: 'externalLink',
          url: '/common/downloads',
          metadata: {
            exclude: [ EuPathDB ]
          }
        }
      ]
    },
    {
      key: 'community',
      display: 'Community',
      type: 'subMenu',
      items: [
        {
          key: 'twitter',
          display: (
            <a 
              className={vpdbCx('CommunitySocialMediaLink')} 
              href={twitterUrl}
              target="_blank"
            >
              <Twitter />
              Follow us on Twitter!
            </a>
          ),
          type: 'custom'
        },
        {
          key: 'facebook',
          display: (
            <a 
              className={vpdbCx('CommunitySocialMediaLink')} 
              href={facebookUrl}
              target="_blank"
            >
              <Facebook />
              Follow us on Facebook!
            </a>
          ),
          type: 'custom'
        },
        {
          key: 'youtube',
          display: (
            <a 
              className={vpdbCx('CommunitySocialMediaLink', 'wide')} 
              href={youtubeUrl}
              target="_blank"
            >
              <YouTube />
              Follow us on YouTube!
            </a>
          ),
          type: 'custom'
        },
        {
          key: 'comments',
          display: `Genes with comments from the ${projectId} community`,
          tooltip: 'Add your comments to your gene of interest: start at the gene page',
          type: 'reactRoute',
          url: '/search/gene/GenesWithUserComments',
          metadata: {
            exclude: [ EuPathDB ]
          }
        },
        {
          key: 'public-strategies',
          display: 'Public strategies',
          type: 'reactRoute',
          url: '/workspace/strategies/public'
        },
        {
          key: 'community-download',
          display: 'Community files',
          type: 'reactRoute',
          url: '/search/file/UserFileUploads',
          metadata: {
            exclude: [ EuPathDB ]
          }
        },
        {
          key: 'release-policy',
          display: 'VEuPathDB data submission & release policies',
          type: 'externalLink',
          url: '/EuPathDB_datasubm_SOP.pdf'
        },
        {
          key: 'related-sites',
          display: 'Related sites',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.ExternalLinks.jsp'
        },
        {
          key: 'mahpic-data',
          display: 'MaHPIC',
          type: 'webAppRoute',
          tooltip: 'Access MaHPIC Data',
          url: '/mahpic.jsp',
          metadata: {
            include: [ PlasmoDB ]
          }
        }
      ]
    },
    {
      key: 'about',
      display: 'About',
      type: 'subMenu',
      items: [
        {
          key: 'what-is',
          display: `What is ${projectId}?`,
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp'
        },
        {
          key: 'eupathdb-publications',
          display: 'Publications on VEuPathDB sites',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.EuPathDBPubs.jsp'
        },
        {
          key: 'submitting-divider',
          display: (
            <SubmenuDivider>
              Submitting data to {projectId}
            </SubmenuDivider>
          ),
          type: 'custom'
        },
        {
          key: 'submission-instructions',
          display: 'How to submit data to us',
          type: 'webAppRoute',
          url: '/dataSubmission.jsp'
        },
        {
          key: 'submission-policy',
          display: 'VEuPathDB data submission & release policies',
          type: 'externalLink',
          url: '/EuPathDB_datasubm_SOP.pdf'
        },
        {
          key: 'usage-and-citations-divider',
          display: (
            <SubmenuDivider>
              Usage and citation
            </SubmenuDivider>
          ),
          type: 'custom'
        },
        {
          key: 'cite-us',
          display: 'How to cite us',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp#citing'
        },
        {
          key: 'cite-data-provide',
          display: 'Citing data providers',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp#citingproviders'
        },
        {
          key: 'citations',
          display: 'Publications that use our resources',
          type: 'externalLink',
          url: 'http://scholar.google.com/scholar?as_q=&num=10&as_epq=&as_oq=OrthoMCL+PlasmoDB+ToxoDB+CryptoDB+TrichDB+GiardiaDB+TriTrypDB+AmoebaDB+MicrosporidiaDB+%22FungiDB%22+PiroplasmaDB+ApiDB+EuPathDB&as_eq=encrypt+cryptography+hymenoptera&as_occt=any&as_sauthors=&as_publication=&as_ylo=&as_yhi=&as_sdt=1.&as_sdtp=on&as_sdtf=&as_sdts=39&btnG=Search+Scholar&hl=en'
        },
        {
          key: 'data-access-policy',
          display: 'Data Access Policy',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp#use'
        },
        {
          key: 'website-privacy-policy',
          display: 'Website privacy policy',
          type: 'externalLink',
          url: '/documents/EuPathDB_Website_Privacy_Policy.shtml'
        },
        {
          key: 'who-are-we-divider',
          display: (
            <SubmenuDivider>
              Who are we?
            </SubmenuDivider>
          ),
          type: 'custom'
        },
        {
          key: 'scientific-working-group',
          display: 'Scientific working group',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.AboutAll.jsp#swg'
        },
        {
          key: 'scientific-advisory-team',
          display: 'Scientific advisory team',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp#advisors'
        },
        {
          key: 'acknowledgement',
          display: 'Acknowledgements',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.AboutAll.jsp#acks'
        },
        {
          key: 'funding',
          display: 'Funding',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.About.jsp#funding'
        },
        {
          key: 'brochure',
          display: 'EuPathDB Brochure',
          type: 'externalLink',
          url: 'http://eupathdb.org/tutorials/eupathdbFlyer.pdf'
        },
        {
          key: 'brochure-chinese',
          display: 'EuPathDB brochure in Chinese',
          type: 'externalLink',
          url: 'http://eupathdb.org/tutorials/eupathdbFlyer_Chinese.pdf'
        },
        {
          key: 'technical-divider',
          display: (
            <SubmenuDivider>
              Technical
            </SubmenuDivider>
          ),
          type: 'custom'
        },        
        {
          key: 'accessibility-vpat',
          display: 'Accessibility VPAT',
          type: 'externalLink',
          url: '/documents/EuPathDB_Section_508.pdf'
        },
        {
          key: 'infrastructure',
          display: 'EuPathDB Infrastructure',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.Infrastructure.jsp'
        },
        {
          key: 'usage-statistics',
          display: 'Website Usage Statistics',
          type: 'externalLink',
          url: '/awstats/awstats.pl'
        }
      ]
    },
    {
      key: 'help',
      display: 'Help',
      type: 'subMenu',
      items: [
        {
          key: 'reset-session',
          display: `Reset ${projectId} Session`,
          tooltip: 'Login first to keep your work',
          type: 'webAppRoute',
          url: '/resetSession.jsp',
        },
        {
          key: 'youtube-tutorials',
          display: 'YouTube tutorials',
          type: 'externalLink',
          url: 'http://www.youtube.com/user/EuPathDB/videos?sort=dd&flow=list&view=1'
        },
        {
          key: 'web-tutorials',
          display: 'Web tutorials',
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.Tutorials.jsp'
        },
        {
          key: 'eupathdb-workshop',
          display: 'EuPathDB workshop',
          type: 'externalLink',
          url: 'http://workshop.eupathdb.org/current/'
        },
        {
          key: 'workshop-exercises',
          display: 'Exercises from workshop',
          type: 'externalLink',
          url: 'http://workshop.eupathdb.org/current/index.php?page=schedule'
        },
        {
          key: 'ncbi-glossary',
          display: `NCBI's glossary of terms`,
          type: 'externalLink',
          url: 'http://www.genome.gov/Glossary/'
        },
        {
          key: 'our-glossary',
          display: `Our glossary`,
          type: 'webAppRoute',
          url: '/wdkCustomization/jsp/questions/XmlQuestions.Glossary.jsp'
        },
        {
          key: 'contact-us',
          display: 'Contact us',
          type: 'reactRoute',
          url: '/contact-us',
          target: '_blank'
        }
      ]
    }
  ];

  return menuItemEntries.flatMap(
    menuItemEntry => filterMenuItemEntry(menuItemEntry, projectId)
  );
};

const SubmenuDivider: React.FunctionComponent = ({ children }) => 
  <div className={vpdbCx('SubmenuDivider')}>
    {children}
  </div>;

const filterMenuItemEntry = (
  menuItemEntry: HeaderMenuItemEntry, 
  projectId: string
): HeaderMenuItemEntry[] => 
  (
    menuItemEntry.metadata && 
    (
      (
        menuItemEntry.metadata.include && !menuItemEntry.metadata.include.includes(projectId)
      ) ||
      ( 
        menuItemEntry.metadata.exclude && menuItemEntry.metadata.exclude.includes(projectId)        
      )
    )
  ) 
    ? []
    : menuItemEntry.type !== 'subMenu'
    ? [ menuItemEntry  ]
    : [
        {
          ...menuItemEntry,
          items: menuItemEntry.items.flatMap(
            menuItemEntry => filterMenuItemEntry(menuItemEntry, projectId)
          )
        }
      ];

// FIXME: Use a hook instead of "connect" to provide the global data
const mapStateToProps = (state: RootState) => ({
  // FIXME: This is not typesafe.
  searchTree: get(state.globalData, 'searchTree') as CategoryTreeNode,
  twitterUrl: state.globalData.siteConfig && state.globalData.siteConfig.twitterUrl,
  facebookUrl: state.globalData.siteConfig && state.globalData.siteConfig.facebookUrl,
  youtubeUrl: state.globalData.siteConfig && state.globalData.siteConfig.youtubeUrl,
});

export const VEuPathDBHomePage = connect(mapStateToProps)(VEuPathDBHomePageView);
