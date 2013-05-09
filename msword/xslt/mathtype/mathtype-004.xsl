<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://docbook.org/ns/docbook"
	xpath-default-namespace="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs xd"
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
	
	<!-- Stage 4 merge paras around inline equation elements -->
	
	<xsl:import href="../../xslt/identity.xsl"/>

	<xsl:template match="*[inlineequation]">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:for-each-group select="*" group-adjacent="if (following-sibling::*[1][self::inlineequation] or 
				preceding-sibling::*[1][self::inlineequation] or 
				self::inlineequation) then 'yes' else 'no'">
				<xsl:choose>
					<xsl:when test="current-grouping-key() = 'yes'">
						<para>
							<xsl:apply-templates select="current-group()[1]/@*"/>
							<xsl:apply-templates select="current-group()" mode="merge"/>
						</para>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="inlineequation" mode="merge">
		<xsl:apply-templates select="." mode="dummy"/>
	</xsl:template>

	<xsl:template match="para" mode="merge">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	
</xsl:stylesheet>