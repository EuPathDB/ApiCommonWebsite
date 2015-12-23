package org.apidb.apicommon.model;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apidb.apicommon.model.ontology.OBOentity;
import org.apidb.apicommon.model.ontology.OWLReasonerRunner;
import org.apidb.apicommon.model.ontology.OntologyManipulator;
import org.gusdb.fgputil.functional.TreeNode;
import org.gusdb.fgputil.runtime.GusHome;
import org.gusdb.wdk.model.WdkModelException;
import org.gusdb.wdk.model.ontology.JavaOntologyPlugin;
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLAnnotation;
import org.semanticweb.owlapi.model.OWLAnnotationProperty;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.reasoner.Node;
import org.semanticweb.owlapi.reasoner.OWLReasoner;

public class EuPathDbOwlParserWdkPlugin implements JavaOntologyPlugin {

  public static final String orderAnnotPropStr = "http://purl.obolibrary.org/obo/EUPATH_0000274"; // Display order annotation property IRI                                                                                        
  public static final String reasonerName = "hermit";
  public static final String owlFilePathParam = "owlFilePath";

  @Override
  public TreeNode<Map<String, List<String>>> getTree(Map<String, String> parameters, String ontologyName) throws WdkModelException {
 
    String inputOwlFile = GusHome.getGusHome() + "/" + parameters.get(owlFilePathParam);
 
    // load OWL format ontology
    OWLOntologyManager manager = OWLManager.createOWLOntologyManager();
    OWLOntology ont = OntologyManipulator.load(inputOwlFile, manager);
    OWLDataFactory df = manager.getOWLDataFactory();

    // reasoning the ontology
    OWLReasoner reasoner = OWLReasonerRunner.runReasoner(manager, ont, reasonerName);

    // get root node
    Node<OWLClass> topNode = reasoner.getTopClassNode();
    OWLClass owlClass = topNode.getEntities().iterator().next(); // get first one
    TreeNode <Map<String, List<String>>> tree = new TreeNode<Map<String, List<String>>>(convertToMap(ont, df, owlClass));
    
    // build tree
    build(topNode, reasoner, ont, df, df.getOWLAnnotationProperty(IRI.create(orderAnnotPropStr)), tree);
    return tree;
  }
  
  public static void build(Node<OWLClass> parent, OWLReasoner reasoner, OWLOntology ont, OWLDataFactory df,
      OWLAnnotationProperty orderAnnotProp, TreeNode<Map<String, List<String>>> tree) throws WdkModelException {
    // We don't want to print out the bottom node (containing owl:Nothing
    // and unsatisfiable classes) because this would appear as a leaf node
    // everywhere
    if (parent.isBottomNode()) return;

    // get children of a parent node and sort children based on their display order
    List<TermNode> childList = new ArrayList<TermNode>();

    for (Node<OWLClass> child : reasoner.getSubClasses(parent.getRepresentativeElement(), true)) {

      if (child.getSize() > 1)
        throw new WdkModelException("Node has multiple entities"); // how can we tell user which node?
 
      for (OWLClass owlClass : child.getEntities()) {
        String orderAnnotPropVal = OBOentity.getStringAnnotProps(owlClass, df, ont, orderAnnotProp);
 
        if (orderAnnotPropVal.length() == 0) throw new WdkModelException("No order annotation provided in node");  // how to show user which node?
        TermNode t = new TermNode(child, Integer.parseInt(orderAnnotPropVal));
        if (t != null) childList.add(t);
      }
    }

    Collections.sort(childList);
    
    for (TermNode childTermNode : childList) {
      OWLClass owlClass = childTermNode.getNode().getEntities().iterator().next();  // only get first
      Map<String, List<String>> content = convertToMap(ont, df, owlClass);
      if (content != null) {
        TreeNode<Map<String, List<String>>> t = new TreeNode<Map<String, List<String>>>(content);
        tree.addChildNode(t);
      }

     build(childTermNode.getNode(), reasoner, ont, df, orderAnnotProp, tree);
    }
  }
        
  private static Map<String, List<String>> convertToMap(OWLOntology ont, OWLDataFactory df, OWLClass cls) throws WdkModelException {
    Map<String, List<String>> node = new HashMap<String, List<String>>();
    Set<OWLAnnotation> annotList = cls.getAnnotations(ont);

    if (annotList.size() == 0)  return null;

    for (OWLAnnotation currAnnot : annotList) {
      OWLAnnotationProperty annotProp = currAnnot.getProperty();
      String annotPropLabel = OBOentity.getLabel(annotProp, ont, df);
      if (node.containsKey(annotPropLabel)) continue;   // apparently the class can return redundant annotation properties, with identical values.
      ArrayList<String> annotValues = OBOentity.getStringArrayAnnotProps(cls, df, ont, annotProp);
      if (annotValues.size() > 0 ) node.put(annotPropLabel, annotValues);
    }

    return node;
  }

  @Override
  public void validateParameters(Map<String, String> parameters, String ontologyName)
      throws WdkModelException {

    String owlFileName =  GusHome.getGusHome() + "/" +
        parameters.get(owlFilePathParam);
    if (!(new File(owlFileName).exists()))
      throw new WdkModelException("For ontology '" + ontologyName + "', OWL file does not exist: " + owlFileName);
  }

  public static class TermNode implements Comparable<TermNode>{
    private Node<OWLClass> node;
    private Integer order;
    
    public TermNode (Node<OWLClass> node, Integer order) {
        this.node = node;
        this.order = order;
    }
    
    public Node<OWLClass> getNode () {
        return node;
    }
    
    public Integer getOrder() {
        return order;
    }
    
    public int compareTo(TermNode term)
    {
        return getOrder().compareTo(term.getOrder());
    }
}



}
