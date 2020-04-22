<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet	version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:gml="http://www.opengis.net/gml" 
xmlns="http://www.opengis.net/gml"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>

<!-- extract the class names, association names, and attribute names from a CityGML XML Schema -->

<xsl:template match='dico' xmlns="http://www.opengis.net/gml"
>
<schema>
<xsl:apply-templates select="gml:Dictionary"/>
</schema>
</xsl:template>

<xsl:template match="gml:Dictionary" xmlns="http://www.opengis.net/gml"
>
  <xsl:text>&#x0A;</xsl:text> <!-- LINE FEED -->
  <dict xmlns:gml="http://www.opengis.net/gml"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/gml">

  <name><xsl:value-of select="name" /></name>

  <xsl:for-each select="./dictionaryEntry/gml:Definition/gml:name[not(contains(@codeSpace, 'urn'))]">
        <xsl:text>&#x0A;    </xsl:text> <!-- LINE FEED -->
        <class>
            <name>
              <xsl:value-of select="." />
            </name>
            <super><xsl:value-of select="../../../name" /></super>
         </class>
  </xsl:for-each>  </dict>
</xsl:template>



</xsl:stylesheet>