<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:epub="http://www.corbas.co.uk/ns/epub"
    xmlns:pxf="http://exproc.org/proposed/steps/file"
    xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
    version="1.0">

    <!--
    	Note: currently create-opf and create-ncx are almost identical. However, when the
    	custom files are added, they will differ.
    -->

	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="../../xproc/recursive-xslt.xpl"/>

	<p:declare-step type="epub:copy-file-list" name="copy-file-list">
		
		<p:documentation>
			<p>Given a sequence of c:file elements, a source directory and target directory, copies the
				files named from one directory to the other.</p>
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
			<p:pipe port="source" step="copy-file-list"/>
		</p:output>
		
		<p:option name="source" required="true">
			<p:documentation>
				<p xmlns="http:/www.w3.org/1999/xhtml">The source option provides the directory from
					which files should be read. This is used an a xml:base and <strong>must end with a "/"</strong>.</p>
			</p:documentation>
		</p:option>
		
		<p:option name="target" required="true">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The target option provides the path
				to which files should be written. This is used an a xml:base and <strong>must end with a "/"</strong></p>.</p:documentation>
		</p:option>
		
	
		<!-- loop over the input -->
		<p:for-each name="process-files">
			
			<p:iteration-source select="//c:file"/>
			
			<pxf:copy name="copy-single-file">
				<p:with-option name="href" select="p:resolve-uri(/c:file/@name, $source)"/>
				<p:with-option name="target" select="$target"/>
			</pxf:copy>
			
		</p:for-each>
		
	</p:declare-step>

	<p:declare-step name="copy-images" type="epub:copy-images">

        <p:documentation>
                <p>Runs the image-list stylesheet to get a list of file names from the
                input file. Uses that list to generate a list of paths to source images
                and then calls copy-files to actually copy them.</p>
            	<p>The input list is then returned to the caller.</p>
            
        </p:documentation>
    	
    	<p:input port="parameters">
    		<p:documentation><p xmlns="http:/www.w3.org/1999/xhtml">All parameters to the XProc
    		script plus all the main configuration values.</p></p:documentation>
    	</p:input>

        <p:input port="source" primary="true">
        	<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The primary xml file
        	from which image references can be pulled.</p></p:documentation>
        </p:input>
    	
    	<p:input port="image-list">
    		<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet to be
    		use to extract image references and convert them to c:file elements.</p></p:documentation>
    	</p:input>
    	
        <p:output port="result" primary="true">
            <p:pipe port="result" step="copy-images"/>
        </p:output>

        <p:option name="image-source" required="true">
        	<p:documentation>
        		<p xmlns="http:/www.w3.org/1999/xhtml">The image-source option provides the directory
        		from which images should be loaded.</p>
        	</p:documentation>
        </p:option>
    	
        <p:option name="image-target" required="true">
        	<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The image-target option provides
        	the path to which images should be written.</p></p:documentation>
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
    	
    	<epub:copy-file-list name="copy-images">
			<p:input port="source">
				<p:pipe port="result" step="get-images"/>
			</p:input>
			<p:with-option name="source" select="$image-source"/>
			<p:with-option name="target" select="$image-target"/>
		</epub:copy-file-list>
		
    </p:declare-step>

	<p:declare-step name="create-paths" type="epub:create-paths">
		
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">Creates the basic directory structure. Not strictly necessary but useful because
				some extension steps seem to create paths if non-existent and others don't. To keep the path creation, the stylesheet
				passed on the compute-paths input is processed. It must return a c:result element containing a list of
				c:dir elements. These will be created. All of the information for the stylesheet is passed via parameters.</p>
			<p xmlns="http://www.w3.org/1999/xhtml">The list of directories is returned as the result.</p>
		</p:documentation>
		
		<p:input port="parameters" kind="parameter">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The parameters to be used to determine the paths.</p></p:documentation>
		</p:input>
		
		<p:input port="compute-paths">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The stylesheet use to compute the directories to be created. An empty
				c:result element is provided as the input document.</p></p:documentation>
		</p:input>
		
		<p:output port="result">
			<p:documentation><p xmlns="http://www.w3.org/1999/xhtml">The list of directories created.</p></p:documentation>
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
			<p:iteration-source select="//c:dir"></p:iteration-source>
			<pxf:mkdir>
				<p:with-option name="href" select="/c:dir/@name"/>
			</pxf:mkdir>
		</p:for-each>
		
		
	</p:declare-step>

	<p:declare-step name="create-ncx" type="epub:create-ncx">
		
		<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">This step executes one or XSLT stylesheets against the
				input XML to generate the NCX file. The stylesheets are executed recursively feeding the output
				from one to the input of the next.</p>
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
			with all of the current parameters and main script variables and options.</p></p:documentation>
		</p:input>
		
		<p:output port="result">
			<p:pipe step="transform-input" port="result"/>
		</p:output>
		
		<!-- Create the NCX file via recursive xslt-->
		<ccproc:recursive-xslt name="transform-input">
			<p:input port="stylesheets">
				<p:pipe port="stylesheets" step="create-ncx"/>
			</p:input>
			<p:input port="source">
				<p:pipe port="source" step="create-ncx"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-ncx"/>
			</p:input>
		</ccproc:recursive-xslt>
		
	</p:declare-step>
	
	<p:declare-step name="create-opf" type="epub:create-opf">
		
		<p:documentation>
			<p xmlns="http://www.w3.org/1999/xhtml">This step executes one or XSLT stylesheets against the
				input XML to generate the package file. The stylesheets are executed recursively feeding the output
				from one to the input of the next.</p>
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
				with all of the current parameters and main script variables and options.</p></p:documentation>
		</p:input>
		
		<p:output port="result">
			<p:pipe step="transform-input" port="result"/>
		</p:output>
		
		<!-- Create the OPF file via recursive xslt-->
		<ccproc:recursive-xslt name="transform-input">
			<p:input port="stylesheets">
				<p:pipe port="stylesheets" step="create-ncx"/>
			</p:input>
			<p:input port="source">
				<p:pipe port="source" step="create-ncx"/>
			</p:input>
			<p:input port="parameters">
				<p:pipe port="parameters" step="create-ncx"/>
			</p:input>
		</ccproc:recursive-xslt>
		
		
	</p:declare-step>

</p:library>
