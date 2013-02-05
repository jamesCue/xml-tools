<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://docbook.org/ns/docbook"
	xpath-default-namespace="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs xd"
	version="2.0">
	
	<!-- Initial equation management - convert block equations to a single equation with escaped MML. -->
	
	<xsl:import href="../../xslt/identity.xsl"/>
	
	<xsl:template match="*[*[@role='Equation'][phrase[@role='MTConvertedEquation']]]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
		<xsl:for-each-group select='*' group-adjacent="if (@role = 'Equation' and phrase[@role='MTConvertedEquation']) then 'yes' else 'no'">
			<xsl:choose>
				<xsl:when test="current-grouping-key() = 'yes'">
					<equation>
					<xsl:apply-templates select="current-group()" mode="strip"/>
					</equation>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="current-group()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
		
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match='para|phrase' mode='strip'>
		<xsl:apply-templates select="node()" mode="strip"/>
	</xsl:template>
	
</xsl:stylesheet>