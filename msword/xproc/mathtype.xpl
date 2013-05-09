<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0"
    xmlns:corbas="http://www.corbas.co.uk/ns/xproc" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	name="convert-mathtype" type="corbas:convert-mathtype">

	<p:documentation>
		
		This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
		
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
		contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. 
		
	</p:documentation>

    <p:documentation>
        <section xmlns="http://docbook.org/ns/docbook">
            <info>
                
                <title>mathtype.xpl</title>
                <author><personname>Nic Gibson</personname></author>
                <revhistory>
                    <revision>
                        <revnumber>1</revnumber>
                        <date>2010-10-09</date>
                        <revremark>Initial Version</revremark>
                    </revision>
                </revhistory>
            </info>
            <para>XProc script to modify the output of docx2xml, replacing equations with mathml
            where converted mathml (via MathType) is found. </para>
           </section>
    </p:documentation>
	
	<p:input port="source" primary="true"/>
	<p:input kind="parameter" port="parameters" primary="true"/>

    <p:output port="result" primary="true">
        <p:pipe port="result" step="the-end"/>
    </p:output>
	
	<p:option name='href-root' select="'/tmp/'"/>
	<p:option name="execute-store" select="'true'"/>
	
	<p:import href="../../../xproc/stylesheet-runner.xpl"/>
	<p:import href="../../../xproc/store-identity.xpl"/>
	
	<ccproc:stylesheet-runner href="mathtype-001.xml" name="convert-block-equations" stylesheet-href="../msword/xslt/mathtype-001.xsl">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>        
	</ccproc:stylesheet-runner>
	
	<p:viewport name="remove--block-escapes" match="//db:equation" xmlns:db="http://docbook.org/ns/docbook">
		<p:unescape-markup/>	
	</p:viewport>
	
	<ccproc:store-identity href="mathtype-001a.xml">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>
	</ccproc:store-identity>
		
	<ccproc:stylesheet-runner href="mathtype-002.xml" name="restructure-inline-equations-1" stylesheet-href="../msword/xslt/mathtype-002.xsl">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>        
	</ccproc:stylesheet-runner>

	<ccproc:stylesheet-runner href="mathtype-003.xml" name="merge-inline-equations" stylesheet-href="../msword/xslt/mathtype-003.xsl">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>        
	</ccproc:stylesheet-runner>
	
	<p:viewport name="remove-inline-escapes" match="//db:inlineequation" xmlns:db="http://docbook.org/ns/docbook">
		<p:unescape-markup/>	
	</p:viewport>
	
	<ccproc:store-identity href="mathtype-003a.xml">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>
	</ccproc:store-identity>
	
	<ccproc:stylesheet-runner href="mathtype-004.xml" name="merge-paras" stylesheet-href="../msword/xslt/mathtype-004.xsl">
		<p:with-option name="href-root" select='$href-root'/>
		<p:with-option name="execute-store" select="$execute-store"/>        
	</ccproc:stylesheet-runner>
	
	<p:identity name="the-end"/>

</p:declare-step>
