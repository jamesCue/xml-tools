<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xs xd" version="2.0">
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Jan 19, 2013</xd:p>
			<xd:p><xd:b>Author:</xd:b> nicg</xd:p>
			<xd:p/>
		</xd:desc>
	</xd:doc>

	<xsl:template match="/">
		<wrapper2 xmlns="http://temp.com/">
			<xsl:copy-of select="*"/>
		</wrapper2>
	</xsl:template>


</xsl:stylesheet>
