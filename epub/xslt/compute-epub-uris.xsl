<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs doc cfunc"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cfunc="http://www.corbas.co.uk/ns/functions"
	version="2.0">
	
	<doc:documentation scope="global">
		<p xmlns="http://www.w3.org/1999/xhtml">This stylesheet uses the
			parameters provided to create a list of uris for use in EPUB
			files. The output is generated as a c:param-set element
			ready to be used as parameters.</p>
	</doc:documentation>
	
	<doc:documentation xml:id="dir-parameters" label="Directory Parameters" scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">These parameters are used to generate the
		uri names for the EPUB generator. URIs for use in xhtml files and for use in package and toc files
		are created.</p>
		<p>Note that the xhtml directory name is ignored if 'xhtml-at-top' is set to 'true'.</p>
	</doc:documentation>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="xhtml-dir-name" select="'.'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="style-dir-name" select="'styles'"/>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="image-dir-name" select="'images'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="font-dir-name" select="'fonts'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="xhtml-at-top" select="'false'"/>
	
	<doc:documentation>
		<p xmls="http:/www.w3.org/1999/xhtml">Creates a set of c:param entries to be
			used in the EPUB generator.</p>
		<p>The list of URIs generated is:</p>
		<dl>
			<dt>xhtml-style-uri</dt>
			<dd>The relative url path from an xhtml file to the css directory</dd>
			<td>xhtml-image-uri</td>
			<dd>The relative url path from an xhtml file to the images directory</dd>
			<td>package-xhtml-uri</td>
			<dd>The relative url path from the package file to the xhtml directory</dd>
			<td>package-style-uri</td>
			<dd>The relative url path from the package file to the styles directory</dd>
			<td>package-font-uri</td>
			<dd>The relative url path from the package file to the styles directory</dd>
			<td>package-images-uri</td>
			<dd>The relative url path from the package file to the images directory</dd>
		</dl>
	</doc:documentation>	
	
	<xsl:template match="/" as="element()">
		
		<c:param-set>
			<xsl:choose>
				<xsl:when test="$xhtml-at-top = 'true'">		<!-- string because XProc uses them -->
					<c:param name="xhtml-style-uri" value="{concat($style-dir-name, '/')}"/>
					<c:param name="xhtml-image-uri" value="{concat($image-dir-name, '/')}"/>
					<c:param name="package-xhtml-uri" value="'./'"/>	
				</xsl:when>
				<xsl:otherwise>
					<c:param name="xhtml-style-uri" value="{concat('../', $style-dir-name, '/')}"/>
					<c:param name="xhtml-image-uri" value="{concat('../', $image-dir-name, '/')}"/>
					<c:param name="package-xhtml-uri" value="{concat($xhtml-dir-name, '/')}"/>	
				</xsl:otherwise>
			</xsl:choose>
			
			<c:param name="package-style-uri" value="{concat($style-dir-name, '/')}"/>
			<c:param name="package-image-uri" value="{concat($image-dir-name, '/')}"/>
			<c:param name="package-font-uri" value="{concat($font-dir-name, '/')}"/>
			
		</c:param-set>
	</xsl:template>

	
</xsl:stylesheet>