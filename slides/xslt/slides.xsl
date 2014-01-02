<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:p="http://www.corbas.co.uk/ns/presentations" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xpath-default-namespace="http://www.corbas.co.uk/ns/presentations"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xsl p xsi"
	version="2.0">

	<xsl:import href="../../xslt/verbatim.xsl"/>
	<xsl:param name="indent-elements" select="true()"/>
	<xsl:param name="suppress-ns-declarations-default" select="true()"/>
	<xsl:param name="supress-namespaces" select="('http://www.corbas.co.uk/ns/example')"/>

	<xsl:output name="file-as-text" method="text" encoding="utf-8"/>
	<xsl:output name="file-as-xml" method="xml" indent="yes" encoding="UTF-8"/>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation"/>

	<xsl:template match="presentation">
			<div class="deck-container">
			<xsl:apply-templates select="title"/>
			<xsl:apply-templates select="* except title"/>
		</div>
	</xsl:template>
	
	<xsl:template match="presentation[not(parent::presentation)][not(presentation)]">
		<div class="deck-container">
			<xsl:apply-templates select="title"/>
			<xsl:if test="not(@toc='exclude')"><xsl:apply-templates select="." mode="toc"/></xsl:if>
			<xsl:apply-templates select="* except title"/>
		</div>
	</xsl:template>
	

	<xsl:template match="presentation/presentation">
		<xsl:apply-templates mode="toc"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- div elements are used to generate tables of contents but otherwise
	do nothing -->
	<xsl:template match="div">
		<xsl:apply-templates select="title"/>
		<xsl:apply-templates select="." mode="toc"/>
		<xsl:apply-templates select="* except title"/>
	</xsl:template>
	
	<xsl:template match="presentation/title|div/title">
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<h1><xsl:value-of select="."/></h1>
		</article>
	</xsl:template>

	<xsl:template match="h:*/node()|h:*/@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="h:*">
		<xsl:element name="{local-name()}" namespace="{namespace-uri(.)}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<p xmlns="http://www.w3.org/1999/xhtml">Slides just contain elements which may or may not be
			processed. Apply templates to the lot.</p>
	</documentation>

	<xsl:template match="slide[@type = 'html' or not(@type)]">
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<xsl:apply-templates select="node()"/>
		</article>
	</xsl:template>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type markdown should have had their content converted to html by this point
			so we just copy them to the output</h:p>
	</documentation>

	<xsl:template match="markdown">
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<xsl:copy-of select="node()"/>
		</article>
	</xsl:template>


	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type text are just wrapped in an article and treated as preformmatted
			text.</h:p>
	</documentation>

	<xsl:template match="text">
		<pre><xsl:value-of select="."/></pre>
	</xsl:template>
	
	<documentation xmlns="http://wwww.corbas.co.uk/ns/documentation">
		<h:p>Process code nodes where the content is referenced via an href</h:p>
	</documentation>
	<xsl:template match="code[@href]" priority="2">
		<xsl:variable name="inserted">		
			<p:code disposition='embed'>
				<xsl:copy-of select="@* except @href|document(@href)/*"/>
			</p:code>
		</xsl:variable>	
		<xsl:apply-templates select="$inserted"/>
	</xsl:template>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type code with a subtype of xml or xhtml are passed through the verbatim
			processor.</h:p>
	</documentation>

	<xsl:template match="code[@type = ('xml', 'xhtml') or not(@type)][parent::slide or @disposition='embed']" priority="1">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<div class="{string-join(('code-sample verbatim-default', @class), ' ')}">
			<xsl:apply-templates select="$title"/>
			<xsl:apply-templates select="node() except $title" mode="code-block"/>
			<xsl:apply-templates select="@file-as"/>
		</div>
	</xsl:template>

	<xsl:template match="code[@type = ('xml', 'xhtml') or not(@type)][not(parent::slide)][not(@disposition='embed')]" priority="1">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<div class="code-sample">
				<xsl:apply-templates select="$title"/>
				<xsl:apply-templates select="node() except $title" mode="code-block"/>
				<xsl:apply-templates select="@file-as"/>
			</div>
		</article>
	</xsl:template>

	<xsl:template match="node()" mode="code-block">
		<div class="code-sample verbatim-default">
			<xsl:apply-templates select="." mode="verbatim">
				<xsl:with-param name="suppress-ns-declarations"
					select="if (ancestor-or-self::p:code[@show-ns-declarations]) then false() else true()"/>
				<xsl:with-param name="replace-entities"
					select="if (ancestor-or-self::p:code[@replace-entities]) then true() else false()"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>


	<xsl:template match="@file-as">
		 <p class="file-as">
			<a href="{.}">
				<xsl:value-of select="."/>
			</a>
		</p> 
	</xsl:template>


	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Other code is just passed through as predefined text</h:p>
	</documentation>
	<xsl:template match="code[not(parent::slide)]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<div class="code-sample">
				<xsl:apply-templates select="$title"/>
				<pre><code><xsl:copy-of select="node() except $title"/></code></pre>
			</div>
		</article>
	</xsl:template>


	<xsl:template match="code[parent::slide]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<div class="{string-join(('code-sample verbatim-default', @class), ' ')}">
			<xsl:apply-templates select="$title"/>
			<pre><code><xsl:apply-templates select="node() except $title" mode="code"/></code></pre>
		</div>
	</xsl:template>
	
	<xsl:template match="code/node()" mode="code">
		<xsl:call-template name="preformatted-output">
			<xsl:with-param name="text" select="replace(., '^\s+|\s+$', '', 'm')"/>	
		</xsl:call-template>
	
	</xsl:template>
	
	

	<xsl:template match="code[not(parent::p:slide)]/title">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>


	<!-- ignore notes elements in normal output -->
	<xsl:template match="notes"/>

	<!-- ignore *ANYTHING* with suppress set to true -->
	<xsl:template match="*[@suppress = ('always', 'html')]" priority="100" mode="#all"/>




	<!-- TABLES OF CONTENTS -->
	<xsl:template match="div[@toc='exclude']" mode="toc">
		<xsl:apply-templates select="div" mode="toc"/>
	</xsl:template>
	
	<xsl:template match="presentation" mode="toc">
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<xsl:choose>
				<xsl:when test="title">
					<h2><xsl:value-of select="title"/></h2>
				</xsl:when>
				<xsl:otherwise>
					<h2>Contents</h2>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:apply-templates select="slide|div" mode="toc-title"/>
			</ul>
		</article>
	</xsl:template>
	
	
	<xsl:template match="div" mode="toc">
		<article class="{string-join(('slide', @class), ' ')}"
			id="{(@xml:id, @id, generate-id())[1]}">
			<xsl:choose>
				<xsl:when test="title">
					<h2><xsl:value-of select="title"/></h2>
				</xsl:when>
				<xsl:otherwise>
					<h2>Contents</h2>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:apply-templates select="slide" mode="toc"/>
			</ul>
		</article>
	</xsl:template>
	
	<xsl:template match="slide[@toc='exclude']" mode="toc" priority="1.5"/>
	
	<xsl:template match="slide[h:h1 or h:h2]" mode="toc">
		<li><a href="#{(@xml:id, @id, generate-id(.))[1]}"><xsl:apply-templates select="h:h1|h:h2" mode="toc"></xsl:apply-templates></a></li>
	</xsl:template>
	
	<xsl:template match="h:h1" mode="toc">
		<!-- deliberately suppress any formatting in header -->
		<strong><xsl:value-of select="."/></strong>
	</xsl:template>

	<xsl:template match="h:h2" mode="toc">
		<!-- deliberately suppress any formatting in header -->
		<xsl:value-of select="."/>
	</xsl:template>
	
	<!-- Presentation TOC titles -->
	<xsl:template match="slide" mode="toc-title">
		<xsl:apply-templates select="." mode="toc"/>
	</xsl:template>
	
	<xsl:template match="div[title]" mode="toc-title">
		<li><a href="#{(title/@xml:id, generate-id(title))[1]}"><xsl:value-of select="title"/></a></li>
	</xsl:template>
	

	

</xsl:stylesheet>
