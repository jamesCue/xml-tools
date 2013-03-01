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
	
	<p:import href="../../../epub/xproc/epublib.xpl"/>

	<p:identity>
		<p:input port="source">
			<p:inline><dummy/></p:inline>
		</p:input>
	</p:identity>
	

</p:declare-step>
