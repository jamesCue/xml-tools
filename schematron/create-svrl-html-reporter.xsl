<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:corbas="http://www.corbas.net/ns/functions"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0">
	
	<!--	This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
	
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
	contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. -->

    <xsl:import href='svrl-reporter-shared.xsl'/>

    <xsl:output method="xml" indent="yes"  encoding="UTF-8"/>
    
    <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

    <!-- set to true to use the role values as classes -->
    <xsl:param name="role-as-style" select="'true'"/>

    <!-- set to true to use the role values as labels -->
    <xsl:param name="role-as-label" select="'true'"/>

    <!-- set to true to use the role values as titles -->
    <xsl:param name="role-as-title" select="'true'"/>
        
    <!-- set to true to use the id values as labels -->
    <xsl:param name="id-as-label" select="'true'"/>
    
    <!-- set to true to use the id values as titles -->
    <xsl:param name="id-as-title" select="'true'"/>
    
    
    <!-- set to false to stop the output of rule, etc ids where present -->
    <xsl:param name="output-schematron-id" select="'true'"/>
    
    <xsl:variable name="dq"><xsl:text>"</xsl:text></xsl:variable>
    
    <xsl:variable name="dollar" select="'$'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="svrl:schematron-output"/>
    </xsl:template>

    <xsl:template match="svrl:schematron-output">
        <xsl:variable name="context" select="."/>
        <xsl:variable name='where-am-i' select="base-uri(document(''))"/>
        
        <axsl:stylesheet version="2.0">

            <xsl:for-each select="in-scope-prefixes(.)">
                <xsl:call-template name="create-ns">
                    <xsl:with-param name="prefix" select="."/>
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:for-each>

            <axsl:import href="{resolve-uri('svrl-report-helpers.xsl', $where-am-i)}"/>
            <axsl:import href="{resolve-uri('xmlverbatim.xsl', $where-am-i)}"/>
            <axsl:output media-type="xhtml"/>
            <axsl:param name='role-as-style'><xsl:value-of select='$role-as-style'/></axsl:param>
            <axsl:param name='role-as-label'><xsl:value-of select='$role-as-label'/></axsl:param>
            <axsl:param name='role-as-title'><xsl:value-of select='$role-as-title'/></axsl:param>
            <axsl:param name='id-as-label'><xsl:value-of select='$id-as-label'/></axsl:param>
            <axsl:param name='id-as-title'><xsl:value-of select='$id-as-title'/></axsl:param>
            
            <axsl:param name="output-schematron-id"><xsl:value-of select="$output-schematron-id"/></axsl:param>
            <axsl:strip-space elements="*"/>

            <axsl:template match="/">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <title>
                            <xsl:choose>
                                <xsl:when test="normalize-space(svrl:schematron-output/@title)">
                                    <xsl:value-of select="svrl:schematron-output/@title"/>
                                </xsl:when>
                                <xsl:otherwise>Schematron Processing Output Report</xsl:otherwise>
                            </xsl:choose>

                        </title>
                        <style type="text/css">
                            .xmlverb-default          { color: #333333; background-color: #ffffff;
                            font-family: monospace }
                            .xmlverb-element-name     { color: #990000 }
                            .xmlverb-element-nsprefix { color: #666600 }
                            .xmlverb-attr-name        { color: #660000 }
                            .xmlverb-attr-content     { color: #000099; font-weight: bold }
                            .xmlverb-ns-name          { color: #666600 }
                            .xmlverb-ns-uri           { color: #330099 }
                            .xmlverb-text             { color: #000000; font-weight: bold }
                            .xmlverb-comment          { color: #006600; font-style: italic }
                            .xmlverb-pi-name          { color: #006600; font-style: italic }
                            .xmlverb-pi-content       { color: #006666; font-style: italic }

                            body
                            {
                            	font-family: Helvetica, Arial, sans-serif;
                            	font-size:  medium;
                            }
                            
                            
                            
                            div.error
                            {
                            	border-top-style: solid;
                            	border-top-width: 1px;
                            	border-top-color: black;
                            	margin-top: 2em;
                            	padding-top: 1em;
                            }
                            
                            div.element
                            {
                                padding: 2em;
                                border: 1px dotted silver;
                            }
                            
                            div.assert, div.report
                            {
                                margin-top: 4em;
                                padding: 2em;
                                border: 1px solid silver;
                            }
                            
                            table
                            {
                                margin-bottom: 1.5em;
                            }
                            
                            th
                            {
                                text-align: left;
                            }
                            
                            div.warning h3
                            {
                                color: #fff000;
                            }
                            
                            div.error h3
                            {
                                color: red;
                            }
                            
                         

                        </style>
                    </head>

                    <body>
                        <h1>
                            <xsl:choose>
                                <xsl:when test="normalize-space(svrl:schematron-output/@title)">
                                    <xsl:value-of select="svrl:schematron-output/@title"/>
                                </xsl:when>
                                <xsl:otherwise>Schematron Processing Output Report</xsl:otherwise>
                            </xsl:choose>

                        </h1>

                        <!-- generate document structure with calls for each assert or report.-->
                        <xsl:for-each-group group-starting-with="svrl:active-pattern"
                            select="svrl:successful-report|svrl:failed-assert|svrl:fired-rule|svrl:active-pattern">

                                <xsl:apply-templates select="." mode="generate-calls"/>
                                                            
                        </xsl:for-each-group>

                    </body>

                </html>
            </axsl:template>

        </axsl:stylesheet>

    </xsl:template>

    <xsl:template match="svrl:active-pattern" mode="generate-calls">
        <xsl:if test='count(current-group()) gt 1'>
        <div id="{@name}" class="pattern">
            <h2>Pattern: <xsl:value-of select="@name"/></h2>
            <div class="pattern-content">
                <xsl:for-each-group select="current-group() except ."
                    group-starting-with="svrl:fired-rule">
                    <xsl:apply-templates select="." mode="generate-calls"/>
                </xsl:for-each-group>
            </div>
        </div>
        </xsl:if>            
    </xsl:template>


    <!-- If we have a fired rule that has some associated assertions or
    reports, we need to generate a div for it. -->
    <xsl:template match="svrl:fired-rule" mode="generate-calls">   
        <xsl:if test='count(current-group()) gt 1'>
            <div class='rule'>
                <xsl:call-template name="output-label">
                    <xsl:with-param name="role" select="@role"/>
                    <xsl:with-param name="id" select="@id"/>
                </xsl:call-template>
                <xsl:call-template name="output-style">
                    <xsl:with-param name="base-class" select="local-name()"/>
                </xsl:call-template>
                <xsl:call-template name="output-icon">
                    <xsl:with-param name="icon">
                        <xsl:value-of select="@icon"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="output-title">
                    <xsl:with-param name="level">2</xsl:with-param>
                    <xsl:with-param name="role" select="@role"/>
                    <xsl:with-param name="id" select="@id"/>
                </xsl:call-template>
                <xsl:apply-templates select='current-group() except .' mode='generate-calls'/>
            </div>
        </xsl:if>            
    </xsl:template>
    

    <xsl:template match="svrl:successful-report|svrl:failed-assert" mode='generate-calls'>
        <axsl:apply-templates select="{@location}">
            <xsl:call-template name="generate-param">
                <xsl:with-param name="name">message</xsl:with-param>
                <xsl:with-param name="value" select="svrl:text"/>
            </xsl:call-template>
            <xsl:call-template name="generate-param">
                <xsl:with-param name="name">type</xsl:with-param>
                <xsl:with-param name="value" select="if (local-name() eq 'failed-assert') then 'assert' else 'report'"/>
            </xsl:call-template>            
            <xsl:if test='@role'>
                <xsl:call-template name="generate-param">
                    <xsl:with-param name="name">role</xsl:with-param>
                    <xsl:with-param name="value" select="if (@role) then @role else 'error'"/>
                </xsl:call-template>            
            </xsl:if>
            <xsl:if test="@icon">
                <xsl:call-template name="generate-param">
                    <xsl:with-param name="name">icon</xsl:with-param>
                    <xsl:with-param name="value" select="@icon"/>
                </xsl:call-template>            
            </xsl:if>
            <xsl:if test="@see">
                <xsl:call-template name="generate-param">
                    <xsl:with-param name="name">see</xsl:with-param>
                    <xsl:with-param name="value" select="@see"/>
                </xsl:call-template>            
            </xsl:if>
            <xsl:if test="@id">
                <xsl:call-template name="generate-param">
                    <xsl:with-param name="name">schematron-id</xsl:with-param>
                    <xsl:with-param name="value" select="@id"/>
                </xsl:call-template>            
            </xsl:if>
            
        </axsl:apply-templates>
        
    </xsl:template>


    <xsl:template name="create-ns">
        <xsl:param name="context"/>
        <xsl:param name="prefix"/>
        <xsl:namespace name="{$prefix}" select="namespace-uri-for-prefix($prefix, $context)"/>
    </xsl:template>
    
    <!-- generate an axsl:with-param -->
    <xsl:template name='generate-param'>
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <axsl:with-param>
            <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
            <xsl:attribute name="select">'<xsl:value-of select="$value"/>'</xsl:attribute>
        </axsl:with-param>
    </xsl:template>

    <!-- generate an axsl:value-of for a named variable -->
    <xsl:template name='variable-value'>
        <xsl:param name='varname'/>
        <axsl:value-of>
            <xsl:attribute name='select'><xsl:value-of select="concat($dollar, $varname)"/></xsl:attribute>
        </axsl:value-of>
    </xsl:template>
    
</xsl:stylesheet>
