<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
	xmlns:data="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:cfunc="http://www.corbas.co.uk/ns/functions" xmlns:cword="http://www.corbas.co.uk/ns/word"
	xpath-default-namespace="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns="http://www.w3.org/1999/XSL/TransformAlias"
	exclude-result-prefixes="doc cfunc xsd data axsl" version="2.0">
	
	<doc:title>Build Mapping Stylesheet</doc:title>

	<doc:documentation scope="global">
		<p xmlns="http://www.w3.org/1999/xhtml">This stylesheet is used to read a mapping file (as
			defined by <code>mapping.rng</code> and convert it to an XSLT stylesheet that can be
			used to read an incoming XML file, read given elements and write out new ones. </p>
		<p>The script is part of the Word to XML mapping toolkit and run as part of that pipeline.
			It is intended to run after the Word document has been converted to elements in the
			output XML language but not structured. In general, word paragraphs are mapped to output
			language paragraphs unless they are tables, images or lists. These paragraphs are then
			refined as appropriate by the output of this stylesheet. See the documentation for
				<code>mapping.rng</code> for details on the definitions used.</p>


		<p xmlns="http://www.w3.org/1999/xhtml">The main output of this stylesheet is driven by
			three pairs of templates. Each produces a new template. Three of these generate
			templates to suppress their input, three generate templates to transform their input to
			the mapping defined output. There is a pair for each of the options provided by the
			mapping schema (full match, prefix match and suffix match).</p>

		<p xmlns="http://www.w3.org/1999/xhtml">Copyright Corbas Consulting Ltd 2012-13. <a
				rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"
					><img alt="Creative Commons License" style="border-width:0"
					src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png"/></a><br/>This work
			is licensed under a <a rel="license"
				href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons
				Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.</p>
	</doc:documentation>

	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

	<!-- We need to create content in the axsl namespace to avoid collisions
	 	and then output it in the XSLT namespace. The namespace-alias does
	 	this for us -->
	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

	<doc:documentation scope="variable">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code class="variable">source-element</code>
			variable defines the element to be searched for in the incoming XML file. This is
			defined by the <code class="attribute">source-element</code> attribute of the <code
				class="element">map</code> element.</p>
	</doc:documentation>
	<xsl:variable name="source-element" select="/map/@source-element"/>


	<doc:documentation scope="variable">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code class="variable">source-attribute</code>
			variable defines the name of attribute on input elements that contains the search
			values. This is defined by the <code class="attribute">source-attribute</code> attribute
			of the <code class="element">map</code> element.</p>
	</doc:documentation>
	<xsl:variable name="source-attribute" select="/map/@source-attribute"/>

	<doc:documentation scope="variable">
		<p xmlns="http://www.w3.org/1999/xhtml">The <code class="variable">target-attribute</code>
			variable defines the name of an attribute on output elements to be generated (when the
			mapping contains a <code class="attribute">target-attribute-value</code> attribute. This
			is defined by the <code class="attribute">target-attribute</code> attribute of the <code
				class="element">map</code> element.</p>
	</doc:documentation>
	<xsl:variable name="target-attribute" select="/map/@target-attribute"/>

	<doc:documentation scope="template">
		<p xmlns="http://www.w3.org/1999/xhtml">This template matches the <code class="element"
				>map</code> elements of the input and creates the stylesheet element for output. We
			set the default XPath namespace to the matching namespace to make the constructed XPath
			statements simpler. We include an identity transform as any element not processed by our
			constructed stylesheet must be passed through unchanged. We do force the output to be
			UTF-8 regardless of input.</p>
	</doc:documentation>

	<xsl:template match="map" as="element()">
		<axsl:stylesheet xpath-default-namespace="{@ns}" version="2.0">
			<xsl:namespace name="" select="@ns"/>
			<axsl:output method="xml" encoding="UTF-8"/>

			<axsl:template match="@*|node()" mode="#all">
				<axsl:copy>
					<axsl:apply-templates select="@*|node()" mode="#current"/>
				</axsl:copy>
			</axsl:template>

			<!-- process all the mapping elements. -->
			<xsl:apply-templates/>

		</axsl:stylesheet>
	</xsl:template>

	<doc:documentation xml:id="mapping-templates" label="Mapping Templates">
		<p xmlns="http://www.w3.org/1999/xhtml">These templates convert a <code class="element"
				>mapping</code> element to an <code class="element">xsl:template</code> element.
			Each one processes a variant on the input. The operation is the same on each. A function
			is called to generate the XPath statement for the template and then <code
				class="template">generate-elements</code>is called. <code class="template"
				>generate-elements</code> is passed a sequence of elements to create and a flag
			indicating that the process is starting.</p>
		<p xmlns="http:/www.w3.org/1999/xhtml">The suppress attribute is handled by a simple
			template for each type of input attribute. template.</p>
	</doc:documentation>

	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value][@suppress='true']" priority="1" as="element()">
		<axsl:template match="{cfunc:source-value(@source-value)}"/>
	</xsl:template>

	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value]" as="element()">

		<axsl:template match="{cfunc:source-value(@source-value)}">
			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>

	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value-prefix][@suppress='true']" priority="1"
		as="element()">
		<axsl:template match="{cfunc:source-value-prefix(@source-value-prefix)}"/>
	</xsl:template>

	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value-suffix]">
		<axsl:template match="{cfunc:source-value-suffix(@source-value-suffix)}" as="element()">
			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>


	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value-suffix][@suppress='true']" priority="1"
		as="element()">
		<axsl:template match="{cfunc:source-value-suffix(@source-value-suffix)}"/>
	</xsl:template>

	<doc:documentation ref="mapping-templates"/>
	<xsl:template match="mapping[@source-value-prefix]" as="element()">
		<axsl:template match="{cfunc:source-value-prefix(@source-value-prefix)}">

			<xsl:call-template name="generate-elements">
				<xsl:with-param name="element-list" select="tokenize(@target-element, '\s+')"/>
				<xsl:with-param name="top-level" select="true()"/>
			</xsl:call-template>
		</axsl:template>
	</xsl:template>

	<doc:documentation xml:id="target-mapping-templates" label="Target Mapping Templates">
		<p xmlns="http://www.w3.org/1999/xhtml">These templates handle those situations where a
				<code class="attribute">target-attribute-value</code> attribute is set but not a
				<code class="attribute">target-element</code> attribute. In this case the original
			element is output but the attributes are manipulate by calling <code name="template"
				>target-atttributes</code>.</p>
	</doc:documentation>
	
	<doc:documentation ref="target-mapping-templates"/>
	<xsl:template match="mapping[@source-value-prefix][not(@target-element) and @target-attribute-value]"
		priority="2">
		<axsl:template match="{cfunc:source-value-prefix(@source-value-prefix)}">
			<axsl:copy>
				<xsl:call-template name="target-attributes"/>
				<xsl:apply-templates select="node()"/>
			</axsl:copy>
		</axsl:template>
	</xsl:template>


	<doc:documentation ref="target-mapping-templates"/>
	<xsl:template match="mapping[@source-value-suffix][not(@target-element) and @target-attribute-value]"
		priority="2">
		<axsl:template match="{cfunc:source-value-suffix(@source-value-suffix)}">
			<axsl:copy>
				<xsl:call-template name="target-attributes"/>
				<xsl:apply-templates select="node()"/>
			</axsl:copy>
		</axsl:template>
	</xsl:template>

	<doc:documentation ref="target-mapping-templates"/>
	<xsl:template match="mapping[@source-value][not(@target-element) and @target-attribute-value]"
		priority="2">
		<axsl:template match="{cfunc:source-value(@source-value)}">
			<axsl:copy>
				<xsl:call-template name="target-attributes"/>
				<xsl:apply-templates select="node()"/>
			</axsl:copy>
		</axsl:template>
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This function generates a XPath statement as a
			string used in the output to build the match string (with predicate) for the generated
			template. This function creates exact matches.</p>
	</doc:documentation>
	<xsl:function name="cfunc:source-value" as="xsd:string">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of
			select="concat($source-element, '[@', $source-attribute, ' = ''', $source-attrib, ''']')"
		/>
	</xsl:function>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This function generates a XPath statement as a
			string used in the output to build the match string (with predicate) for the generated
			template. This function creates prefix matches.</p>
	</doc:documentation>
	<xsl:function name="cfunc:source-value-prefix" as="xsd:string">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of
			select="concat($source-element, '[starts-with(@', $source-attribute, ',''', $source-attrib, ''')]')"
		/>
	</xsl:function>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This function generates a XPath statement as a
			string used in the output to build the match string (with predicate) for the generated
			template. This function creates suffix matches.</p>
	</doc:documentation>
	<xsl:function name="cfunc:source-value-suffix" as="xsd:string">
		<xsl:param name="source-attrib" as="xsd:string"/>
		<xsl:value-of
			select="concat($source-element, '[ends-with(@', $source-attribute, ', ''', $source-attrib, ''')]')"
		/>
	</xsl:function>


	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This template is the core of the stylesheet. It is
			called recursively to build the generated templates. Each call to this generates an
			element in the output and then recurses to call the next. The templates that initialise
			the process (above) tokenize the space separated list contained in the <code
				class="attribute">target-element</code> attribute of the input and passes it as the
				<code class="parameter">element-list</code> parameter. The first element name is
			taken from the resulting sequence and generated. When first called the <code
				class="param">top-level</code> attribute is set to a true value. This prompts the
			template to process the <code class="attribute">hint</code>, <code class="attribute"
				>heading-level</code> and <code class="attribute">target-attribute-value</code>
			attributes of the mapping. It additionally generates an <code class="element"
				>xsl:apply-templates</code> element to copy any id attributes over.</p>
		<p xmlns="http:/www.w3.org/1999/xhtml">Regardless of whether <code class="param"
				>top-level</code> is true, it then generates an <code class="element"
				>xsl:apply-templates</code> to copy all attributes except id attributes. This leads
			to most attributes being copied to all generated elements.</p>
		<p xmlns="http:/www.w3.org/1999/xhtml">The template then calls itself passing the
			unprocessed element names to the next recursion.</p>
	</doc:documentation>

	<xsl:template name="generate-elements" as="element()">
		<xsl:param name="element-list" as="xsd:string*"/>
		<xsl:param name="top-level" as="xsd:boolean"/>

		<xsl:choose>

			<!-- If there are no input elements in the sequence, create an apply-templates only - stop
				the recursion -->
			<xsl:when test="count($element-list) = 0">
				<axsl:apply-templates select="node()"/>
			</xsl:when>

			<xsl:otherwise>

				<!-- Generate a literal element -->
				<xsl:element name="{$element-list[1]}" namespace="{/map/@ns}">

					<!-- If top level, process mapping attributes and generate an apply-templates
						for the input ID attributes (if any) -->
					<xsl:if test="$top-level = true()">
						<xsl:apply-templates select="@hint|@heading-level"/>
						<axsl:apply-templates select="@*[local-name() = 'id']"/>
					</xsl:if>

					<!-- 
						
					Generate an apply-templates for the non-id attributes 
					
					The code to generate target-attribute and target-attribute-value results is very
					complex if we choose to an apply-templates because we would need to sometimes
					suppress the input attribute and sometimes not (depending on whether source-attribute
					and target-attribute where the same). It's easier to check here and call a template
					specialised to the purpose than to write another set of xsl:apply-templates generators -->
					<xsl:call-template name="target-attributes"/>

					<!-- Recursing passing the tail of the sequence and setting top-level to false -->
					<xsl:call-template name="generate-elements">
						<xsl:with-param name="element-list" select="subsequence($element-list, 2)"/>
						<xsl:with-param name="top-level" select="false()"/>
					</xsl:call-template>

				</xsl:element>

			</xsl:otherwise>

		</xsl:choose>

	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This template processes the <code class="attribute"
				>target-attribute</code> and <code class="attribute">target-attribute-value</code>
			attributes and generates the appropriate <code class="element">xsl:attribute</code>
			elements on the output.</p>
		<p xmlns="http://www.w3.org/1999/xhtml">If the attributes are not set, simply generates an
				<code class="template">xsl:apply-templates</code> element and returns. If they are
			both set, it generates the output attribute and suppresses it from the input if both
				<code class="attribute">source-attribute</code> and <code class="attribute"
				>target-attribute</code> are the same.</p>
	</doc:documentation>
	<xsl:template name="target-attributes">
		<xsl:choose>
			<!-- simple case - just output the apply-templates -->
			<xsl:when test="not(@target-attribute-value and $target-attribute)">
				<axsl:apply-templates select="@*[not(local-name() = 'id')]"/>
			</xsl:when>
			<xsl:when test="not($target-attribute = $source-attribute)">
				<!-- Not using select but the value might contain quotes -->
				<axsl:attribute name="{$target-attribute}">
					<xsl:value-of select="@target-attribute-value"/>
				</axsl:attribute>
				<axsl:apply-templates select="@*[not(local-name() = 'id')]"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- suppress the copying of @target-attribute if we are overwriting the value -->
				<axsl:attribute name="{$target-attribute}">
					<xsl:value-of select="@target-attribute-value"/>
				</axsl:attribute>
				<axsl:apply-templates
					select="@*[not(local-name() = 'id')][not(local-name(.) = '{$target-attribute}')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This template copies the <code class="attribute"
				>hint</code> attribute to a <code class="attribute">cword:hint</code> attribute on
			the output.</p>
	</doc:documentation>
	<xsl:template match="@hint">
		<xsl:attribute name="hint" namespace="http://www.corbas.co.uk/ns/word" select="."/>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This template copies the <code class="attribute"
				>heading-level</code> attribute to a <code class="attribute">cword:level</code>
			attribute on the output.</p>
	</doc:documentation>
	<xsl:template match="@heading-level">
		<xsl:attribute name="level" namespace="http://www.corbas.co.uk/ns/word" select="."/>
	</xsl:template>

	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This template generates an attribute using the value
			of <code class="attribute">target-attribute-value</code> and the name given by the value
			of the <code class="attribute">@target-attribute</code> from the <code class="element"
				>map</code> if and only if that attribute exists.</p>
	</doc:documentation>
	<xsl:template match="@target-attribute-value">
		<xsl:if test="/map/@target-attribute">
			<xsl:attribute name="{/map/@target-attribute}" select="."/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
