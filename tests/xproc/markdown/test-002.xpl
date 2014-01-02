<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	name="test-002"
	>
	
	<p:input port="source">
		<p:inline>
			<slide xmlns="http://www.corbas.co.uk/ns/slides">
				<content/>
			</slide>
		</p:inline>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="test-replace"/>
	</p:output>
	
	<p:rename match="/*" name="test-replace" new-name="article" new-namespace="http://www.w3.org/1999/xhtml">
		<p:input port="source">
			<p:pipe port="source" step="test-002"></p:pipe>
		</p:input>
	</p:rename>
	
	
</p:declare-step>