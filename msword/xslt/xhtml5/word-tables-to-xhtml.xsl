<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:db="http://docbook.org/ns/docbook"
	xpath-default-namespace="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs  xd db w">
	
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
	
	<xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> Feb 11, 2013</xd:p>
			<xd:p>Derived from work originally done for DocBook conversion.</xd:p>
			<xd:p><xd:b>Author:</xd:b> nicg</xd:p>
		</xd:desc>
	</xd:doc>

	<xd:doc>
		<xd:desc>
			<xd:p>Convert a word table to an xhtml table.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:tbl">
		<table>
			<xsl:apply-templates select="w:tblPr|w:tblGrid"/>
			<xsl:apply-templates select="." mode="table-header"/>
			<xsl:apply-templates select="." mode="table-body"/>
		</table>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>If a table has rows marked as headers we output them to a thead element.</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:template match="w:tbl[descendant::w:tblHeader]" mode="table-header">
		<thead>
			<xsl:apply-templates select="w:tr[descendant::w:tblHeader]"/>
		</thead>
	</xsl:template>

	<xsl:template match="w:tbl" mode="table-header"/>

	<xd:doc>
		<xd:desc>
			<xd:p>Output all rows of a table not marked as headers</xd:p>
		</xd:desc>
	</xd:doc>

	<xsl:template match="w:tbl" mode="table-body">
		<tbody>
			<xsl:apply-templates select="w:tr[not(descendant::w:tblHeader)]"/>
		</tbody>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Copy the table style to the class of the table if there is one.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:tblStyle">
		<xsl:attribute name="class" select="@w:val"/>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Copy rows to the output</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:tr">
		<tr>
			<xsl:apply-templates select="w:tc"/>
		</tr>
	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Process 'normal' table cells - those which do not exist purely to extend or start
				a vertical span.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:tc[not(descendant::wvMerge)]">

		<td>
			<xsl:apply-templates/>
		</td>

	</xsl:template>

	<xd:doc>
		<xd:desc>
			<xd:p>Copy the value of the w:gridSpan element over to an colspan attribute on the html
				output.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:gridSpan">
		<xsl:attribute name="colspan" select="@w:val"/>
	</xsl:template>


	<xd:doc>
		<xd:desc>
			<xd:p>Process table cells which start a vertical span.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="w:tc[descendant::wvMerge[w:val = 'restart']]">

		<xsl:if test="not(w:tcPr/w:vMerge) or w:tcPr/w:vMerge[@w:val = &quot;restart&quot;]">

			<td>

				<xsl:variable name="this.colnum"
					select="count(preceding-sibling::w:tc) + 1 +
                sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val) -
                count(preceding-sibling::w:tc/w:tcPr/w:gridSpan[@w:val])"/>

				<xsl:if test="w:tcPr/w:gridSpan[@w:val > 1]">
					<xsl:attribute name="namest">
						<xsl:text>column-</xsl:text>
						<xsl:value-of select="$this.colnum"/>
					</xsl:attribute>
					<xsl:attribute name="nameend">
						<xsl:text>column-</xsl:text>
						<xsl:value-of select="$this.colnum + w:tcPr/w:gridSpan/@w:val - 1"/>
					</xsl:attribute>
				</xsl:if>

				<xsl:if test="w:tcPr/w:vMerge[@w:val = &quot;restart&quot;]">
					<xsl:attribute name="morerows" select="cfn:rowspan(.)"/>
				</xsl:if>

				<xsl:if test="position() = 1">
					<xsl:attribute name="role" select="'first-col'"/>
				</xsl:if>

				<xsl:apply-templates/>

			</td>
		</xsl:if>

	</xsl:template>

	<xsl:function name="cfn:colnum">

		<xsl:param name="cell"/>

		<xsl:value-of
			select="count($cell/preceding-sibling::w:tc) + 1 +
			sum($cell/preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val) -
			count($cell/preceding-sibling::w:tc/w:tcPr/w:gridSpan[@w:val])"/>

	</xsl:function>

	<xsl:function name="cfn:rowspan" as="xs:integer">

		<xsl:param name="cell"/>
		<xsl:variable name="colnum" select="cfn:colnum($cell)"/>

		<!-- find the cell in the same column number in the next row -->
		<xsl:variable name="next-cell"
			select="$cell/parent::w:tr/following-sibling::tr[1]/w:tc[cfn:colnum(.) = $colnum]"/>

		<xsl:choose>
			<xsl:when test="not($cell//w:vMerge)">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:when test="$next-cell//w:vMerge[@w:val = 'restart']">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:when test="$next-cell">
				<xsl:value-of select="cfn:rowspan($next-cell) + 1"/>
			</xsl:when>
		</xsl:choose>


	</xsl:function>


	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<p xmlns="http://www.w3.org/1999/xhtml">Suppress table properties by default</p>
	</documentation>
	<xsl:template match="w:tcPr|w:trPr|w:tblPr"/>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<p xmlns="http://www.w3.org/1999/xhtml">Suppress the grid as it provides no useful
		information to xhtml.</p>
	</documentation>
	<xsl:template match="w:tblGrid"/>

</xsl:stylesheet>
