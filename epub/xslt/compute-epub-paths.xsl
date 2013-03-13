<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:db="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs db doc" xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:cfunc="http://www.corbas.co.uk/ns/functions"
	version="2.0">

	<doc:documentation scope="global">
		<p xmlns="http://www.w3.org/1999/xhtml">This stylesheet uses the parameters provided to
			create a list of paths to be created as part of the creation of an EPUB file. The input
			document is ignored.</p>
	</doc:documentation>

	<doc:documentation xml:id="dir-parameters" label="Directory Parameters" scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">These parameters are used to generate the path names
			for the EPUB generator. The root and content-dir parameters are concatenated with the
			others.</p>
		<p xmlns="http://www.w3.org/1999/xhtml">The path separator is defaulted to a forward slash.
			Any forward slashes in the input paths are converted to the current value of the path
			separator so that consistent configuration files can be created if needed.</p>

		<p xmlns="http://www.w3.org/1999/xhtml">The <code class="attribute">xhtml-at-top</code>
			parameter is used to determine if the xhtml dir name should be used or not.</p>
	</doc:documentation>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="root-path"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="content-dir-name" select="'OPS'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="xhtml-dir-name" select="'xhtml'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="style-dir-name" select="'styles'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="image-dir-name" select="'images'"/>

	<doc:documentation ref-="dir-parameters"/>
	<xsl:param name="font-dir-name" select="'fonts'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="path-separator" select="'/'"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="xhtml-at-top" select="'false'"/>

	<doc:documentation>
		<p xmls="http:/www.w3.org/1999/xhtml">Creates a set of c:param elements representing
			directories to be created.</p>
	</doc:documentation>
	<xsl:template match="/" as="element()">

		<xsl:if test="not($root-path)">
			<xsl:message terminate="yes">Root path name missing</xsl:message>
		</xsl:if>
		<xsl:if test="not($content-dir-name)">
			<xsl:message terminate="yes">Content directory name missing</xsl:message>
		</xsl:if>

		<c:param-set>
			
			<xsl:call-template name="create-path-name">
				<xsl:with-param name="param-name" select="'content-dir'"/>
			</xsl:call-template>
			
			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$image-dir-name"/>
				<xsl:with-param name="param-name" select="'image-dir'"/>
			</xsl:call-template>

			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$style-dir-name"/>
				<xsl:with-param name="param-name" select="'style-dir'"/>
			</xsl:call-template>

			<xsl:choose>
				<xsl:when test="$xhtml-at-top = 'true'">
					<xsl:call-template name="create-path-name">
						<xsl:with-param name="dir-name" select="''"/>
						<xsl:with-param name="param-name" select="'xhtml-dir'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="create-path-name">
						<xsl:with-param name="dir-name" select="$xhtml-dir-name"/>
						<xsl:with-param name="param-name" select="'xhtml-dir'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>


			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$font-dir-name"/>
				<xsl:with-param name="param-name" select="'font-dir'"/>
			</xsl:call-template>
		</c:param-set>
	</xsl:template>

	<doc:documentation>
		<p xmls="http:/www.w3.org/1999/xhtml">Create a path name by concatenating the root, the
			content directory and the directory name. Path components can be missing but
			the results may be unpredictable.</p>
	</doc:documentation>
	<xsl:template name="create-path-name">
		<xsl:param name="dir-name"/>
		<xsl:param name="param-name"/>

		<c:param name="{$param-name}"
			value="{cfunc:create-path-name($root-path, $content-dir-name, $dir-name)}"/>

	</xsl:template>

	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This function strips all trailing path separators
			off of the input (as Windows can get upset about doubled ones)</p>
	</doc:documentation>
	<xsl:function name="cfunc:strip-trailing">

		<xsl:param name="dir-name"/>
		<xsl:value-of
			select="replace(cfunc:convert-slashes($dir-name), concat($path-separator, '$'), '')"/>

	</xsl:function>

	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This function converts all forward slashes to the
			value of path-separator (which may be the same). Input paths may be using forward
		slashes whatever the output needs to be. We also convert doubled slashes to one.</p>
	</doc:documentation>
	<xsl:function name="cfunc:convert-slashes">
		<xsl:param name="input"/>
		<xsl:value-of select="replace($input, concat('[/', $path-separator, ']+'), $path-separator)"/>
	</xsl:function>

	<xsl:function name="cfunc:create-path-name">

		<xsl:param name="root"/>
		<xsl:param name="content"/>
		<xsl:param name="dir" select="''"/>

		<xsl:value-of
			select="cfunc:convert-slashes(concat(
				cfunc:strip-trailing($root-path), 
				$path-separator,
				cfunc:strip-trailing($content),
				$path-separator,
				cfunc:strip-trailing($dir),
				$path-separator
				))
		"/>

	</xsl:function>

</xsl:stylesheet>
