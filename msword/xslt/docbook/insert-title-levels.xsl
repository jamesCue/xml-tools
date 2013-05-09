<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:cword="http://www.corbas.co.uk/ns/word"
	xmlns="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs xd"
 	xpath-default-namespace="http://docbook.org/ns/docbook"
	version="2.0">
	
	<!--
		
		This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
		
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see http://www.gnu.org/licenses/.
		
		If your organisation or company are a customer or client of Corbas Consulting Ltd you may
		be able to use and/or distribute this software under a different license. If you are
		not aware of any such agreement and wish to agree other license terms you must
		contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. 
		
	-->
	
	<xsl:import href="../../xslt/identity.xsl"/>
	
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Sep 28, 2012</xd:p>
			<xd:p><xd:b>Author:</xd:b> nicg</xd:p>
			<xd:p>Inserts title level mappings into the document. Each title element 
			is examined and an cword:level attribute is inserted. The mappings are done 
			via the lookups file defined as an option below. Defaults to using a very
			simple set based on word's standard styles. The look file should follow 
			exactly the same format as the default below.</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:param name="lookup-file" select="''"/>
	
	

	<cword:title-levels fallback="7">
		<cword:level style="Heading1" level="1"/>
		<cword:level style="Heading2" level="2"/>
		<cword:level style="Heading3" level="3"/>
		<cword:level style="Heading4" level="4"/>
		<cword:level style="Heading5" level="5"/>
		<cword:level style="Heading6" level="6"/>
	</cword:title-levels>
	
	<xsl:variable name="level-lookups" select="if ($lookup-file) then doc($lookup-file) else doc('')//cword:title-levels"/>
	
	<xsl:template match="book/info/title|article/info/title">
		<xsl:copy>
			<xsl:apply-templates select='@*'/>
			<xsl:attribute name="cword:level" select="0"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="title">
		<xsl:variable name="role" select="@role"/>
		<xsl:variable name="level" select="if ($level-lookups//cword:level[@style = $role]) 
				then ($level-lookups//cword:level[@style = $role]/@level)[1] 
				else ''"/>
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="$level"><xsl:attribute name="cword:level" select="$level"/></xsl:if>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>		
	</xsl:template>
	
	
	
</xsl:stylesheet>