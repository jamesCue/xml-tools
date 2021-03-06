<?xml version="1.0" encoding="UTF-8"?>

<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="1.0" name="stylesheet-store"
	type="ccproc:stylesheet-store">
	
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
		<p xmlns="http:/wwww.w3.org/1999/xhtml">Wrapper around an xslt pipeline. The xslt
			is provided one the stylesheet input. The output can be logged if desired (using store-identity.xpl).
			Any xslt parameters required should be provided on the parameter input. The input document 
			is the primary input to the step.</p>
	</p:documentation>
	
	
	<p:input port="source" primary="true">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The primary input must provide the document to
				be processed (and returned).</p>
		</p:documentation>
	</p:input>
	
	<p:input port="stylesheet">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The XSLT file to be executed.</p>
		</p:documentation>
	</p:input>
	
	
	<p:input kind="parameter" primary="true" port="parameters">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The parameter port contains the parameters to be
				passed to the xslt script.</p>
		</p:documentation>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The primary output is the result of the
				xslt process.</p>
		</p:documentation>
		<p:pipe port="result" step="store-result"/>
	</p:output>
	
	<p:output port="href-written">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The url for the logged output copy is provided on the
				<code>href-written</code> port within a single <code>c:result</code>
				element.</p>
		</p:documentation>
		<p:pipe port="href-written" step="store-result"/>
	</p:output>
	
	<p:option name="execute-store" select="'true'">
		<p:documentation>
			<p xmlns="http:/wwww.w3.org/1999/xhtml">If set to true the store step will not be
				executed. This is intended to allow debugging to be enabled and disabled easily.</p>
		</p:documentation>
	</p:option>
	
	<p:option name="href" required="true">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The URL to which the file should be written. If
				the href-root option is provided, the href is appended to it.</p>
		</p:documentation>
	</p:option>
	
	<p:option name="href-root" select="''">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">An optional root portion for the href. If
				provided is used as a prefix.</p>
		</p:documentation>
	</p:option>
	
	<p:import href="store-identity.xpl"/>
	
	
	<p:xslt name="xslt-processing">
		<p:input port="stylesheet">
			<p:pipe port="stylesheet" step="stylesheet-store"/>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="parameters" step="stylesheet-store"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="source" step="stylesheet-store"/>
		</p:input>
	</p:xslt>
	
	<ccproc:store-identity name="store-result">
		<p:with-option name="href-root" select="$href-root"/>
		<p:with-option name="href" select="$href"/>
		<p:with-option name="execute-store" select="$execute-store"/>		
	</ccproc:store-identity>
	
	
</p:declare-step>