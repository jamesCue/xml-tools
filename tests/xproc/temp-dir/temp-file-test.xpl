<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:output port="result">
    	<p:pipe port="result" step="temp-file"/>
    </p:output>
	
	<p:import href="../../../xproc/temp-dir.xpl"/>
	
	<ccproc:temp-file name="temp-file"/>
    
</p:declare-step>