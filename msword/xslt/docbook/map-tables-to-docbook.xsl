<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:cword="http://www.corbas.co.uk/ns/word"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns="http://docbook.org/ns/docbook"
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
	
	<xsl:template match='w:tbl'>
		<xsl:variable name="colgroups" as="node()*">
			<xsl:apply-templates select='w:tblGrid'/>
		</xsl:variable>
        <informaltable cword:hint="table">     
            <tgroup cols="{count($colgroups)}">
                <xsl:copy-of select="$colgroups"/>
                <tbody>
                    <xsl:apply-templates select='w:tr'/>
                </tbody>
            </tgroup>
        </informaltable>
    </xsl:template>
    
    <xsl:template match='w:tblPr'/>
    
     <xsl:template match='w:tr'>
        <row>
            <xsl:apply-templates select='w:tc'/>
        </row>
    </xsl:template>
    
    <xsl:template match='w:tc'>
        
         
        <xsl:if test='not(w:tcPr/w:vMerge) or w:tcPr/w:vMerge[@w:val = "restart"]'>
        
         <entry>
           
            <xsl:variable name='this.colnum'
                select='count(preceding-sibling::w:tc) + 1 +
                sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val) -
                count(preceding-sibling::w:tc/w:tcPr/w:gridSpan[@w:val])'/>
            
            <xsl:if test='w:tcPr/w:gridSpan[@w:val > 1]'>
                <xsl:attribute name='namest'>
                    <xsl:text>column-</xsl:text>
                    <xsl:value-of select='$this.colnum'/>
                </xsl:attribute>
                <xsl:attribute name='nameend'>
                    <xsl:text>column-</xsl:text>
                    <xsl:value-of select='$this.colnum + w:tcPr/w:gridSpan/@w:val - 1'/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:if test='w:tcPr/w:vMerge[@w:val = "restart"]'>
                <xsl:attribute name='morerows'>
                    <xsl:call-template name='cword:count-rowspan'>
                        <xsl:with-param name='row' select='../following-sibling::w:tr[1]'/>
                        <xsl:with-param name='colnum' select='$this.colnum'/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
             
             <xsl:if test="position() = 1">
                 <xsl:attribute name='role' select="'first-col'"/>
             </xsl:if>
           
            <xsl:apply-templates/>
            
         </entry>
        </xsl:if> 

    </xsl:template>
    
    <xsl:template name='cword:count-rowspan'>
        <xsl:param name='row' select='/..'/>
        <xsl:param name='colnum' select='0'/>
        
        <xsl:variable name='cell'
            select='$row/w:tc[count(preceding-sibling::w:tc) + 1 +
            sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val) -
            count(preceding-sibling::w:tc/w:tcPr/w:gridSpan[@w:val]) = $colnum]'/>
        
        <xsl:choose>
            <xsl:when test='not($cell)'>
                <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:when test='$cell/w:tcPr/w:vMerge[not(@w:val = "restart")]'>
                <xsl:variable name='remainder'>
                    <xsl:call-template name='cword:count-rowspan'>
                        <xsl:with-param name='row'
                            select='$row/following-sibling::w:tr[1]'/>
                        <xsl:with-param name='colnum' select='$colnum'/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select='$remainder + 1'/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="w:tblGrid">
		<xsl:apply-templates/>
	</xsl:template>
        
    <xsl:template match='w:tblGrid/w:gridCol'>
        <colspec colwidth='{@w:w}*'
            colname='column-{count(preceding-sibling::w:gridCol) + 1}'/>
    </xsl:template>
	
	<!-- suppress cell properties -->
	<xsl:template match="w:tcPr"/>
    
</xsl:stylesheet>
