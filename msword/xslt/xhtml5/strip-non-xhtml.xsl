<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cword="http://www.corbas.co.uk/ns/word"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	exclude-result-prefixes="cword dcterms xd xlink"
	version="1.0"  >
	
	<xsl:import href="identity.xsl"/>
	
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
	
	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<p xmlns="http://www.w3.org/1999/xhtml">Remove all non xhtml content from output</p>
	</documentation>
	
	<xsl:template match="cword:word-doc" >
		<xsl:apply-templates select="html:*"/>
	</xsl:template>
	
<!--	<xsl:template match="html:*">
		<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="@*|node()" />
		</xsl:element>
	</xsl:template> -->
	
	<xsl:template match="@cword:*"/>
	
</xsl:stylesheet>