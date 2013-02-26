<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="tester"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

	<p:input port="params" kind="document" primary="true"/>
	
    <p:input port="source">
        <p:inline>
            <doc>Hello world!</doc>
        </p:inline>
    </p:input>
    <p:output port="result">
    	<p:pipe port="result" step="namer"></p:pipe>
    </p:output>
	
	<p:variable name="frank" select="'sinatra'"/>
    
	<p:in-scope-names name="namer"/>
	
	
    
</p:declare-step>