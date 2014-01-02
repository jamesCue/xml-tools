<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:data="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

	<p:declare-step 
		type="ccproc:load-sequence-from-file"
		name="load-sequence-from-file">
		
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
					<title>load-sequence-from-file.xpl</title>
					<author><personname>Nic Gibson</personname></author>
					<revhistory>
						<revision>
							<revnumber>1</revnumber>
							<date>2013-01-14</date>
							<revremark>Initial Version</revremark>
						</revision>
					</revhistory>
				</info>
				<para>Script to read an xml manifest file containing a list of files, load them
					and return a sequence of the files in the order they were contained in the
					input file. The input file should validate against <filename>manifest.rng</filename>.
					The <tag class="attribute">href</tag> attribute of each <tag class="element">item</tag> element is used to
					identify the files to be loaded. The file names are resolved agains the base uri of the manifest file (or
					their own base if overridden via <tag class="attribute">xml:base</tag>.
				</para>
				
			</section>
		</p:documentation>
		
		
		<p:input port="source"  primary="true">
			<p:documentation>
				<para xmlns="http://docbook.org/ns/docbook">The source port should provide a manifest document 
					as described above.</para>
			</p:documentation>
		</p:input>
		
		<p:output port="result" primary="true" sequence="true">
			<p:documentation>
				<para xmlns="http://docbook.org/ns/docbook">The result port will contain a sequence of documents
					loaded from the list contained on the input port</para>
			</p:documentation>
			<p:pipe port="result" step="load-iterator"></p:pipe>
		</p:output>
		
		<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
		
		<!-- Loop over input and load each file in turn. 
		We don't handle errors here because the default behaviour (exit with error)
		is the desired behaviour and the error message is just fine -->
		<p:for-each name="load-iterator">
			
			<p:output port="result" primary="true"/>
			
			<p:iteration-source select="/data:manifest/*">
				<p:pipe port="source" step="load-sequence-from-file"/>
			</p:iteration-source>
			
			<p:choose>
				
				<p:when test="/data:item">
					
					<p:variable name="href" select="p:resolve-uri(/data:item/@href, p:base-uri(/data:item))"></p:variable>
					
					<!-- <cx:message>
					<p:with-option name="message" select="concat('item: ', $href)"/>
				</cx:message> -->
					
					<p:load name="load-doc">
						<p:with-option name="href" select="$href"/>
					</p:load>
					
				</p:when>
				
				<p:otherwise>
					
					<p:variable name="stylesheet" select="p:resolve-uri(/data:processed-item/@stylesheet, 
						p:base-uri(/data:processed-item))"/>
					<p:variable name="href" select="p:resolve-uri(/data:processed-item/data:item/@href, 
						p:base-uri(/data:processed-item/data:item))"/>
					
					<!--<cx:message>
					<p:with-option name="message" select="concat('stylesheet: ', $stylesheet)"/>
				</cx:message>-->				
					
					<p:load name="load-stylesheet">
						<p:with-option name="href" select="$stylesheet"/>
					</p:load>
					
					<!--<cx:message>
					<p:with-option name="message" select="concat('item: ', $href)"/>
				</cx:message>-->		
					
					<p:load name="load-data">
						<p:with-option name="href" select="$href"/>
					</p:load>
					
					
					<p:xslt>
						<p:input port="parameters">
							<p:empty/>
						</p:input>
						<p:input port="stylesheet">
							<p:pipe port="result" step="load-stylesheet"/>
						</p:input>
						<p:input port="source">
							<p:pipe port="result" step="load-data"/>
						</p:input>
					</p:xslt>
					
				</p:otherwise>
			</p:choose>
			
			<p:identity/>
			
		</p:for-each>
		
	</p:declare-step>
	
</p:library>
