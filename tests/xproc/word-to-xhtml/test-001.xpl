<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="rec-test"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
    version="1.0">
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="convert"/>
	</p:output>
	
	<p:input port="parameters" kind="parameter" primary="true"/>
	
	<p:import href="../../../msword/xproc/word2db.xpl"/>
	
	<ccproc:word-to-xml name="convert">
		<p:input port="manifest">
			<p:document href="../../../msword/config/word-to-xhtml5-manifest.xml"/>
		</p:input>
		<p:with-option name="package-url" select="p:resolve-uri('./test-001.docx')"/>
	</ccproc:word-to-xml>
		
		
</p:declare-step>