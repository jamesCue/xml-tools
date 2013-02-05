<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:data="http://www.corbas.co.uk/ns/transforms/data"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
	 type="ccproc:load-sequence-from-file"
	name="load-sequence-from-file">
	
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
			identify the files to be loaded. The file names are resolved agains the base uri of the manifest file. 			
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
	
	<p:for-each name="load-iterator">
		
		<p:output port="result" primary="true"/>
		
		<p:iteration-source select="//data:item">
			<p:pipe port="source" step="load-sequence-from-file"/>
		</p:iteration-source>
		
		<p:variable name="href" select="p:resolve-uri(/data:item/@href, p:base-uri(/data:item))"/>

		<p:load name="load-doc">
			<p:with-option name="href" select="$href"/>
		</p:load>
		
		<p:identity/>
		
	</p:for-each>
    
</p:declare-step>