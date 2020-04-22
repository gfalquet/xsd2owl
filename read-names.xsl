<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="yy">

<!-- extract the class names, association names, and attribute names from a CityGML XML Schema -->

<xsl:template match='xs:schema'>
<schema>
<xsl:apply-templates select="xs:complexType"/>
<xsl:apply-templates select="xs:simpleType"/>
</schema>
</xsl:template>

<xsl:template match="xs:complexType">
  <class>
  <xsl:text>&#x0A;</xsl:text> <!-- LINE FEED -->
  <xsl:variable name="txt">	<xsl:value-of select="@name" />  </xsl:variable>
  <name><xsl:value-of select="$txt" /></name>  <xsl:if test="contains($txt, 'Property')">	<cat>association</cat>  </xsl:if>
  <xsl:if test="not(contains($txt, 'Property'))">	<cat>class</cat>
  </xsl:if>
  <xsl:apply-templates select="./xs:complexContent/xs:extension"/>
  <xsl:for-each select="./xs:complexContent/xs:extension/xs:sequence/xs:element">
        <xsl:text>&#x0A;    </xsl:text> <!-- LINE FEED -->
        <attribute>
            <name>
              <xsl:value-of select="@name" />
            </name>
            <type>
              <xsl:value-of select="@type" />
            </type>
        </attribute>
  </xsl:for-each>  </class>
</xsl:template>


<xsl:template match="xs:simpleType">
   <xsl:text>&#x0A;</xsl:text> <!-- LINE FEED -->
   <class>
     <name><xsl:value-of select="@name"/></name><cat>simple-class</cat>
   </class>
</xsl:template>


<xsl:template match="xs:extensin">
   <subclassOf>
      <xsl:value-of select="@base"/>
   </subclassOf>
</xsl:template>

</xsl:stylesheet>