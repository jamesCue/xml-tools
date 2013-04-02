<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:epub="http://www.corbas.co.uk/ns/epub" xmlns:pxf="http://exproc.org/proposed/steps/file"
	xmlns:h="http://www.w3.org/1999/xhtml" xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps" version="1.0">

	<!--
    	Note: currently create-opf and create-ncx are almost identical. However, when the
    	custom files are added, they will differ.
    -->

	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="../../xproc/recursive-xslt.xpl"/>

	<p:declare-step type="epub:copy-file-list" name="copy-file-list">

		<p:documentation>
			<p>Given a sequence of c:file elements, a source directory and target directory, copies
				the files named from one directory to the other.</p>
			<p>The input list is then returned to the caller.</p>
		</p:documentation>

		<p:input port="source" primary="true" sequence="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The list of file names to be
					copied. There should be no paths (although relative paths will
				work).</p></p:documentation>
		</p:input>

		<p:output port="result" primary="true" sequence="true">
			<p:documentation><p xmlns="http:/www.w3.org/1999/xhtml">The step reproduces the input
					sequence on the primary output.</p></p:documentation>
			<p:pipe port="result" step="process-files"/>
		</p:output>

		<p:option name="source" required="true">
			<p:documentation>
				<p xmlns="http:/www.w3.org/1999/xhtml">The source option provides the directory from
					which files should be read. This is used an a xml:base and <strong>must end with
						a "/"</strong>.</p>
			</p:documentation>
		</p:option>

		<p:option name="target" required="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The target option provides the
					path to which files should be written. This is used an a xml:base and
						<strong>must end with a "/"</strong></p>.</p:documentation>
		</p:option>


		
		<!-- loop over the input -->
		<p:for-each name="process-files">

			<p:output port="result" primary="true">
				<p:pipe port="result" step="copy-single-file"/>
			</p:output>

			<p:iteration-source select="//c:file"/>
			
			<pxf:copy name="copy-single-file">
				<p:with-option name="href" select="p:resolve-uri(/c:file/@name, $source)"/>
				<p:with-option name="target" select="$target"/>
			</pxf:copy>

		</p:for-each>

	</p:declare-step>

	<p:declare-step name="create-file-list" type="epub:create-file-list">

		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Given a list of file names separated by spaces,
				converts it to a set of c:file elements. Uses an inline stylesheet as the process is
				unaffected by outside configuration.</p>
		</p:documentation>

		<p:output port="result" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">A <code class="element">c:result</code>
					element containing on <code class="element">c:file</code> for each file in the
					input list.</p>
			</p:documentation>
		</p:output>

		<p:option name="file-list" required="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The list of file names, separated by
					whitespace. These must be bare file names with no path component.</p>
			</p:documentation>
		</p:option>

		<p:xslt version="2.0" template-name="convert-list">
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
						<xsl:param name="file-list"/>
						<xsl:template name="convert-list">
							<c:result>
								<xsl:for-each select="tokenize($file-list, '\s+')">
									<xsl:variable name="id" select="replace(., '\W', '-')"/>
									<c:file xml:id="{$id}" name="{.}"/>
								</xsl:for-each>
							</c:result>
						</xsl:template>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
			<p:input port="source">
				<p:empty/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
			<p:with-param name="file-list" select="$file-list"/>
		</p:xslt>


	</p:declare-step>

	<p:declare-step name="copy-images" type="epub:copy-images">

		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Runs the image-list stylesheet to get a list of
				file names from the input file. Uses that list to generate a list of paths to source
				images and then calls copy-files to actually copy them.</p>
			<p>The input list is then returned to the caller.</p>
		</p:documentation>

		<p:input port="parameters">
			<p:documentation><p xmlns="http:/www.w3.org/1999/xhtml">All parameters to the XProc
					script plus all the main configuration values.</p></p:documentation>
		</p:input>

		<p:input port="source" primary="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The primary xml file from which
					image references can be pulled.</p></p:documentation>
		</p:input>

		<p:input port="image-list">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet to be use to
					extract image references and convert them to c:file
				elements.</p></p:documentation>
		</p:input>

		<p:output port="result" primary="true" sequence="true">
			<p:pipe port="result" step="do-copy-images"/>
		</p:output>

		<p:option name="image-source" required="true">
			<p:documentation>
				<p xmlns="http:/www.w3.org/1999/xhtml">The image-source option provides the
					directory from which images should be loaded.</p>
			</p:documentation>
		</p:option>

		<p:option name="image-target" required="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The image-target option
					provides the path to which images should be written.</p></p:documentation>
		</p:option>
		

		<!-- Process the XML to get the images. -->
		<p:xslt name="get-images">
			<p:input port="stylesheet">
				<p:pipe port="image-list" step="copy-images"/>
			</p:input>
			<p:input port="source">
				<p:pipe port="source" step="copy-images"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="copy-images"/>
			</p:input>
		</p:xslt>

		<epub:copy-file-list name="do-copy-images">
			<p:input port="source">
				<p:pipe port="result" step="get-images"/>
			</p:input>
			<p:with-option name="source" select="$image-source"/>
			<p:with-option name="target" select="$image-target"/>
		</epub:copy-file-list>
		

	</p:declare-step>

	<p:declare-step name="create-paths" type="epub:create-paths">

		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Creates the basic directory structure. Not
				strictly necessary but useful because some extension steps seem to create paths if
				non-existent and others don't. To keep the path creation, the stylesheet passed on
				the compute-paths input is processed. It must return a c:param-set element
				containing a list of c:param elements. The value of each param is treated as a
				directory name and is created. All of the information for the stylesheet is passed
				via parameters.</p>
			<p xmlns="http://www.w3.org/1999/xhtml">The list of directories is returned as the
				result.</p>
		</p:documentation>

		<p:input port="parameters" kind="parameter">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The parameters to be used to
					determine the paths.</p></p:documentation>
		</p:input>

		<p:input port="compute-paths">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet use to compute
					the directories to be created. An empty c:result element is provided as the
					input document.</p></p:documentation>
		</p:input>

		<p:output port="result">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The list of directories
					created.</p></p:documentation>
			<p:pipe port="result" step="compute-paths"/>
		</p:output>


		<!-- Build the list of directories -->
		<p:xslt name="compute-paths">
			<p:input port="stylesheet">
				<p:pipe port="compute-paths" step="create-paths"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-paths"/>
			</p:input>
			<p:input port="source">
				<p:inline>
					<c:result/>
				</p:inline>
			</p:input>
		</p:xslt>

		<!-- Loop over, creating the paths -->
		<p:for-each>
			<p:iteration-source select="//c:param"/>
			<pxf:mkdir>
				<p:with-option name="href" select="/c:param/@value"/>
			</pxf:mkdir>
		</p:for-each>


	</p:declare-step>
	
	
	<p:declare-step name="create-uris" type="epub:create-uris">
		
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Calculates the URIs used
			to generate hyperlinks in the xhtml files and from the manifest.</p>
			<p xmlns="http://www.w3.org/1999/xhtml">Returns the list as c:param-set.</p>
		</p:documentation>
		
		<p:input port="parameters" kind="parameter">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The parameters to be used to
				determine the URIs.</p></p:documentation>
		</p:input>
		
		<p:input port="compute-uris">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet use to compute
				the uri references. An empty c:result element is provided as the
				input document.</p></p:documentation>
		</p:input>
		
		<p:output port="result">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The list of uri references
				generated.</p></p:documentation>
			<p:pipe port="result" step="compute-uris"/>
		</p:output>
		
		
		<!-- Build the list of directories -->
		<p:xslt name="compute-uris">
			<p:input port="stylesheet">
				<p:pipe port="compute-uris" step="create-uris"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-uris"/>
			</p:input>
			<p:input port="source">
				<p:inline>
					<c:result/>
				</p:inline>
			</p:input>
		</p:xslt>
		
	</p:declare-step>

	<p:declare-step name="epub-archive-path" type="epub:archive-path">


		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Creates a c:result element containing the path
				to the output EPUB file. This step simply calls the supplied stylesheet.</p>
		</p:documentation>

		<p:input port="source" primary="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The main XML document so that
					content can be used to drive the file name.</p></p:documentation>
		</p:input>

		<p:input port="parameters" kind="parameter">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The parameters to be used to
					determine the file name.</p></p:documentation>
		</p:input>

		<p:input port="compute-path">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet use to generate
					the file name.</p></p:documentation>
		</p:input>

		<p:output port="result">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">A c:result element containing
					the file name.</p></p:documentation>
			<p:pipe port="result" step="create-path-name"/>
		</p:output>
		
		<!-- Build the list of directories -->
		<p:xslt name="create-path-name">
			<p:input port="source">
				<p:pipe port="source" step="epub-archive-path"/>
			</p:input>
			<p:input port="stylesheet">
				<p:pipe port="compute-path" step="epub-archive-path"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="epub-archive-path"/>
			</p:input>
		</p:xslt>


	</p:declare-step>

	<p:declare-step name="create-and-save-file" type="epub:create-and-save-file">

		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">This step executes one or more XSLT stylesheets
				against the input XML to generate an output file. The stylesheets are executed
				recursively feeding the output from one to the input of the next.</p>
		</p:documentation>

		<p:input port="source" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The primary input XML document.</p>
			</p:documentation>
		</p:input>

		<p:input port="stylesheets" sequence="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">A sequence of stylesheets to be executed
					against the content document.</p>
			</p:documentation>
		</p:input>

		<p:input port="parameters" kind="parameter">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The parameter port is provided
					with all of the current parameters and main script variables and
				options.</p></p:documentation>
		</p:input>
		
		<p:output port="result">
			<p:pipe step="transform-input" port="result">
				<p:documentation>
					<p xmlns="http://www.w3.org/1999/xhtml">The result of the step is the file generated.</p>
				</p:documentation>
			</p:pipe>
		</p:output>
		
		<p:option name="content-dir" required="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The directory to which the output must
				be written.</p></p:documentation>
		</p:option>
		
		<p:option name="filename" required="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The name of the file to which the output must
				be written.</p></p:documentation>
		</p:option>
		
		
		<!-- Create the output file via recursive xslt-->
		<ccproc:recursive-xslt name="transform-input">
			<p:input port="stylesheets">
				<p:pipe port="stylesheets" step="create-and-save-file"/>
			</p:input>
			<p:input port="source">
				<p:pipe port="source" step="create-and-save-file"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-and-save-file"/>
			</p:input>
		</ccproc:recursive-xslt>

		<!-- Recursive xslt can produce a lot of results. make sure we only have one -->
		<p:split-sequence name="first-only" initial-only="true" test="position()=1">
			<p:input port="source">
				<p:pipe port="result" step="transform-input"/>
			</p:input>
		</p:split-sequence>
		
		<p:store>
			<p:with-option name="href" select="concat($content-dir, $filename)"/>
		</p:store>
		
	</p:declare-step>

	<p:declare-step name="create-xhtml" type="epub:create-xhtml">

		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">The create-xhtml step loads a sequence of
				stylesheets and processes the input XML document with them. The result is then
				serialized to the target directory.</p>
		</p:documentation>

		<p:input port="source" primary="true">
			<p:documentation>The input XML document.</p:documentation>
		</p:input>

		<p:input port="parameters"  kind="parameter">
			<p:documentation>The collected parameters.</p:documentation>
		</p:input>

		<p:input port="stylesheets" sequence="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The stylesheets port must supply a sequence
					of XSLT stylesheets that generate the xhtml for output on their output ports.
					The required output file name must be stored in a meta tag on the output
					document using the name <strong>filename</strong> and the identifier to be used
					in the EPUB manifest must be store in another meta tag using the name
						<strong>page-id</strong>.</p>
			</p:documentation>
		</p:input>

		<p:output port="result" primary="true" sequence="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The result port contains the created xhtml files</p></p:documentation>
			<p:pipe port="result" step="generate-xhtml"/>
		</p:output>
		
		<p:option name="xhtml-dir"  required="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The path for the directory to which the xhtml files must be written.</p>
			</p:documentation>
		</p:option>		
		
		
		<ccproc:recursive-xslt name="generate-xhtml">
			
			<p:input port="stylesheets">
				<p:pipe port="stylesheets" step="create-xhtml"/>
			</p:input>
			
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-xhtml"/>
			</p:input>
			
			<p:input port="source">
				<p:pipe port="source" step="create-xhtml"/>
			</p:input>
			
		</ccproc:recursive-xslt>
		
		<p:for-each name="store-pages">
			
			<p:iteration-source>
				<p:pipe port="result" step="generate-xhtml"/>            
			</p:iteration-source>
			
			<!-- get the filename from the html -->
			<p:variable name='filename' select="concat($xhtml-dir, /h:html/h:head/h:meta[@name='filename']/@content)"/>

			<p:store>
				<p:with-option name="href" select="$filename"/>
			</p:store>
			
		</p:for-each>
		
	</p:declare-step>
	
</p:library>
