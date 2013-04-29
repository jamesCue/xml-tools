<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://docbook.org/ns/docbook"
	xpath-default-namespace="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs xd"
	version="2.0">
	
	<!-- Stage 4 merge paras around inline equation elements -->
	
	<xsl:import href="../../xslt/identity.xsl"/>

	<xsl:template match="*[inlineequation]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:for-each-group select="*" group-adjacent="if (following-sibling::*[1][self::inlineequation] or 
				preceding-sibling::*[1][self::inlineequation] or 
				self::inlineequation) then 'yes' else 'no'">
				<xsl:choose>
					<xsl:when test="current-grouping-key() = 'yes'">
						<para>
							<xsl:apply-templates select="current-group()[1]/@*"/>
							<xsl:apply-templates select="current-group()" mode="merge"/>
						</para>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="inlineequation" mode="merge">
		<xsl:apply-templates select="." mode="dummy"/>
	</xsl:template>

	<xsl:template match="para" mode="merge">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	
</xsl:stylesheet>