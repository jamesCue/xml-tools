<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:epub="http://www.corbas.co.uk/ns/epub"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" 
	name="create-epub" type="epub:create-epub">

	<!-- INPUTS -->
	<p:input port="source" primary="true">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The primary input for the script is the XML file
				to be transformed into an EPUB file.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="parameters" kind="parameter">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The parameter input should be connected to the
			XML configuration file.</p>
		</p:documentation>
	</p:input>

	<p:input port="compute-paths">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The compute-paths stylesheet must return a set
				of paths to be created for the EPUB file before the archive is created. It's
				normally not necessary to modify the default stylesheet. See
				`compute-epub-paths.xsl` for details on inputs and outputs. </p>
		</p:documentation>
	</p:input>

	<p:input port="compute-uris">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The compute-uris stylesheet must return a set
				of URIs used to reference documents in xhtml files and the manifest. It's
				normally not necessary to modify the default stylesheet. See
				`compute-epub-uris.xsl` for details on inputs and outputs. </p>
		</p:documentation>
	</p:input>
	
	<p:input port="compute-archive-name">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The compute-archive-name stylesheet must return a c:result
				element defining the full path to the output archive file (as a URL). </p>
		</p:documentation>
	</p:input>
	
	<p:input port="image-list">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The image-list stylesheet must return 
			a c:result element containing a c:file element (with no path) for each image
		referenced in the source XML.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="create-html-manifest">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The create-html-manifest files must
			contain a manifest file listing the XSLT stylesheets to be executed against
			the source to create the output html.</p>
		</p:documentation>
	</p:input>

	<p:input port="create-opf-manifest">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The create-opf-manifest files must
				contain a manifest file listing the XSLT stylesheets to be executed against
				the source to create the package file.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="create-ncx-manifest">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The create-ncx-manifest files must
				contain a manifest file listing the XSLT stylesheets to be executed against
				the source to create the ncx toc file.</p>
		</p:documentation>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The primary output is a copy of the OPF file for
				the EPUB created.</p>
		</p:documentation>
		<p:pipe port="result" step="epub-paths"/>
	</p:output>
	
	

	<!-- Path to EPUB file -->
	<p:option name="epub-path" required="true">
		<p:documentation>
			<p xmlns="http:/www.w3.org/1999/xhtml">The path to the final EPUB file to be output must
				be provided as an input. This must not include the file name (this is generated
				internally).</p>
		</p:documentation>
	</p:option>

	
	<p:import href="../../xproc/load-sequence-from-file.xpl"/>
	<p:import href="epublib.xpl"/>
	<p:import href="package-epub-lib.xpl"/>
	
	<!-- Combine parameters with the root path and other options. Note p:in-scope-vars is not
	know to oxygen's schema so an error is displayed in the UI. -->
	<p:in-scope-names name="vars"/>
	<p:parameters name="initial-parameters">
		<p:input port="parameters">
			<p:pipe port="parameters" step="create-epub"/>
			<p:pipe port="result" step="vars"/>
		</p:input>
	</p:parameters>
	
		
	<!--
		Start by generating the paths to be used and writing them.
		Then work out the name of the file EPUB file.
	-->
	<epub:create-paths name="epub-paths">
		<p:input port="parameters">
			<p:pipe port="result" step="initial-parameters"/>
		</p:input>
		<p:input port="compute-paths">
			<p:pipe port="compute-paths" step="create-epub"/>
		</p:input>
	</epub:create-paths>
	
	
	<!-- The EPUB file name is stored in a c:result element -->
	<epub:archive-path name="archive-path">
		<p:input port="parameters">
			<p:pipe port="result" step="initial-parameters"/>
		</p:input>
		<p:input port="compute-path">
			<p:pipe port="compute-archive-name" step="create-epub"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="source" step="create-epub"></p:pipe>
		</p:input>
	</epub:archive-path>
	
	<p:sink/>
	
	<!-- Generate the actual internal URIs used from the xhtml 
	to reference stylesheeets, images, etc -->
	<epub:create-uris name="epub-uris">
		<p:input port="parameters">
			<p:pipe port="result" step="initial-parameters"/>
		</p:input>
		<p:input port="compute-uris">
			<p:pipe port="compute-uris" step="create-epub"/>
		</p:input>
	</epub:create-uris>	
	<p:sink/>
	
	<!-- Create a set of parameters containing all the information -->
	<p:parameters name="combined-parameters">
		<p:input port="parameters">
			<p:inline>		<!-- default parameters where mainly used outside of stylesheets -->
				<c:param-set>
					<c:param name="opf-file-name" value="package.opf"/>
					<c:param name="ncx-file-name" value="toc.ncx"/>
				</c:param-set>
			</p:inline>
			<p:pipe port="result" step="initial-parameters"/>
			<p:pipe port="result" step="epub-uris"/>
			<p:pipe port="result" step="epub-paths"/>
		</p:input>
	</p:parameters>
	
	<!-- Now we copy over any additional files that are required. 
	For images we have a copy tool because we check the content as well 
	as the additional list. However, we also have stylesheets and fonts
	to copy over (we can modify this list to add other types easily
	enough). -->
	<epub:copy-images name="get-images">
		<p:input port="source">
			<p:pipe port="source" step="create-epub"/>
		</p:input>
		<p:input port="image-list">
			<p:pipe port="image-list" step="create-epub"/>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="result" step="initial-parameters"/>
		</p:input>
		<p:with-option name="image-source" select="//c:param[@name='image-source']/@value">
			<p:pipe port="result" step="initial-parameters"/>			
		</p:with-option>
		<p:with-option name="image-target" select="//c:param[@name='image-dir']/@value">
			<p:pipe port="result" step="epub-paths"/>
		</p:with-option>
	</epub:copy-images>
	
	<p:sink/>
	
	<!-- styles -->
	<epub:create-file-list name="get-styles">
		<p:with-option name="file-list" select="//c:param[@name='css-files']/@value">
			<p:pipe port="result" step="initial-parameters"/>
		</p:with-option>
	</epub:create-file-list>
	
	<epub:copy-file-list name="copy-styles">
		<p:with-option name="source" select="//c:param[@name='style-source']/@value">
			<p:pipe port="result" step="initial-parameters"/>			
		</p:with-option>
		<p:with-option name="target" select="//c:param[@name='style-dir']/@value">
			<p:pipe port="result" step="epub-paths"/>
		</p:with-option>
	</epub:copy-file-list>
	
	<p:sink/>
	
	<!-- fonts -->
	<epub:create-file-list name="get-fonts">
		<p:with-option name="file-list" select="//c:param[@name='font-files']/@value">
			<p:pipe port="result" step="initial-parameters"/>
		</p:with-option>
	</epub:create-file-list>
	
	<epub:copy-file-list name="copy-fonts">
		<p:with-option name="source" select="//c:param[@name='font-source']/@value">
			<p:pipe port="result" step="initial-parameters"/>			
		</p:with-option>
		<p:with-option name="target" select="//c:param[@name='font-dir']/@value">
			<p:pipe port="result" step="epub-paths"/>
		</p:with-option>
	</epub:copy-file-list>

	<p:sink/>
	
	<!-- Generate and store the xhtml -->
	<ccproc:load-sequence-from-file name="load-xhtml-stylesheets">
		<p:input port="source">
			<p:pipe port="create-html-manifest" step="create-epub"/>
		</p:input>
	</ccproc:load-sequence-from-file>
	
	<epub:create-xhtml name="xhtml-time">
		<p:input port="source">
			<p:pipe port="source" step="create-epub"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="load-xhtml-stylesheets"/>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="result" step="combined-parameters"/>
		</p:input>
		<p:with-option name="xhtml-dir" select="//c:param[@name='xhtml-dir']/@value">
			<p:pipe port="result" step="combined-parameters"/>
		</p:with-option>
		
	</epub:create-xhtml>  
	
	<p:sink/>
	
	<!-- Generate and store the package file -->
	
	<ccproc:load-sequence-from-file name="load-opf-stylesheets">
		<p:input port="source">
			<p:pipe port="create-opf-manifest" step="create-epub"/>
		</p:input>
	</ccproc:load-sequence-from-file>
	
	<epub:create-and-save-file name="opf-time">
		<p:input port="source">
			<p:pipe port="source" step="create-epub"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="load-opf-stylesheets"/>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="result" step="combined-parameters"/>
		</p:input>
		<p:with-option name="content-dir" select="//c:param[@name='content-dir']/@value">
			<p:pipe port="result" step="combined-parameters"/>
		</p:with-option>
		<p:with-option name="filename" select="//c:param[@name='opf-file-name']/@value">
			<p:pipe port="result" step="combined-parameters"/>
		</p:with-option>
	</epub:create-and-save-file>  

	<p:sink/>
	
	<!-- Generate and store the ncx file -->
	
	<ccproc:load-sequence-from-file name="load-ncx-stylesheets">
		<p:input port="source">
			<p:pipe port="create-ncx-manifest" step="create-epub"/>
		</p:input>
	</ccproc:load-sequence-from-file>
	
	<epub:create-and-save-file name="ncx-time">
		<p:input port="source">
			<p:pipe port="source" step="create-epub"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="load-ncx-stylesheets"/>
		</p:input>
		<p:input port="parameters">
			<p:pipe port="result" step="combined-parameters"/>
		</p:input>
		<p:with-option name="content-dir" select="//c:param[@name='content-dir']/@value">
			<p:pipe port="result" step="combined-parameters"/>
		</p:with-option>
		<p:with-option name="filename" select="//c:param[@name='ncx-file-name']/@value">
			<p:pipe port="result" step="combined-parameters"/>
		</p:with-option>
	</epub:create-and-save-file>  
	
	<p:sink/>

</p:declare-step>
