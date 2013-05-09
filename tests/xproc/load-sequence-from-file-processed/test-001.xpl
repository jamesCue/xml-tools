<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"	
	name="test-load-001">
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="done"/>
	</p:output>
	
	<p:import href="../../../xproc/load-sequence-from-file.xpl"/>
	
	<p:load href="manifest-001.xml" name="loader"/>
	
	<ccproc:load-sequence-from-file>
		<p:input port="source">
			<p:pipe port="result" step="loader"/>
		</p:input>
	</ccproc:load-sequence-from-file>
	
	<p:wrap-sequence name="wrapit" wrapper="test-wrap"/>
	
	<p:identity name="done">
		<p:input port="source">
			<p:pipe port="result" step="wrapit"></p:pipe>
		</p:input>
	</p:identity>
	
</p:declare-step>