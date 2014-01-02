<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd"
	version="2.0">

	<xsl:stylesheet version="2.0"> 
		<xsl:template match="*"> 
			<xsl:apply-templates /> 
		</xsl:template> 
		<xsl:template match="text()|@*"> 
			<xsl:apply-templates /> 
		</xsl:template> 
		<xsl:template match="comment()|processing-instruction()" /> 
	</xsl:stylesheet>	
</xsl:stylesheet>