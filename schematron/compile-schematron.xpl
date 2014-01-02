<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="do-schematron"
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
	
    <p:input port="schema" primary="true" />
    <p:output port="result"/>
    
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


</p:declare-step>
