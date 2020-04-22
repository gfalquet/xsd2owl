import sys
import re

fichier = open(sys.argv[1], 'r')
i=0

for ligne in fichier:
    if ligne.find("<?xml version=") > -1 :
       print("""<?xml version="1.0"?>

<!DOCTYPE rdf:RDF [
    <!ENTITY owl "http://www.w3.org/2002/07/owl#" >
    <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
    <!ENTITY xs "http://www.w3.org/2001/XMLSchema#">
    <!ENTITY owl2xml "http://www.w3.org/2006/12/owl2-xml#" >
    <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
    <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
    <!ENTITY gml "http://cui.unige.ch/isi/ontologies/citygml/gml.owl#" >
    <!ENTITY core "http://cui.unige.ch/isi/ontologies/citygml/core.owl#" >
]>
""")
    else:
       ligne = re.sub(r"gml:", r"&gml;", ligne)
       ligne = re.sub(r"core:", r"&core;", ligne)
       ligne = re.sub(r"xs:", r"&xs;", ligne)
       ligne = re.sub(r"rdf:about=\"([^&])", "rdf:about=\"#\\1", ligne)
       ligne = re.sub(r"rdf:resource=\"([^&])", "rdf:resource=\"#\\1", ligne)
       print(ligne)
