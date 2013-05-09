<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions"
	version="2.0">

	<doc:documentation scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code>xhtml-suffix</code> parameter defines
			the suffix used on output files for <code>xsl:include</code> and <code>xsl:import</code>
			statements.</p>
	</doc:documentation>
	<xsl:param name="xhtml-suffix" select="'xhtml'"/>
	
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Given an href (from an
			<code>xsl:include</code> or <code>xsl:import</code> statement
			generate the HTML file name for the documentation.</p>
	</doc:documentation>
	<xsl:function name="cfn:filename">
		<xsl:param name="href"/>
		<xsl:value-of select="replace($href, 'xslt?', $xhtml-suffix)"/>
	</xsl:function>
	
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Given a node, returns
		the ID of that node or a generated one.</p>
	</doc:documentation>
	<xsl:function name="cfn:node-id" as="xs:ID">
		<xsl:param name="node" as="element()"/>
		<xsl:value-of select="($node/@xml:id, $node/@id, generate-id($node))[1]"/>
	</xsl:function>
	
</xsl:stylesheet>