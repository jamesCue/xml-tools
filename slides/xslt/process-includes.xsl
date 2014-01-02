<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.corbas.co.uk/ns/presentations"
	xpath-default-namespace="http://www.corbas.co.uk/ns/presentations"
	 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  exclude-result-prefixes="xsi"
	version="2.0">
	
	<xsl:template match="/">
		<xsl:apply-templates mode="includes"/>
	</xsl:template>
	
	<xsl:template match="@*|comment()|text()|processing-instruction()" mode="includes">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode='#current'/>
		</xsl:copy>
	</xsl:template>
	
	<!-- this is complex in order to preserve namespaces exactly as in the 
		input - needed for code examples -->
	<xsl:template match="*[prefix-from-QName(node-name(.))]" mode="includes">
				<xsl:element name="{name()}" namespace="{namespace-uri()}">
					<xsl:apply-templates select="@*|node()" mode="#current"/>
				</xsl:element>
	</xsl:template>
	
	<xsl:template match='*' mode="includes">
		<xsl:element name="{local-name()}" namespace="{namespace-uri()}">
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:element>			
	</xsl:template>
	

	<!-- Import simply copies the referenced document into the referencing document.
	Often recursive. -->
	<xsl:template match="import" priority="1" mode="includes">
		
		 <xsl:choose>
		 	<xsl:when test="doc-available(resolve-uri(@href, base-uri(.)))">
		 		<xsl:apply-templates select="doc(resolve-uri(@href, base-uri(.)))/*" mode="#current"/>
		 	</xsl:when>
		 	<xsl:otherwise>
		 		<xsl:message terminate="yes">Unable to load <xsl:value-of select="@href"/> (resolves as <xsl:value-of select="resolve-uri(@href, base-uri(.))"/>)</xsl:message>
		 	</xsl:otherwise>
		 </xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>