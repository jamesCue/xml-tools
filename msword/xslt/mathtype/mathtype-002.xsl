<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://docbook.org/ns/docbook"
	xpath-default-namespace="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs xd"
	version="2.0">
	
	<!-- Stage 2 equation management - split out inline equations. -->
	
	<xsl:import href="../../xslt/identity.xsl"/>
	
	<xsl:template match="para[phrase[position() = last()][@role='MTConvertedEquation']]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="node()[position() lt last()]"/>
		</xsl:copy>
		<para><xsl:apply-templates select="node()[last()]"/></para>
	</xsl:template>
	
	
</xsl:stylesheet>