<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="tester"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

	<p:input port="params" kind="parameter" primary="true"/>
	
    <p:input port="source" primary="true"/>
	
    <p:output port="result">
    	<p:pipe port="result" step="transformer"/>
    </p:output>
	
	<p:xslt name="transformer">
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
					<xsl:param name="foo"/>
					<xsl:template match="/">
						<foo><xsl:value-of select="$foo"/></foo>
					</xsl:template>
				</xsl:stylesheet>
			</p:inline>
		</p:input>
	</p:xslt>
	
	
    
</p:declare-step>