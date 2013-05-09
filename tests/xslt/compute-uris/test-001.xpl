<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="copy-files" type="epub:copy-files" xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:epub="http://www.corbas.co.uk/ns/epub"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:pxf="http://exproc.org/proposed/steps/file"
	
	
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	
	<p:input port="parameters" kind="parameter"/>
	
	<p:output port="result">
		<p:pipe port="result" step="compute-uris"/>
	</p:output>
	
	
	<p:xslt name="compute-uris">
		<p:input port="stylesheet">
			<p:document href="../../../epub/xslt/compute-epub-uris.xsl"></p:document>
		</p:input>
		<p:input port="source">
			<p:inline><c:param-set/></p:inline>
		</p:input>
		
		<p:with-param name="images-dir-name" select="'images'"/>
				<p:with-param name="xhtml-dir-name" select="'xhtml'"/>
		
		
	</p:xslt>
	

</p:declare-step>
