<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="test-001" xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:epub="http://www.corbas.co.uk/ns/epub"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:pxf="http://exproc.org/proposed/steps/file"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

	<p:output port="result">
		<p:pipe port="result" step="create-epub"/>
	</p:output>
	
	<p:import href="../../../epub/xproc/package-epub-lib.xpl"/>

	<epub:create-epub name="create-epub">
		
		<p:input port="compute-paths">
			<p:document href="../../../../xml-tools/epub/xslt/compute-epub-paths.xsl"/>
		</p:input>
		
		<p:input port="compute-uris">
			<p:document href="../../../../xml-tools/epub/xslt/compute-epub-uris.xsl"/>
		</p:input>
		
		<p:input port="compute-archive-name">
			<p:document href="../../../xsl/docbook-to-epub/epub-filename.xsl"/>
		</p:input>
		
		<p:input port="parameters">
			<p:document href="../../../data/epub-config.xml"/>
		</p:input>
		
		<p:with-option name="epub-path" select="'/Users/nicg/Projects/penguin/puk/tests/xproc/epub-filename/out/'"></p:with-option>
		
	</epub:create-epub>

</p:declare-step>
