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
	<p:option name="pdf-uri" required="true"/>
	
	
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
			<p:document href="../xslt/slides-fo.xsl"/>
		</p:input>
	</p:xslt>
	
	
	<p:xsl-formatter name="convert-to-pdf">
		<p:input port="source">
			<p:pipe port="result" step="replace-includes"/>
		</p:input>
		<p:with-option name="href" select="$pdf-uri"></p:with-option>
	</p:xsl-formatter>

	
	

</p:declare-step>
