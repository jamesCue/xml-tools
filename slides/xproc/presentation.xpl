<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:pres="http://www.corbas.co.uk/ns/presentations" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:example="http://www.corbas.co.uk/ns/examples"
	version="1.0" name="create-presentation">

	<p:input port="source" primary="true"/>
	<p:input port="template"/>
	<p:input port="parameters" kind="parameter" primary="true"/>
	<p:output port="result" primary="true">
		<p:pipe port="result" step="set-title"/>
	</p:output>
	
	<p:option name="file-base" select="./"/>
	

	<p:serialization port="result" doctype-system="about:legacy-compat" method="xml"
		encoding="utf-8"/>

	<p:variable name="new-title" select="(/pres:presentation/pres:title,
		/pres:presentation/pres:slide//html:h1,
		pres:presentation/pres:slide//html:h2,
		'Presentation')[1]">
		<p:pipe port="source" step="create-presentation"/>
	</p:variable>
	
	<p:xslt name="replace-includes">
		<p:input port="source">
			<p:pipe port="source" step="create-presentation"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xslt/process-includes.xsl"/>
		</p:input>
	</p:xslt>
	


	<p:xslt name="format-slides">
		<p:input port="source">
			<p:pipe port="result" step="replace-includes"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xslt/slides.xsl"/>
		</p:input>
		<p:with-param name="wrap-filing" select="yes"/>
	</p:xslt>
	
	<p:for-each name="store-examples">
		
		<p:iteration-source select="//pres:code[@file-as]">
			<p:pipe port="result" step="replace-includes"/>
		</p:iteration-source>
		
		<p:variable name="uri" select="p:resolve-uri(/pres:code/@file-as, $file-base)"/>
		<p:variable name="as" select="if (/pres:code[@type] = ('xml', 'xhtml') or not(/pres:code[@type])) then 'xml' else 'text'"/>

		<p:delete match="pres:title"/>		
		<p:unwrap match="pres:code"/>
		
		<p:choose>
			<p:when test="$as = 'xml' and count(/pres:code/*) gt 1">
				<p:wrap wrapper="example:wrapper" match="/pres:code/*"/>
			</p:when>
			<p:otherwise>
				<p:identity/>
			</p:otherwise>
		</p:choose>
		
		<p:store encoding="UTF-8" omit-xml-declaration="false">
			<p:with-option name="href" select="$uri"/>
			<p:with-option name="method" select="$as"/>
		</p:store>
		
	</p:for-each>
	

	<p:replace match="//pres:content" name="wrap-up">
		<p:input port="source">
			<p:pipe port="template" step="create-presentation"/>
		</p:input>
		<p:input port="replacement">
			<p:pipe port="result" step="format-slides"/>
		</p:input>	
	</p:replace>
	

	<p:xslt name="set-title">

		<p:input port="source">
			<p:pipe port="result" step="wrap-up"/>
		</p:input>
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
					 xpath-default-namespace="http://www.w3.org/1999/xhtml">
					<xsl:param name="new-title"/>
					<xsl:template match="@*|comment()|processing-instruction()|text()">
						<xsl:copy>
							<xsl:apply-templates select="@*|node()"/>
						</xsl:copy>
					</xsl:template>
					<xsl:template match="*[prefix-from-QName(node-name(.))]">
						<xsl:element name="{name()}" namespace="{namespace-uri()}">
							<xsl:apply-templates select="@*|node()"/>
						</xsl:element>
					</xsl:template>

					<xsl:template match="*">
						<xsl:element name="{local-name()}" namespace="{namespace-uri()}">
							<xsl:apply-templates select="@*|node()"/>
						</xsl:element>
					</xsl:template>

					<xsl:template match="head/title">
						<title><xsl:value-of select="$new-title"/></title>
					</xsl:template>

				</xsl:stylesheet>
			</p:inline>
		</p:input>
		<p:with-param name="new-title" select="$new-title"/>

	</p:xslt>
	
	

</p:declare-step>
