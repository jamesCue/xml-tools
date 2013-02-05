<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xd"
	xmlns="http://docbook.org/ns/docbook" xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:cword="http://www.corbas.co.uk/ns/word"
	version="2.0">
	
	<xsl:param name="part-level" select="999"/>
	<xsl:param name="chapter-level" select="1"/>
	
	<xsl:variable name="max-title-level" select="max(//title[@cword:level]/@cword:level)"/>
	

	<xsl:include href="../../xslt/identity.xsl"/>

	<xsl:template match="book">
		
		<xsl:variable name="content">
			<xsl:call-template name="process-titles"/>
		</xsl:variable>
		
		<xsl:variable name="top-level" select="if ($content//chapter or $content//part) then 'book' else 'article'"/>
		
		<xsl:element name="{$top-level}">
			<xsl:apply-templates select='@*'/>		
			<xsl:copy-of select="$content"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-titles" as="node()*">
		
		<xsl:param name="level" select="$max-title-level"/>
		<xsl:param name="content" select="node()" as="node()*"/>
		<xsl:variable name="section-type" select="
			if ($level = $part-level) 
				then 'part' 
				else 
				(
					if ($level = $chapter-level) 
						then 'chapter' 
						else 'section'
				)"/>
		
		<xsl:variable name="result" as="node()*">
			
			<xsl:for-each-group select="$content" group-starting-with="title[@cword:level]">
				<xsl:choose>
					<xsl:when test="self::title[@cword:level] and @cword:level = $level">
						<xsl:element name="{$section-type}">
							<xsl:apply-templates select="@* except @xml:id"/>
							<xsl:copy-of select="current-group()"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:for-each-group>	
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$level gt 1">
				<xsl:call-template name="process-titles">
					<xsl:with-param name="level" select="$level - 1"/>
					<xsl:with-param name="content" select="$result"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$result"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>




</xsl:stylesheet>
