<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
    name="rec-load-test"
    version="1.0">
	
	<p:output port="result" primary="true"/>
	
    <p:input port="source">
    	<p:inline>
    		<doc xmlns="http://temp.com/"><p>Foo</p></doc>
    	</p:inline>
    </p:input>
	
	<p:input port="manifest">
		<p:document href="manifest-001.xml"/>
	</p:input>
	
	
	<p:import href="../../../xproc/recursive-xslt.xpl"/>
	<p:import href="../../../xproc/load-sequence-from-file.xpl"/>

	<ccproc:load-sequence-from-file name="load-xslt">
		<p:input port="source">
			<p:pipe port="manifest" step="rec-load-test"/>
		</p:input>
	</ccproc:load-sequence-from-file>
	
	<ccproc:recursive-xslt>
		<p:input port="source">
			<p:pipe port="source" step="rec-load-test"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="load-xslt"/>
		</p:input>
	</ccproc:recursive-xslt>
	
	<p:identity/>
		
		
</p:declare-step>