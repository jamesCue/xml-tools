<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.corbas.co.uk/ns/word"
    exclude-result-prefixes="xs"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xpath-default-namespace="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
    version="2.0">	
    
    <!-- cleans up the word numbering file so that we can more easily extract information from it -->
	
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
    
    <xsl:import href="identity.xsl"/>
	
	
    
    <xsl:template match="w:numbering">
        <list-formats xmlns="http://www.corbas.co.uk/ns/word">
            <xsl:apply-templates select="w:num"/>
        </list-formats>
    </xsl:template>
    
    <xsl:template match="w:num">
        <xsl:variable name="abstract" select="w:abstractNumId/@w:val"/>
        <list-format number="{@w:numId}">
            <xsl:apply-templates select="../w:abstractNum[@w:abstractNumId = $abstract]/w:lvl"/>
        </list-format>
    </xsl:template>   
    
    <xsl:template match="w:lvl">
        <level>
            <xsl:apply-templates select="w:numFmt|w:start|w:lvlText"/>
        </level>        
        
    </xsl:template>
    
    <xsl:template match="w:numFmt">
        <xsl:attribute name="format" select="@w:val"/>
    </xsl:template>
    
    <xsl:template match="w:start">
        <xsl:attribute name="start" select="@w:val"/>
    </xsl:template>
    
    <xsl:template match="w:lvlText">
        <xsl:attribute name="text" select="@w:val"/>
    </xsl:template>
    

</xsl:stylesheet>