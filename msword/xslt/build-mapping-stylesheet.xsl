<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:data="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:cfunc="http://www.corbas.co.uk/ns/functions"
	xmlns:cword="http://www.corbas.co.uk/ns/word"
	xpath-default-namespace="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns="http://docbook.org/ns/docbook" version="2.0">

	<xsl:output method="xml" indent="yes"  encoding="UTF-8"/>
	
	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
	
	<xsl:param name="match-element" select="'para'"/>
	<xsl:param name="match-namespace" select="'http://docbook.org/ns/docbook'"/>
	<xsl:param name="output-namespace" select="$match-namespace"/>
	<xsl:param name="match-attribute" select="'role'"/>
	
	<xsl:template match="/">
		<axsl:stylesheet xpath-default-namespace="{$match-namespace}" version="2.0">
			<axsl:output method="xml" encoding="UTF-8"/>
			
			<axsl:template match="@*|node()">
				<axsl:copy>
					<axsl:apply-templates select="@*|node()"/>
				</axsl:copy>
			</axsl:template>
			
			<xsl:apply-templates/>						
			
		</axsl:stylesheet>
	</xsl:template>
	
	<xsl:template match="word-mapping[@source-style][@suppress='true']" priority="1">
		<axsl:template match="{cfunc:source-style(@source-style)}"/>
	</xsl:template>
		
	<xsl:template match="word-mapping[@source-style]">
		<axsl:template match="{cfunc:source-style(@source-style)}">
			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>
	
	<xsl:template match="word-mapping[@source-style-suffix][@suppress='true']" priority="1">
		<axsl:template match="{cfunc:source-style-suffix(@source-style)}"/>
	</xsl:template>

	<xsl:template match="word-mapping[@source-style-prefix]">
		<axsl:template match="{cfunc:source-style-prefix(@source-style)}">
			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>
	
	<xsl:template match="word-mapping[@source-style-prefix][@suppress='true']" priority="1">
		<axsl:template match="{cfunc:source-style-prefix(@source-style-prefix)}"/>
	</xsl:template>

	<xsl:template match="word-mapping[@source-style-suffix]">
		<axsl:template match="{cfunc:source-style-suffix(@source-style-suffix)}">
			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>
	
	<xsl:function name="cfunc:source-style">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of select="concat($match-element, '[@', $match-attribute, ' = ''', $source-attrib, ''']')"/>
	</xsl:function>
	
	<xsl:function name="cfunc:source-style-prefix">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of select="concat($match-element, '[starts-with(@', $match-attribute, ',''', $source-attrib, ''')]')"/>
	</xsl:function>
	
	<xsl:function name="cfunc:source-style-suffix">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of select="concat($match-element, '[ends-with(@', $match-attribute, ', ''', $source-attrib, ''')]')"/>
	</xsl:function>
	
	<xsl:template name="generate-elements">
		<xsl:param name="element-list" as="xsd:string*"/>
		<xsl:param name="top-level" as="xsd:boolean"/>		
		<xsl:choose>

			<xsl:when test="count($element-list) = 0">
				<axsl:apply-templates select="@*|node()"/>
			</xsl:when>
			
			<xsl:otherwise>
				
				<xsl:element name="{$element-list[1]}" namespace="{$output-namespace}">
					
					<xsl:if test="$top-level = true()">
						<xsl:apply-templates select="@hint|@heading-level"/>
					</xsl:if>
					
					<xsl:call-template name="generate-elements">
						<xsl:with-param name="element-list" select="subsequence($element-list, 2)"/>
						<xsl:with-param name="top-level" select="false()"/>
					</xsl:call-template>
					
				</xsl:element> 
				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="@hint">
		<xsl:attribute name="hint" namespace="http://www.corbas.co.uk/ns/word" select="."/>
	</xsl:template>
	
	<xsl:template match="@heading-level">
		<xsl:attribute name="level" namespace="http://www.corbas.co.uk/ns/word" select="."/>
	</xsl:template>
	
	
</xsl:stylesheet>