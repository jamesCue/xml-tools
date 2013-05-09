<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cword="http://www.corbas.co.uk/ns/word"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns="http://docbook.org/ns/docbook"
     xpath-default-namespace="http://docbook.org/ns/docbook"
    exclude-result-prefixes="xs xd w">
	
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
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> 21/9/12</xd:p>
            <xd:p><xd:b>Author:</xd:b> nicg</xd:p>
            <xd:p>ILO Version - more standard word formatting</xd:p>
        </xd:desc>
    </xd:doc>
	
	<!-- paras with these styles will be suppressed -->
	<xsl:variable name="style-suppression-list" select="('Contentslist')"/>
	 
    <!-- para with normal style -->
    <xsl:template match="para/@role[. = 'normal']"/>    
	
	<!-- known titles -->
	<xsl:template match="para[starts-with(@role, 'Heading')]">
		<title><xsl:apply-templates select="@*|node()"/></title>
	</xsl:template>
    
	<xsl:template match="para[@role = $style-suppression-list]"/>
	
	
	<!-- figure styles -->
	<xsl:template match="para[@role ='Figurenumber']|para[@role='Boxfigurenumber']">
		<title cword:hint="figure"><xsl:apply-templates select="@*|node()"/></title>
	</xsl:template>

	<xsl:template match="para[@role ='Figurecaption']|para[@role='Boxfigurecaption']">
		<caption cword:hint="figure"><xsl:apply-templates select="@*"/><para><xsl:apply-templates select="node()"/></para></caption>
	</xsl:template>

	<xsl:template match="para[@role ='Figuresources']|para[@role='Boxfiguresource']">
		<bibliosource cword:hint="figure"><xsl:apply-templates select="@*|node()"/></bibliosource>
	</xsl:template>
	
	<xsl:template match="para[@role ='Figurenotes']|para[@role='Boxfigurenotes']">
		<para cword:hint="figure" role="note"><xsl:apply-templates select="@*|node() except @role"/></para>
	</xsl:template>
	
	<!-- table styles -->
	<xsl:template match="para[@role ='Tablenumber0']">
		<title cword:hint="table"><xsl:apply-templates select="@*|node()"/></title>
	</xsl:template>
	
	<xsl:template match="para[@role ='Tablecaption']">
		<caption cword:hint="table"><xsl:apply-templates select="@*"/><para><xsl:apply-templates select="node()"/></para></caption>
	</xsl:template>
	
	<xsl:template match="para[@role ='Tablesources']">
		<bibliosource cword:hint="table"><xsl:apply-templates select="@*|node()"/></bibliosource>
	</xsl:template>
	
	<xsl:template match="para[@role ='Tableenotes']">
		<para cword:hint="table" role="note"><xsl:apply-templates select="@*|node() except @role"/></para>
	</xsl:template>
	
	
	
</xsl:stylesheet>
