<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="copy-files" type="epub:copy-files" xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:epub="http://www.corbas.co.uk/ns/epub"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:pxf="http://exproc.org/proposed/steps/file"
	
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	
	<p:input port="parameters" kind="parameter"/>
	
	<p:output port="result">
		<p:pipe port="result" step="create-paths"/>
	</p:output>
	
	<p:import href="../../../epub/xproc/tmp.xpl"/>
	
	<epub:create-paths name='create-paths'>
		<p:with-param name="root-path" select="p:resolve-uri('./tmp')"/>
		<p:with-param name="content-dir-name" select="'OPS/'"/>
		<p:with-param name="xhtml-dir-name" select="'xhtml'"/>
		<p:with-param name="images-dir-name" select="'images'"/>
		<p:with-param name="styles-dir-name" select="'styles'"/>
		<p:input port="compute-paths">
			<p:document href="/Users/nicg/Projects/penguin/puk/ms-word-to-epub/xsl/docbook-to-epub/compute-epub-paths.xsl"/>
		</p:input>
	</epub:create-paths> 
	

</p:declare-step>
