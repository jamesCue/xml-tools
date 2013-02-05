<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="rec-test"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
    version="1.0">
	
	<p:output port="result" primary="true"/>
	
    <p:input port="source">
    	<p:inline>
    		<doc xmlns="http://temp.com/"><p>Foo</p></doc>
    	</p:inline>
    </p:input>
	
	
	
	<p:input port="ss1">
		<p:inline>
			<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
				<xsl:template match="/">
					<wrapper1  xmlns="http://temp.com/"><xsl:copy-of select="*"/></wrapper1>
				</xsl:template>
			</xsl:stylesheet>
		</p:inline>
	</p:input>
	
	<p:input port="ss2">
		<p:inline>
			<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
				<xsl:template match="/">
					<wrapper2  xmlns="http://temp.com/"><xsl:copy-of select="*"/></wrapper2>
				</xsl:template>
			</xsl:stylesheet>
		</p:inline>
	</p:input>
	
	<p:import href="recursive-xslt.xpl"/>
	
	<p:identity name="stylesheets">
		<p:input port="source">
			<p:pipe port="ss1" step="rec-test"/>
			<p:pipe port="ss2" step="rec-test"/>
		</p:input>
	</p:identity>
	
	<ccproc:recursive-xslt>
		<p:input port="source">
			<p:pipe port="source" step="rec-test"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="stylesheets"></p:pipe>
		</p:input>
	</ccproc:recursive-xslt>
	
	<p:identity/>
		
		
</p:declare-step>