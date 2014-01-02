<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
    xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
   
    name="test-001"
	>
	
	<p:input port="source">
		<p:inline>
			<slide xmlns="http://www.corbas.co.uk/ns/slides">
## Simple title
				
* Item 1
				
* Item 2
				
Another paragraph here.
			</slide>
		</p:inline>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="test-markdown"/>
	</p:output>
	
	<p:import href="../../../xproc/process-markdown.xpl"/>
	
	<ccproc:process-markdown name="test-markdown">
		<p:input port="source">
			<p:pipe port="source" step="test-001"/>
		</p:input>
	</ccproc:process-markdown>
	
 
</p:declare-step>