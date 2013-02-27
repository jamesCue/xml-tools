<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cfn="https://www.corbas.co.uk/ns/xsl/functions"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"  xmlns="http://www.w3.org/1999/xhtml"
	 exclude-result-prefixes="xsd cfn"
	version="2.0">

	<xsl:param name="page-element-names" select="''"/>
	<xsl:param name="xhtml-suffix"/>
	
	<xsl:variable name="page-elements" select="tokenize($page-element-names, '\s+')"/>
	<xsl:variable name="page-nodes" select="//*[local-name() = $page-elements]"/>


	<xsl:function name="cfn:page-id">
		<xsl:param name="node" as="element()"/>
		<xsl:value-of select="cfn:page-id($node, '')"/>
	</xsl:function>

	<xsl:function name="cfn:page-id">
		
		<xsl:param name="node" as="element()"/>
		<xsl:param name="prefix" as="xsd:string"/>
		
		<xsl:variable name="page-node"
			select="$node/ancestor-or-self::*[local-name() = $page-elements][1]"/>

		<xsl:variable name="of-my-type" select="$page-nodes[local-name() = local-name($page-node)]"/>
		<xsl:variable name="my-index" select="index-of($of-my-type, $page-node)"/>
		<xsl:variable name="suffix" select="format-number($my-index, '000')"/>
		<xsl:value-of select="concat($prefix, local-name($page-node), '-', $suffix)"/>
		
	</xsl:function>

	<xsl:function name="cfn:page-href">
		<xsl:param name="node" as="element()"/>
		<xsl:value-of select="cfn:page-href($node, '')"/>
	</xsl:function>
	
	<xsl:function name="cfn:page-href">
		<xsl:param name="node" as="element()"/>
		<xsl:param name="prefix" as="xsd:string"/>
		<xsl:value-of select="cfn:page-href($node, $prefix, '')"/>
	</xsl:function>

	<xsl:function name="cfn:page-href">
		<xsl:param name="node"/>
		<xsl:param name="prefix"/>
		<xsl:param name="fragment"/>
	
		<xsl:variable name="page-id" select="cfn:page-id($node, $prefix)"/>
		<xsl:value-of select="cfn:fixed-page-href($page-id, $prefix, $fragment)"/>
		
	</xsl:function>
	
	<xsl:function name="cfn:fixed-page-href">
		<xsl:param name="page-id"/>
		<xsl:value-of select="cfn:fixed-page-href($page-id, '')"/>
	</xsl:function>

	<xsl:function name="cfn:fixed-page-href">
		<xsl:param name="page-id"/>
		<xsl:param name="prefix"/>
		<xsl:value-of select="cfn:fixed-page-href($page-id, '', '')"/>
	</xsl:function>
	
	
	<xsl:function name="cfn:fixed-page-href">
		<xsl:param name="page-id"/>
		<xsl:param name="prefix"/>
		<xsl:param name="fragment"/>
		
		<xsl:variable name="href" select="concat($page-id, '.', $xhtml-suffix)"/>
		
		<xsl:choose>
			<xsl:when test="$fragment">
				<xsl:value-of select="concat($prefix, $href, '#', $fragment)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($prefix, $href)"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>

	
		
</xsl:stylesheet>
