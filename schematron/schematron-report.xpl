<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="do-schematron"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">

	<!--	This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see http://www.gnu.org/licenses/.
	
	If your organisation or company are a customer or client of Corbas Consulting Ltd you may
	be able to use and/or distribute this software under a different license. If you are
	not aware of any such agreement and wish to agree other license terms you must
	contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. -->
	
    <p:input port="source" primary="true"/>
    <p:input port="schema" primary="false" />
    <p:output port="result"/>
    
    <p:option name="output-path" select="'file:///tmp'" required="false"/>
    <p:option name="output-file-root" select="'schematron'" required="false"/>

    <p:variable name='output-uri' select="concat($output-path, '/', $output-file-root, '-report.html')"/>

    <p:xslt name="schematron-includes" version="2.0">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="source">
            <p:pipe port="schema" step="do-schematron"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="base/iso_dsdl_include.xsl"/>
        </p:input>
    </p:xslt>

    <p:xslt name="schematron-abstract" version="2.0">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="source">
            <p:pipe port="result" step="schematron-includes"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="base/iso_abstract_expand.xsl"/>
        </p:input>
    </p:xslt>


    <p:xslt version="2.0" name="schematron-xsl">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="source">
            <p:pipe port="result" step="schematron-abstract"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="base/iso_svrl_for_xslt2.xsl"/>
        </p:input>
    </p:xslt>
	
    <p:xslt version="2.0" name="validate">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="stylesheet">
            <p:pipe port="result" step="schematron-xsl"/>
        </p:input>
        <p:input port="source">
            <p:pipe port="source" step="do-schematron"/>
        </p:input>
    </p:xslt>
	
	<p:store name="store-svrl" href="/tmp/reporter.svrl">
		<p:input port="source">
			<p:pipe port="result" step="validate"/>
		</p:input>
	</p:store>

    <p:xslt version="2.0" name="create-reporter-stylesheet">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="create-svrl-html-reporter.xsl"/>
        </p:input>
        <p:input port="source">
            <p:pipe port="result" step="validate"/>
        </p:input>
        <p:with-param name='report-title' select="concat('Report on: ', $output-file-root)"/>
        
    </p:xslt>
    
    <p:store name="write-reporter-stylesheet" href="/tmp/reporter.xsl">
        <p:input port="source">
            <p:pipe port="result" step="create-reporter-stylesheet"/>
        </p:input>
    </p:store>

     <p:xslt version="2.0" name="run-reporter-stylesheet">
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="stylesheet">
            <p:pipe port="result" step="create-reporter-stylesheet"/>
        </p:input>
        <p:input port="source">
            <p:pipe port="source" step="do-schematron"/>
        </p:input>
    </p:xslt>

    <p:store encoding="UTF-8" name='store-doc'>
        <p:input port="source">
            <p:pipe port="result" step="run-reporter-stylesheet"/>
        </p:input>
        <p:with-option name="href" select="$output-uri"/>
        <p:with-option name="omit-xml-declaration" select="'false'"/>
    </p:store>
    
    <p:exec name="run-browser">
        <p:input port="source">
            <p:pipe port="result" step="store-doc"/>
        </p:input>
        <p:with-option name="command" select="'/usr/bin/open'"/>
        <p:with-option name="args" select="$output-uri"/>
        <p:with-option name="result-is-xml" select="'false'"/>
        <p:with-option name="source-is-xml" select="'false'"/>
        <p:with-option name="wrap-result-lines" select="'false'"/>
    </p:exec>
    
    <p:sink>
        <p:input port="source">
            <p:pipe port="result" step="run-browser"></p:pipe>
        </p:input>
    </p:sink>
    
    <p:identity name="final-output">
        <p:input port="source">
            <p:pipe port="result" step="run-reporter-stylesheet"/>
        </p:input>
    </p:identity>


</p:declare-step>
