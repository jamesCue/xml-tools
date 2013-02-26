<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:db="http://docbook.org/ns/docbook"
	exclude-result-prefixes="xs db doc"
	xmlns:doc="http://www.corbas.co.uk/ns/documentation"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cfunc="http://www.corbas.co.uk/ns/functions"
	version="2.0">
	
	<doc:documentation scope="global">
		<p xmlns="http://www.w3.org/1999/xhtml">This stylesheet uses the
			parameters provided to create a list of paths to be created
			as part of the creation of an EPUB file. The input document
		is ignored.</p>
	</doc:documentation>
	
	<doc:documentation xml:id="dir-parameters" label="Directory Parameters" scope="parameter">
		<p xmlns="http://www.w3.org/1999/xhtml">These parameters are used to generate the
		path names for the EPUB generator. The root and content-dir parameters are concatenated
		with the others.</p>
		<p xmlns="http:/www.w3.org/1999/xhtml">The path separator is defaulted to a forward
		slash. Any forward slashes in the input paths are converted to the current value of
		the path separator so that consistent configuration files can be created if needed.</p>
	</doc:documentation>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="root-path"/>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="content-dir-name"/>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="xhtml-dir-name"/>

	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="styles-dir-name"/>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="images-dir-name"/>
	
	<doc:documentation ref="dir-parameters"/>
	<xsl:param name="path-separator" select="'/'"/>
	
	<doc:documentation>
		<p xmls="http:/www.w3.org/1999/xhtml">Creates a set of c:dir elements as directories
			to be created.</p>
	</doc:documentation>	
	<xsl:template match="/" as="element()">
		
		<xsl:if test="not($root-path)"><xsl:message terminate="yes">Root path name missing</xsl:message></xsl:if>
		<xsl:if test="not($content-dir-name)"><xsl:message terminate="yes">Content directory name missing</xsl:message></xsl:if>
		
		<c:result>
			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$images-dir-name"/>
			</xsl:call-template>	
			
			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$styles-dir-name"/>
			</xsl:call-template>
			
			<xsl:call-template name="create-path-name">
				<xsl:with-param name="dir-name" select="$xhtml-dir-name"/>
			</xsl:call-template>
			
		</c:result>
	</xsl:template>
	
	<doc:documentation>
		<p xmls="http:/www.w3.org/1999/xhtml">Create a path name by concatenating the root, the content
		directory and the directory name. If any of these is empty, skip the directory.</p>
	</doc:documentation>
	<xsl:template name="create-path-name">
		<xsl:param name="dir-name"/>
		
		<xsl:if test="$root-path and $content-dir-name and $dir-name">
			<c:dir name="{cfunc:create-path-name($root-path, $content-dir-name, $dir-name)}"/>
		</xsl:if>
		
	</xsl:template>
	
	<doc:documentation>
		<p xmlns="http://www.w3.org/1999/xhtml">This function strips all trailing 
		path separators off of the input (as Windows can get upset about doubled
		ones)</p>
	</doc:documentation>
	<xsl:function name="cfunc:strip-trailing">
		
		<xsl:param name="dir-name"/>
		<xsl:value-of select="replace(cfunc:convert-slashes($dir-name), concat($path-separator, '$'), '')"/>
		
	</xsl:function>
	
	<doc:documentation>
		<p xmlns="http:/www.w3.org/1999/xhtml">This function converts all forward slashes
		to the value of path-separator (which may be the same).</p>
	</doc:documentation>
	<xsl:function name="cfunc:convert-slashes">
		<xsl:param name="input"/>
		<xsl:value-of select="replace($input, '/', $path-separator)"/>
	</xsl:function>
	
	<xsl:function name="cfunc:create-path-name">
		
		<xsl:param name="root"/>
		<xsl:param name="content"/>
		<xsl:param name="dir"/>
		
		<xsl:value-of select="concat(
				cfunc:strip-trailing($root-path), 
				$path-separator,
				cfunc:strip-trailing($content),
				$path-separator,
				cfunc:strip-trailing($dir)
				)
			
		"/>
		
		</xsl:function>
	
</xsl:stylesheet>