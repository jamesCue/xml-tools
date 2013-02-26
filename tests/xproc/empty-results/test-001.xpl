<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
	 name="tester">
    <p:input port="source">
        <p:inline>
            <doc>Hello world!</doc>
        </p:inline>
    </p:input>
	
	<p:input port="parameters" kind="parameter" primary="true"/>

	<p:output port="result">
    	<p:pipe port="result" step="t2"/>
    </p:output>
		
	<p:xslt>
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
					<xsl:template match="/">
						<xsl:result-document href="foox.xml">
							<xsl:copy-of select="."/>
						</xsl:result-document>
					</xsl:template>
				</xsl:stylesheet>
			</p:inline>
		</p:input>
		<p:input port="source">
			<p:pipe port="source" step="tester"/>
		</p:input>
	</p:xslt>
	
	<p:xslt name="t2">
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
					<xsl:template match="/">
						<xsl:copy-of select="."/>
					</xsl:template>
				</xsl:stylesheet>
			</p:inline>
		</p:input>
	</p:xslt>

</p:declare-step>