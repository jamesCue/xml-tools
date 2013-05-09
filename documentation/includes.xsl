<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs cfn doc" xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions"
	version="2.0">
	
	<xsl:import href="functions.xsl"/>

	<xsl:template match="xsl:stylesheet" mode="list">

		<nav class="contents">
			<ul>
				<xsl:apply-templates select="xsl:import|xsl:include" mode="list"/>
				<xsl:apply-templates select="xsl:param" mode="list"/>
				<xsl:apply-templates select="xsl:variable" mode="list"/>
			</ul>
		</nav>

	</xsl:template>

	<xsl:template match="xsl:import[1]|xsl:include[1][not(preceding-sibling::xsl:import)]"
		mode="list">
		<li>
			<ul>
				<h2>Imports &amp; Includes</h2>
				<xsl:apply-templates
					select=".|following-sibling::xsl:import|following-sibling::xsl:include"
					mode="list-content"/>
			</ul>
		</li>
	</xsl:template>
	
	<xsl:template match="xsl:variable[position() = 1]" mode="list">
		<li>
			<ul>
				<h2>Global Variables</h2>
				<xsl:apply-templates
					select=".|following-sibling::xsl:variable"
					mode="list-content"/>
			</ul>
		</li>
	</xsl:template>
	
	<xsl:template match="xsl:param[position() = 1]" mode="list">
		<li>
			<ul>
				<h2>Parameters</h2>
				<xsl:apply-templates
					select=".|following-sibling::xsl:param"
					mode="list-content"/>
			</ul>
		</li>
	</xsl:template>
	
	<xsl:template match="xsl:param|xsl:variable|xsl:import|xsl:include" mode="list"/>
	
	<xsl:template match="xsl:param|xsl:variable" mode="list-content">
		<xsl:variable name="id" select="cfn:node-id(.)"/>
		<li><a href="{concat('#', $id)}"><xsl:value-of select="@name"/></a></li>
	</xsl:template>
	
	<xsl:template match="xsl:import|xsl:include" mode="list-content">
		<xsl:variable name="id" select="cfn:node-id(.)"/>
		<li><a href="{concat('#', $id)}"><xsl:value-of select="@href"/></a></li>
	</xsl:template>
	
	<xsl:template match="xsl:template" mode="list-content">
		<xsl:variable name="id" select="cfn:node-id(.)"/>
		<li><a href="{concat('#', $id)}"><xsl:apply-templates select="@match|@name" mode="list"/></a></li>
	</xsl:template>
	
</xsl:stylesheet>
