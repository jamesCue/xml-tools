<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://www.corbas.co.uk/ns/docxconv"
	xpath-default-namespace="http://www.corbas.co.uk/ns/docxconv"
	exclude-result-prefixes="xs xd"
	version="2.0" >
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Sep 24, 2012</xd:p>
			<xd:p><xd:b>Author:</xd:b> nicg</xd:p>
			<xd:p>Converts a valid docxconv transformations list into a flattened sequence of
			documents. Called from XProc, only the secondary outputs are meaningful.</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:template match="transformations|transformation.group">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="transformation">
		<xsl:result-document href="{concat(@name, '.xml')}" validation="strict">
			<flattened-transformation xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
				xmlns="http://www.corbas.co.uk/ns/docxconv" schemaLocation="http:"
		</xsl:result-document>
	</xsl:template>
	
</xsl:stylesheet>