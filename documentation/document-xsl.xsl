<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:h="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs doc cfn h xsl db" xmlns:db="http://docbook.org/ns/docbook"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions" version="2.0">


	<xsl:import href="includes.xsl"/>
	<xsl:import href="../xslt/verbatim.xsl"/>

	<xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no"/>


	<!-- override some verbatim params -->
	<xsl:param name="limit-text" select="false()"/>
	<xsl:param name="indent-elements" select="true()"/>

	<xsl:param name="default-title">XSL Documentation</xsl:param>
	<xsl:param name="stylesheet">documentation.css</xsl:param>
	<xsl:param name="generate-verbatim" select="true()"/>



	<doc:documentation scope="parameter" xmlns="http://www.w3.org/1999/xhtml">
		<p>The see text should contain the text to be use for "See foobar" type references. The
			string '__replace__' will be replaced with the appropriate label text from the
			referenced documentation.</p>
	</doc:documentation>
	<xsl:param name="see-text" select="'See __replace__'"/>

	<doc:documentation scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code>xhtml-suffix</code> parameter defines the
			suffix used on output files for <code>xsl:include</code> and <code>xsl:import</code>
			statements.</p>
	</doc:documentation>
	<xsl:param name="xhtml-suffix" select="'xhtml'"/>


	<doc:documentation xmlns="http://www.w3.org/1999/xhtml" scope="variable">
		<p>We load the stylesheet into the styles variable so that we can insert it directly
		into the code. This causes fewer issues with it being in the right place but might
		cause problems with @import, etc. Needs to be reviewed.</p>
	</doc:documentation>
	<xsl:variable name="styles" select="unparsed-text($stylesheet)"/>

	<doc:documentation xmlns="http://www.w3.org/1999/xhtml" scope="template">
		<p>This template forces an abort if documentation contains anything except
		xhtml. This should be overridden if </p>
	</doc:documentation>
	<xsl:template match="/">

		<xsl:if
			test="//doc:documentation//*[not(namespace-uri(.) = 'http://www.w3.org/1999/xhtml')]">

			<xsl:variable name="not-html"
				select="//doc:documentation//*[not(namespace-uri(.) = 'http://www.w3.org/1999/xhtml')][1]"/>
			<xsl:message terminate="yes">Override this template to process content in any namespace
				other than http://www.w3.org/1999/xhtml. Found documentation in the '<xsl:value-of
					select="namespace-uri($not-html)"/>' namespace.</xsl:message>
		</xsl:if>

		<xsl:apply-templates select="xsl:stylesheet"/>
	</xsl:template>

	<xsl:template match="h:*" mode="#all">
		<xsl:element name="{local-name()}" namespace="{namespace-uri(.)}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="h:*/@*|h:*/text()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="db:*">
		<xsl:message terminate="yes">DocBook elements not allowed.</xsl:message>
	</xsl:template>

	<xsl:template match="xsl:stylesheet">

		<!-- set up some groups of nodes -->
		<xsl:variable name="element-match-templates"
			select="xsl:template[@match][not(starts-with(@match,'@'))][not(@match = ('processing-instruction()', 'comment()', 'text()'))]"/>
		<xsl:variable name="attribute-match-templates"
			select="xsl:template[@match][starts-with(@match, '@')]"/>
		<xsl:variable name="other-match-templates"
			select="xsl:template[@match][not(@match = $element-match-templates/@match)][not(@match = $attribute-match-templates/@match)]"/>
		<xsl:variable name="named-templates" select="xsl:template[not(@match)][@name]"/>
		<xsl:variable name="functions" select="xsl:function"/>
		<xsl:variable name="match-templates"
			select="($element-match-templates, $attribute-match-templates, $other-match-templates)"/>

		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>
					<xsl:call-template name="insert-title"/>

				</title>
				<style type="text/css">
					<xsl:value-of select="$styles"/>
				</style>
			</head>

			<body>

				<h1 class="doc-title">
					<xsl:call-template name="insert-title"/>
				</h1>

				<div class="global-docs">
					<xsl:apply-templates select="doc:documentation[@scope='global']"/>
				</div>

				<xsl:if test="xsl:import|xsl:include">
					<xsl:call-template name="process-inclusions"/>
				</xsl:if>

				<xsl:if test="$match-templates">
					<div class="matching-templates">
						<h2>Matching Templates</h2>

						<xsl:for-each-group select="$match-templates" group-by="@match">
							<xsl:variable name="cg" select="current-group()"/>
							<xsl:choose>
								<xsl:when test="count($cg) gt 1">
									<div class="match-group">
										<!-- context node set to first item in group -->
										<xsl:apply-templates select="@match" mode="grouped"/>
										<xsl:apply-templates select="$cg">
											<xsl:sort select="@mode"/>
										</xsl:apply-templates>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$cg"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each-group>

					</div>
				</xsl:if>

				<xsl:if test="$named-templates">
					<div class="named-templates section">
						<h2>Named Templates</h2>
						<!-- handled named and matching templates as matching -->
						<xsl:apply-templates select="$named-templates"/>
					</div>
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
		<div class="documentation" id="{generate-id()}">
			<xsl:apply-templates/>
		</div>
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
			<!-- sequence important -->
			<xsl:apply-templates select="(@xml:id, @label, *)"/>
		</div>

	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Map <code class="attribute">@xml:id</code>
			attributes on documentation to html <code class="attribute">id</code> attributes</p>
	</doc:documentation>
	<xsl:template match="doc:documentation/@xml:id">
		<xsl:attribute name="id" select="."/>
	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Map <code class="attribute">@label</code> attributes
			on documentation to html <code class="element">h4</code> elements</p>
	</doc:documentation>
	<xsl:template match="doc:documentation/@label">
		<h4 class="doc-label">
			<xsl:value-of select="."/>
		</h4>
	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">When a documentation node references another rather
			than having content, output a 'see' message.</p>
	</doc:documentation>
	<xsl:template match="doc:documentation[@ref]">

		<xsl:if test="not(//doc:documentation[@xml:id = current()/@ref])">
			<xsl:message terminate="yes">Unable to find referenced documentation with id
					'<xsl:value-of select="@ref"/>'. </xsl:message>
		</xsl:if>

		<!-- Get the documentation node -->
		<xsl:variable name="ref-node" select="//doc:documentation[@xml:id = current()/@ref]"/>


		<!-- If there are xsl node of the same type as the current node
				between the current node and the documentation then we need
				to put in the see message -->
		<xsl:if test="preceding-sibling::*[local-name(.) eq local-name(current())][. >> $ref-node]">
			<div class="documentation">
				<h4 class="see-ref">
					<a href="#{@ref}">
						<xsl:value-of select="replace($see-text, '__replace__', $ref-node/@label)"/>
					</a>
				</h4>
			</div>
		</xsl:if>
	</xsl:template>

	<doc:documentation xml:id="templates" label="xsl:template">
		<p xmlns="http://www.w3.org/1999/xhtml">Process templates with a match attribute.</p>
	</doc:documentation>
	<xsl:template match="xsl:template[@match][not(@xsl:param)]">
			<xsl:apply-templates
			select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']" mode="shared-docs"/>
		<div class="element" id="{generate-id()}">
			<xsl:apply-templates select="@match|@mode"/>
			<xsl:apply-templates
				select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']"/>
			<xsl:apply-templates select="." mode="verbatim-xsl"/>
		</div>
	</xsl:template>

	<doc:documentation ref="templates"/>
	<xsl:template match="xsl:template[@match][xsl:param]">
		<xsl:apply-templates
			select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']" mode="shared-docs"/>
		<div class="element">
			<xsl:apply-templates select="@match|@mode"/>
			<xsl:apply-templates
				select="preceding-sibling::*[1][self::doc:documentation][not(@scope) or @scope ='template']"/>
			<xsl:apply-templates select="." mode="verbatim-xsl"/>
		</div>
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
		<p xmlns="http://www.w3.org/1999/xhtml">Create a verbatim copy of the XSLT if verbatim mode
			is enabled.</p>
	</doc:documentation>
	<xsl:template match="xsl:template|xsl:function" mode="verbatim-xsl">
		<xsl:if test="$generate-verbatim = true()">
			<div class="verbatim">
				<xsl:apply-templates select="." mode="verbatim"/>
			</div>
		</xsl:if>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Convert match attributes to titles. If there is a
			current group then we are group on mode and we do nothing</p>
	</doc:documentation>
	<xsl:template match="@match">
		<h3 class="match"> Template Matching «<xsl:value-of select="."/>» </h3>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Convert match attributes to titles in group
			context</p>
	</doc:documentation>
	<xsl:template match="@match" mode="grouped">
		<h3 class="match"> Templates Matching «<xsl:value-of select="."/>» </h3>
	</xsl:template>


	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Convert mode attributes to headings.</p>
	</doc:documentation>
	<xsl:template match="@mode">
		<h4 class="mode">Mode: «<xsl:value-of select="."/>»</h4>
	</xsl:template>


	<!-- Generate shared template docs if appropriate for context -->
	<xsl:template match="doc:documentation[@ref]" mode="shared-docs">

		<xsl:if test="not(//doc:documentation[@xml:id = current()/@ref])">
			<xsl:message terminate="yes">Unable to find referenced documentation with id
					'<xsl:value-of select="@ref"/>'. </xsl:message>
		</xsl:if>

		<!-- Get the documentation node -->
		<xsl:variable name="ref-node" select="//doc:documentation[@xml:id = current()/@ref]"/>

		<!-- If this node is the first in the document with the documentation reference,
				generate the documentation. If not, generate the reference. -->

		<xsl:if test="not(preceding-sibling::doc:documentation[@ref = current()/@ref])">
			<div class="documentation">
				<xsl:apply-templates select="$ref-node"/>
			</div>
		</xsl:if>


	</xsl:template>

	<xsl:template match="doc:documentation[not(@ref)]" mode="shared-docs"/>


	<!-- Included content -->

	<xsl:template name="process-inclusions">
		<h2>Imports and Includes</h2>
		<xsl:apply-templates select="xsl:import"/>
		<xsl:apply-templates select="xsl:include"/>
	</xsl:template>

	<xsl:template match="xsl:import">
		<xsl:variable name="included" select="doc(@href)"/>
		<div class="import">
			<xsl:apply-templates select="@href"/>
			<xsl:call-template name="list-inclusions">
				<xsl:with-param name="included" select="$included"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="xsl:include">
		<xsl:variable name="included" select="doc(@href)"/>
		<div class="include">
			<xsl:apply-templates select="@href"/>
			<xsl:call-template name="list-inclusions">
				<xsl:with-param name="included" select="$included"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a title for an imported file with link to
			the documentation file.</p>
	</doc:documentation>
	<xsl:template match="xsl:import/@href">
		<h3> Import <a href="cfn:filename(.)"><xsl:value-of select="."/></a>
		</h3>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a title for an included file with link to
			the documentation file.</p>
	</doc:documentation>
	<xsl:template match="xsl:include/@href">
		<h3> Include <a href="cfn:filename(.)"><xsl:value-of select="."/></a>
		</h3>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Lists the include/import statements found in an
			included file</p>
	</doc:documentation>
	<xsl:template name="list-inclusions">
		<xsl:param name="included"/>
		<div class="inclusion-list">
			<ul>
				<xsl:apply-templates select="$included//xsl:import|$included/xsl:include"
					mode="list"> </xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Generate a link to an included/imported xslt
			file.</p>
	</doc:documentation>
	<xsl:template match="xsl:import|xsl:include" mode="list"> </xsl:template>

	<!-- functions -->

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">Given an href (from an <code>xsl:include</code> or
				<code>xsl:import</code> statement generate the HTML file name for the
			documentation.</p>
	</doc:documentation>
	<xsl:function name="cfn:filename">
		<xsl:param name="href"/>
		<xsl:value-of select="replace($href, 'xslt?', $xhtml-suffix)"/>
	</xsl:function>

</xsl:stylesheet>
