<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs doc cfunc"
	xmlns="http://docbook.org/ns/docbook" xpath-default-namespace="http://docbook.org/ns/docbook"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns:cword="http://www.corbas.co.uk/ns/word" xmlns:cfunc="http://www.corbas.co.uk/ns/functions"
	version="2.0">

	<doc:documentation scope="global">
		<p xmlns="http://www.w3.org/1999/xhtml">This stylesheet builds structure from unstructured
			input as part of Word to XML pipeline. This version of the stylesheet is built for
			conversion to DocBook. </p>
		<p xmlns="http://www.w3.org/1999/xhtml">It operates by processing elements that contain two
			additional attributes. The input document is part way through the conversion pipeline
			and the generated mapping stylesheet (see <span class="filename"
				>build-mapping-stylesheet.xsl</span> and <span class="filename">mapping.rng</span>)
			will have inserted <code class="attribute">cword:hint</code> and <code class="attribute"
				>cword:level</code> attributes into the content.</p>
		<p xmlns="http://www.w3.org/1999/xhtml">The stylesheet operates by finding the max title
		level (which corresponds to the lowest level title). The main template (process-titles)
		is then called recursively to convert the sequences of elements beginning with titles into
		sections. If the heading level matches that of part or chapter (defined in parameters below)
		the element created is part or chapter as appropriate. Otherwise, section elements are
		created.</p>
		
		<h2 xmlns="http://www.w3.org/1999/xhtml">Warning</h2>
		<p  xmlns="http://www.w3.org/1999/xhtml">If header levels increase by more than one at a
		time this stylesheet may produce incorrect output. This can be corrected by post-processing
		if required.</p>
		
		<p xmlns="http://www.w3.org/1999/xhtml">Copyright Corbas Consulting Ltd 2012. <a rel="license"
			href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img
				alt="Creative Commons License" style="border-width:0"
				src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png"/></a><br/>This work
			is licensed under a <a rel="license"
				href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons
				Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.</p>
		
	</doc:documentation>
	
	<doc:documentation scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">This parameter determines which cword:level parameter
		is considered to match parts. It must be less than that for chapters or unpredictable output
		will occur.</p>
	</doc:documentation>
	<xsl:param name="part-level" select="1"/>
	
	<doc:documentation scope="parameter"><p xmlns="http://www.w3.org/1999/xhtml">This parameter determines which cword:level parameter
		is considered to match chapters. Any higher numbers are considered to map to sections..</p></doc:documentation>
	
	<xsl:param name="chapter-level" select="2"/>

	<doc:documentation scope="variable"><p xmlns="http://www.w3.org/1999/xhtml">This variable identifies the highest
		level heading defined in the input. THis is used by process-titles to recursively create sections
		starting at the lowest level and working upwards.</p></doc:documentation>
	
	<xsl:variable name="max-title-level" select="max(//title[@cword:level]/@cword:level)"/>

	<xsl:include href="identity.xsl"/>

	<doc:documentation><p xmlns="http://www.w3.org/1999/xhtml">Matches the root element. Copies
	it to output and then calls process-titles to start the recursive processing.</p></doc:documentation>
	<xsl:template match="book">

		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:call-template name="process-titles"/>
		</xsl:copy>

	</xsl:template>

	<doc:documentation><p xmlns="http://www.w3.org/1999/xhtml">This template is called recursively to
	generate nested sections (part, chapter or section). It uses grouping against local element
	names to group elements starting with titles at the current level (defaulting to the
	highest number/lowest level heading). Groups which match are wrapped in the appropriate
	section type, others are copied to the output (we can use copy-of here because we work
	from the bottom up and know that higher level titles will be processed later).</p></doc:documentation>
	<xsl:template name="process-titles" as="node()*">

		<!-- Default the current processing level to the maximum value in the document. -->
		<xsl:param name="level" select="$max-title-level"/>
		
		<!-- If no content parameter is provided use the node() children of the current
			element -->
		<xsl:param name="content" select="node()" as="node()*"/>
		
		<!-- Store the result of our processing as sequence of nodes in a variable - we'll
			be using it again -->
		<xsl:variable name="result" as="node()*">

			<!-- group over the current content sequence, creating groups that start with
				titles at the current level -->
			<xsl:for-each-group select="$content" group-starting-with="title[@cword:level]">
				
				<xsl:choose>
					
					<!-- if we have a current level title based group, wrap it -->
					<xsl:when test="self::title[@cword:level] and @cword:level = $level">

						<xsl:element name="{cfunc:section-type(@cword:level, @cword:hint)}">
							
							<!-- copy all of the attributes of the current node - remember . is set
								to the first member of the current group bar the id -->
							<xsl:apply-templates select="@* except @xml:id"/>
							
							<!-- insert the whole group into our section -->
							<xsl:copy-of select="current-group()"/>
						</xsl:element>

					</xsl:when>
					
					<xsl:otherwise>

						<!-- copy to output without processing -->
						<xsl:copy-of select="current-group()"/>

					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:for-each-group>

		</xsl:variable>

		<!-- Once we have created sections around our title based groups, then we need to
			recurse if the current level is greater than one. If not, we return the 
			content. The content for the next level of the processing is the result
			from this one.-->
		<xsl:choose>

			<xsl:when test="$level gt 1">
				<xsl:call-template name="process-titles">
					<xsl:with-param name="level" select="$level - 1"/>
					<xsl:with-param name="content" select="$result"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:otherwise>

				<xsl:sequence select="$result"/>

			</xsl:otherwise>

		</xsl:choose>

	</xsl:template>

	<doc:documentation scope="function">
		<p xmlns="http:/www.w3.org/1999/xhtml">This function uses the level and the
		hint attributes of a title to determine what sort of section element should
		be generated in the output.</p>
	</doc:documentation>
	<xsl:function name="cfunc:section-type" as="xs:string">
		<xsl:param name="level"/>
		<xsl:param name="hint" as="xs:string"/>

		<xsl:choose>
			<!-- if the level is at part-level, it's a part -->
			<xsl:when test="$level = $part-level">
				<xsl:value-of select="'part'"/>
			</xsl:when>

			<!-- if the level is at chapter-level, check the hint-->
			<xsl:when test="$level = $chapter-level">
				<xsl:choose>
					<xsl:when test="contains($hint, 'prelims')">
						<xsl:value-of select="'preface'"/>
					</xsl:when>
					<xsl:when test="contains($hint, 'endmatter')">
						<xsl:value-of select="'appendix'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'chapter'"/>
					</xsl:otherwise>

				</xsl:choose>
			</xsl:when>

			<!-- fall back - it's a section -->
			<xsl:otherwise>
				<xsl:value-of select="'section'"/>
			</xsl:otherwise>

		</xsl:choose>

	</xsl:function>


</xsl:stylesheet>
