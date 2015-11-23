Converting the CityGML XML Schemas to OWL
=========================================

This is a basic XML schema to OWL converter.

The conversion principles are as follows:


## xs:complexType and xs:simpleType
Each complex or simple type translates to an OWL class

## Extension
If an xs:complexType with name = T contains a <complexContent> element with an <extension base = B> element then generate a subclass axiom  T subClassOf B.

## Substitution group
For an xs:element with name = E and substitutionGroup = G, generate a subproperty  axiom E subPropertyOf G.

## Elements in a complexType
Elements that belong to a complexType definition translate to property restrictions. For each <complexContent> with a <sequence> of <element> generate a property restriction. 
  - if the element has attributes name=P and a type=T, generate a property   restriction on property P and class T. Moreover, if T is a name that starts with "xs:" (xs:boolean, xs:anyURI, xs:string, ...) then P is declared as a datatype property
  - if the element has a ref=E attribute, where E is an element name, generate a restriction on property E and class TE, where TE is the type of element E.

Example. The following complex types

    <xs:complexType name="AppearanceType">
        <xs:annotation>
            <xs:documentation> Named container for all surface data (texture/material). All appearances of the same name ("theme")
                within a CityGML file are considered a group. </xs:documentation>
        </xs:annotation>
        <xs:complexContent>
            <xs:extension base="gml:AbstractFeatureType">
                <xs:sequence>
                    <xs:element name="theme" type="xs:string" minOccurs="0"/>
                    <xs:element name="surfaceDataMember" type="SurfaceDataPropertyType" minOccurs="0" maxOccurs="unbounded"/>
                    <xs:element ref="_GenericApplicationPropertyOfAppearance" minOccurs="0" maxOccurs="unbounded"/>
                </xs:sequence>
            </xs:extension>
        </xs:complexContent>
    </xs:complexType>

will be transformed to

    <owl:Class xmlns:core="http://cui.unige.ch/isi/ontologies/citygml/gml.owl#" rdf:about="AppearanceType">

    <rdfs:comment> 
        Named container for all surface data (texture/material). All appearances of the same name ("theme") within a CityGML file are considered a group. 
    </rdfs:comment>

    <rdfs:subClassOf rdf:resource="gml:AbstractFeatureType"/>
    
    <rdfs:subClassOf>
        <owl:Restriction>
            <owl:onProperty rdf:resource="theme"/>
            <owl:allValuesFrom rdf:resource="xs:string"/> 
        </owl:Restriction>
    </rdfs:subClassOf>
    
    <rdfs:subClassOf>
        <owl:Restriction><owl:onProperty rdf:resource="surfaceDataMember"/> 
            <owl:allValuesFrom rdf:resource="SurfaceDataPropertyType"/>
        </owl:Restriction>
    </rdfs:subClassOf>
      
    <rdfs:subClassOf><owl:Restriction><owl:onProperty rdf:resource="_GenericApplicationPropertyOfAppearance"/><owl:allValuesFrom rdf:resource="xs:anyType"/></owl:Restriction></rdfs:subClassOf></owl:Class>

Note that the element with ref =  _GenericApplicationPropertyOfAppearance translates to an allValuesFrom restriction on property _GenericApplicationPropertyOfAppearance and class xs:anyType since _GenericApplicationPropertyOfAppearance is defined as

    <xs:element name="_GenericApplicationPropertyOfAppearance" type="xs:anyType" abstract="true"/>
    

----

Manually added :

in SurfaceDataPropertyType, _SurfaceData was missing (bug?)

