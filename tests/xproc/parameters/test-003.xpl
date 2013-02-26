<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" name="main"
	version="1.0">
	
	<p:input port="p"/>
	
	<p:parameters name="params">
		<p:input port="parameters">
			<p:pipe step="main" port="parameters"/>
			<p:pipe step="main" port="p"/>
		</p:input>
	</p:parameters>
	
<!--	<p:xslt name="transform">
		<p:input port="source">
			<p:inline><bar/></p:inline>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="result" step="params"/>
		</p:input>
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
					<xsl:param name="bing"/>
					<xsl:template match="/"><foo><xsl:value-of select="$bing"/></foo></xsl:template>
				</xsl:stylesheet>
			</p:inline>
		</p:input>
	</p:xslt> -->
	
	 <p:identity>
		<p:input port="source">
			<p:pipe step="params" port="result"/>
		</p:input>
	</p:identity>
	
	</p:pipeline>