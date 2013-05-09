<?xml 
    version="1.0" 
    encoding="utf-8"
    ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2"
    xmlns:cword="http://www.corbas.co.uk/ns/word"
    xmlns="http://docbook.org/ns/docbook"     
    xmlns:db="http://docbook.org/ns/docbook"     
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xpath-default-namespace="http://docbook.org/ns/docbook"
     exclude-result-prefixes="db xd cword xlink dcterms">
	
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
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Remove all non-docbook content from the XML.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output  indent="yes"/>
    
    <xsl:include href="../../xslt/identity.xsl"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Insert the xml-model PI at the root.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Take the only DocBook namespaced element that's a child
            of cword:word-doc and output only that.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cword:word-doc">
        <xsl:apply-templates select="db:*"/>
    </xsl:template>


	<!-- strip out the conversion helper attributes -->
	<xsl:template match="@cword:*"/>

</xsl:stylesheet>
