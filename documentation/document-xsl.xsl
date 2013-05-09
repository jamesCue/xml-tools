<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:h="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs doc db" xmlns:db="http://docbook.org/ns/docbook"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions"
	version="2.0">
	
	
	<xsl:import href='includes.xsl'/>
	

	<xsl:param name="default-title">XSL Documentation</xsl:param>
	<xsl:param name="stylesheet">https://files.corbas.co.uk/css/documentation.css</xsl:param>

	<doc:documentation scope="parameter" xmlns="http://www.w3.org/1999/xhtml">
		<p>The see text should contain the text to be use for
			"See foobar" type references. The string '__replace__' will be replaced with the
		appropriate label text from the referenced documentation.</p>
	</doc:documentation>
	<xsl:param name="see-text" select="'See __replace__'"/>
	
	<doc:documentation scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code>xhtml-suffix</code> parameter defines
			the suffix used on output files for <code>xsl:include</code> and <code>xsl:import</code>
			statements.</p>
	</doc:documentation>
	<xsl:param name="xhtml-suffix" select="'xhtml'"/>

	<xsl:template match="h:*|h:*/@*|h:*/node()" mode="#all">
		<xsl:copy>
			<xsl:copy-of select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:*">
		<xsl:message terminate="yes">DocBook elements not allowed.</xsl:message>
	</xsl:template>

	<xsl:template match="xsl:stylesheet">
		
		<html>
			<head><link rel="stylesheet" href="{$stylesheet}" type="text/css"/>
			<title>
				<xsl:call-template name="insert-title"/>
			</title></head>
			
			<body>
				
				<h1 class="doc-title">
					<xsl:call-template name="insert-title"/>
				</h1>
				<xsl:apply-templates select="doc:documentation[@scope='global']"/>
				
				<xsl:if test="xsl:import|xsl:include">
					<xsl:call-template name="process-inclusions"/>
				</xsl:if>
					

				<xsl:if test="xsl:template">
					
				</xsl:if>

			</body>
			
			
			
		</html>


	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Choose either the doc:title element or the default
			title.</p>
	</doc:documentation>
	<xsl:template name="insert-title">
		<xsl:choose>
			<xsl:when test="//doc:title">
				<xsl:apply-templates select="//doc:title"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$default-title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Process global documentation elements in the
			sequence that they occur in the input file. </p>
	</doc:documentation>
	<xsl:template match="doc:documentation[@scope='global']" priority="1">
		<section id="{generate-id()}">
			<xsl:apply-templates/>
		</section>
	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate an element for the name of a </p>
	</doc:documentation>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Output the documentation for any given component.
			This is pretty simple as we just copy html and fail miserably on anything else. If
			anything else bar HTML is used here, this template must be overridden. Documentation
			elements that reference others are processed separately.</p>
	</doc:documentation>
	<xsl:template match="doc:documentation[not(@ref)]">

		<div class="documentation">
			<xsl:choose>
				<xsl:when test="*[not(namespace-uri(.) = 'http://www.w3.org/1999/xhtml')]">
					<xsl:variable name="not-html"
						select="*[not(namespace-uri(.) = 'http://www.w3.org/1999/xhtml')][1]"/>
					<xsl:message terminate="yes">Override this template to process content in any
						namespace other than http://www.w3.org/1999/xhtml. Found documentation in
						the '<xsl:value-of select="namespace-uri($not-html)"/>'
						namespace.</xsl:message>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>

	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">When a documentation node references another rather
			than having content, output a 'see' message.</p>
	</doc:documentation>
	<xsl:template match="doc:documentation[@ref]">
		<div class="documentation">
			
			<xsl:if test="not(//doc:documentation[@xml:id = current()/@ref])">
				<xsl:message terminate="yes">Unable to find referenced documentation with id '<xsl:value-of select="@ref"/>'. </xsl:message>
			</xsl:if>
			
			<xsl:variable name="ref-node" select="//doc:documentation[@xml:id = current()/@ref]"/>
			
			<h4 class="see-ref"><a href="#{@ref}"><xsl:value-of select="replace($see-text, '__replace__', $ref-node/@label)"/></a></h4>
		
		</div>	
	</xsl:template>
	
	<doc:documentation xml:id="templates" label="xsl:template">
		<p xmlns="http://www.w3.org/1999/xhtml">Process templates with a match attribute.</p>
	</doc:documentation>
	<xsl:template match="xsl:template[@match][not(@xsl:param)]">
		<section id="{generate-id()}">
			<xsl:apply-templates select="@match|@mode"/>
			<xsl:apply-templates
				select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']"
			/>
		</section>
	</xsl:template>
	
	<doc:documentation ref="templates"/>
	<xsl:template match="xsl:template[@match][xsl:param]">
		<section>
			<xsl:apply-templates select="@match|@mode"/>
			<xsl:apply-templates
				select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']"
			/>
		</section>
	</xsl:template>
	
	<xsl:template match="xsl:template" mode="params">
		<table class="parameters">
			<thead>
				<tr>
					<th>Name</th>
					<th>Default</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="@param"/>
			</tbody>
		</table>
		
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Convert match attributes to titles.</p>
	</doc:documentation>
	<xsl:template match="@match">
		<h3 class="match"><xsl:value-of select='.'/></h3>
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Convert mode attributes to headings.</p>
	</doc:documentation>
	<xsl:template match="@mode">
		<h4 class="mode"><xsl:value-of select="."/></h4>
	</xsl:template>
	
	
	<!-- Included content -->
	
	<xsl:template name="process-inclusions">
		<h2>Imports and Includes</h2>
		<xsl:apply-templates select="xsl:import"/>
		<xsl:apply-templates select="xsl:include"/>
	</xsl:template>
	
	<xsl:template match="xsl:import">
		<xsl:variable name="included" select="doc(@href)"/>
		<section class="import">
			<xsl:apply-templates select="@href"/>
			<xsl:call-template name="list-inclusions">
				<xsl:with-param name="included" select="$included"/>
			</xsl:call-template>
		</section>
	</xsl:template>

	<xsl:template match="xsl:include">
		<xsl:variable name="included" select="doc(@href)"/>
		<section class="include">
			<xsl:apply-templates select="@href"/>
			<xsl:call-template name="list-inclusions">
				<xsl:with-param name="included" select="$included"/>
			</xsl:call-template>
		</section>
	</xsl:template>
		
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a title
		for an imported file with link to the documentation file.</p>
	</doc:documentation>
	<xsl:template match="xsl:import/@href">
		<h3>
			Import <a href="cfn:filename(.)"><xsl:value-of select="."/></a>
		</h3>
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a title
			for an included file with link to the documentation file.</p>
	</doc:documentation>
	<xsl:template match="xsl:include/@href">
		<h3>
			Include <a href="cfn:filename(.)"><xsl:value-of select="."/></a>
		</h3>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Lists the include/import
		statements found in an included file</p>
	</doc:documentation>
	<xsl:template name="list-inclusions">
		<xsl:param name="included"/>
		<div class="inclusion-list">
		<ul>
			<xsl:apply-templates select="$included//xsl:import|$included/xsl:include" mode="list">
				
			</xsl:apply-templates>
		</ul>
		</div>
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a link
		to an included/imported xslt file.</p>
	</doc:documentation>
	<xsl:template match="xsl:import|xsl:include" mode="list">
		
	</xsl:template>
	
	<!-- functions -->
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Given an href (from an
		<code>xsl:include</code> or <code>xsl:import</code> statement
		generate the HTML file name for the documentation.</p>
	</doc:documentation>
	<xsl:function name="cfn:filename">
		<xsl:param name="href"/>
		<xsl:value-of select="replace($href, 'xslt?', $xhtml-suffix)"/>
	</xsl:function>
	
</xsl:stylesheet>
