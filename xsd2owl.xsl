<?xml version='1.0' encoding='utf-8'?>

<!--
  (Partial)  transformation of an XSD schema into an OWL-DL TBox
  
  (c) 2015 Université de Genève, Gilles Falquet
      
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY owl "http://www.w3.org/2002/07/owl#">
<!ENTITY gml "http://www.w3.org/2002/07/owl#">
<!ENTITY core "http://cui.unige.ch/isi/ontologies/citygml/core.owl#">
]>


<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns:owl="http://www.w3.org/2002/07/owl#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
   xmlns:gml="http://cui.unige.ch/isi/ontologies/citygml/gml.owl#"
   xmlns:core="http://cui.unige.ch/isi/ontologies/citygml/gml.owl#"
  >


<xsl:template match='xs:schema'>

<xsl:text>
  
</xsl:text>
  
<rdf:RDF xmlns="http://cui.unige.ch/isi/ontologies/citygml/citygml.owl#"
    xml:base="http://cui.unige.ch/isi/ontologies/citygml/citygml.owl"
    xmlns:owl2xml="http://www.w3.org/2006/12/owl2-xml#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:gml="http://cui.unige.ch/isi/ontologies/citygml/gml.owl#">
<owl:Ontology rdf:about=""/>
    
<xsl:apply-templates select="xs:complexType"/>
<xsl:apply-templates select="xs:simpleType"/>
<xsl:apply-templates select="xs:element[@substitutionGroup]"/>

</rdf:RDF>
  
</xsl:template>

<xsl:template match="xs:complexType">
  <xsl:text>

  </xsl:text>
<owl:Class>
    <!-- Content: template -->
    <xsl:attribute name="rdf:about"> <!-- was about" -->
      <xsl:value-of select="@name" />
    </xsl:attribute>
<xsl:text>

</xsl:text> <!-- LINE FEED -->
  <xsl:variable name="txt">
	<xsl:value-of select="@name" />
  </xsl:variable>
  
  
  <xsl:if test="contains($txt, 'Property')">
	<xsl:comment>association</xsl:comment>
  </xsl:if>
  <xsl:apply-templates select="./xs:annotation/xs:documentation"></xsl:apply-templates>
  <xsl:apply-templates select="./xs:complexContent/xs:extension"/>
  <xsl:apply-templates select="./xs:complexContent/xs:extension/xs:sequence/xs:element[@name]"/>
  <xsl:apply-templates select="./xs:complexContent/*/xs:sequence/xs:element[@ref]"/>
  
</owl:Class>
  
  <!-- generate datatype properties -->
  <xsl:for-each select="./xs:complexContent/xs:extension/xs:sequence/xs:element[starts-with(@type,'xs:')]">
    <owl:DatatypeProperty>
      <xsl:attribute name="rdf:about"><xsl:value-of select="@name"/></xsl:attribute> <!-- was rdf:about -->
    </owl:DatatypeProperty>   
  </xsl:for-each>
</xsl:template>

<xsl:template match="xs:documentation">
   <rdfs:comment><xsl:value-of select="."/>
   </rdfs:comment>

</xsl:template>
<xsl:template match="xs:simpleType">
   <xsl:text>
   </xsl:text> <!-- LINE FEED -->
  <owl:Class>
    <xsl:attribute name="rdf:about"> <!-- about -->
      <xsl:value-of select="@name" />
    </xsl:attribute>
    <xsl:comment>simple class</xsl:comment>
    
   </owl:Class>
</xsl:template>


<xsl:template match="xs:extension">
   <rdfs:subClassOf>
     <xsl:attribute name="rdf:resource"><xsl:value-of select="@base"/></xsl:attribute>     
   </rdfs:subClassOf>
</xsl:template>

<xsl:template match="/xs:schema/xs:element">
      <owl:ObjectProperty>
         <xsl:attribute name="rdf:about">  <!-- about -->
            <xsl:value-of select="@name"/>
         </xsl:attribute>
         
         <xsl:if test="@substitutionGroup != ''">
            <rdfs:subPropertyOf>
              <xsl:attribute name="rdf:resource"> <xsl:value-of select="@substitutionGroup"/>
              </xsl:attribute>
            </rdfs:subPropertyOf> 
         </xsl:if>
         
         <rdfs:range>
            <xsl:attribute name="rdf:resource"> <xsl:value-of select="@type"/>
            </xsl:attribute>
         </rdfs:range>
      

      </owl:ObjectProperty> 
        
</xsl:template>
  
<xsl:template match="xs:complexType//xs:element[@name]">
  <xsl:text>
    
  </xsl:text>
  <rdfs:subClassOf>
    <owl:Restriction>
      <owl:onProperty>
        <xsl:attribute name="rdf:resource"><xsl:value-of select="@name"/></xsl:attribute>
      </owl:onProperty>
      <owl:allValuesFrom>
        <xsl:attribute name="rdf:resource"><xsl:value-of select="@type"/></xsl:attribute>
      </owl:allValuesFrom> 
    </owl:Restriction>
  </rdfs:subClassOf>
  
  <xsl:if test="not(@minOccurs='0')"> <!--- mandatory field -->
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="@name"/></xsl:attribute>
        </owl:onProperty>
        <owl:someValuesFrom>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="@type"/></xsl:attribute>
        </owl:someValuesFrom> 
      </owl:Restriction>
    </rdfs:subClassOf>
  </xsl:if>
</xsl:template>
  
<xsl:template match="xs:complexType//xs:element[@ref]">
    <xsl:text>
      
    </xsl:text>
    <xsl:variable name="refElt">
       <xsl:value-of select="@ref"/>
    </xsl:variable>
    <xsl:variable name="refEltType">
       <xsl:value-of select="//xs:element[@name=$refElt]/@type"/>
    </xsl:variable>
    <rdfs:subClassOf>
      <owl:Restriction>
        <owl:onProperty>
          <xsl:attribute name="rdf:resource">
             <xsl:value-of select="@ref"/>
          </xsl:attribute>
        </owl:onProperty>
        <owl:allValuesFrom>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="$refEltType"/></xsl:attribute>
        </owl:allValuesFrom> 
      </owl:Restriction>
    </rdfs:subClassOf>
    
    <xsl:if test="not(@minOccurs='0')"> <!--- mandatory field -->
      <rdfs:subClassOf>
        <owl:Restriction>
          <owl:onProperty>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="@ref"/></xsl:attribute>
          </owl:onProperty>
          <owl:someValuesFrom>
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$refEltType"/></xsl:attribute>
          </owl:someValuesFrom> 
        </owl:Restriction>
      </rdfs:subClassOf>
    </xsl:if>
</xsl:template>
  
  
  

</xsl:stylesheet>
