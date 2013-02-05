<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
	xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:epub="http://www.corbas.net/ns/epub"
	xmlns:cstep="http://www.corbas.net/ns/xproc" xmlns:corbas="http://www.corbas.net/ns/tempns"
	xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:h="http://www.w3.org/1999/xhtml">

	<p:declare-step name="create-epub" type="epub:create-epub">

		<p:documentation>
			<p xmlns="http:/wwww.w3.org/1999/xhtml">This scripts creates an unpackaged EPUB 2 file
				into a specified directory. The starting point is an XML file and four stylesheets
				to process it (provided as inputs):</p>
			<p>The contents of the primary parameters port will be available to all scripts.</p>
		</p:documentation>

		<p:input port="source" primary="true">
			<p:documentation><h:p>The input XML document to be converted to EPUB
				content.</h:p></p:documentation>
		</p:input>

		<p:input port="html-generator">
			<p:documentation>
				<h:p>XSLT stylesheet to generate the HTML. The HTML html documents must be written
					using <h:code>xsl:result-document</h:code> and must have an additional
						<h:code>meta</h:code> tag called <h:pre>file-id</h:pre> which must contain
					the name of the file to be written without any suffix (e.g.
						<h:pre>chapter-001</h:pre></h:p>). The primary output of the XLST will be
				discarded. </p:documentation>
		</p:input>

		<p:input port="package-generator">
			<p:documentation>
				<h:p>XSLT stylesheet to generate the package file. The primary output of this script
					is used as the package file. Secondary outputs are ignored.</h:p>
			</p:documentation>
		</p:input>

		<p:input port="ncx-generator">
			<p:documentation>
				<h:p>XSLT stylesheet to generate the declaratory table of contents file. The primary
					output is used to generate the NCX file. Secondary outputs are ignored.</h:p>
			</p:documentation>
		</p:input>

		<p:input port="resource-generator">
			<p:documentation>
				<h:p>XSLT stylesheet used to generate a list of external resources to be copied into
					the EPUB structure. The output must be a sequence of <h:code>zip-manifest</h:code> elements as described
					in the documentation for <a href="http://exproc.org/proposed/steps/other.html#zip">pxp:zip</a>.
				An additional parameter, <h:code>media-type</h:code>, must be provided for each <h:code>entry</h:code>
				element. This should contain the value to be used for the same attribute in the EPUB manifest. The
				extra attribute will be removed before the zip file is created.</h:p>
			</p:documentation>
		</p:input>

		<p:input kind="parameter" primary="true" port="params">
			<p:documentation>
				<h:p>Default parameter port. This is passed to each xslt stylesheet to allow
					additional information to be provided. All the options passed to this step are
					also provided as parameters.</h:p>
			</p:documentation>
		</p:input>

		<p:output port="result" primary="true" sequence="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">A sequence of c:result elements, one for
					each file written during this step.</p>
			</p:documentation>
			<p:pipe port="result" step="final"/>
		</p:output>


		<!-- name of the directory in which the content directory should be created -->
		<p:option name="root" select="'.'">
			<p:documentation>
				<h:p>Root directory for the output. All other directories are created within it. The
					META-INF directory is created at a later stage.</h:p>
			</p:documentation>
		</p:option>

		<!-- metadata filenames -->
		<p:option name="package-file" select="'package.opf'"/>
		<p:option name="ncx-file" select="'toc.ncx'"/>

		<!-- main content directory -->
		<p:option name="content-dir-name" select="'OPS'"/>

		<!-- names of various content locations -->
		<p:option name="image-dir-name" select="'images'"/>
		<p:option name="xhtml-dir-name" select="'xhtml'"/>
		<p:option name="css-dir-name" select="'styles'"/>
		<p:option name="font-dir-name" select="'fonts'"/>
		<p:option name="media-dir-name" select="'media'"/>

		<!-- set up some paths with a parameter set. All the options above are combined into a 
    c:param-set and passed to the path definition script which returns another param-set. -->


		<p:variable name="opf-path"
			select="string-join(($root, $content-dir-name, $package-file), '/')"/>
		<p:variable name="ncx-path" select="string-join(($root, $content-dir-name, $ncx-file), '/')"/>
		<p:variable name="xhtml-path"
			select="string-join(($root, $content-dir-name, $xhtml-dir-name), '/')"/>
		<p:variable name="css-path"
			select="string-join(($root, $content-dir-name, $css-dir-name), '/')"/>
		<p:variable name="image-path"
			select="string-join(($root, $content-dir-name, $image-dir-name), '/')"/>
		<p:variable name="font-path"
			select="string-join(($root, $content-dir-name, $font-dir-name), '/')"/>
		<p:variable name="media-path"
			select="string-join(($root, $content-dir-name, $media-dir-name), '/')"/>
		<p:variable name="resource-path"
			select="string-join(($root, $content-dir-name, $resource-dir-name), '/')"/>

		<!-- set up base URLs for relative access to images, etc (everything bar fonts) from HTML. These are not the
    most complex - they assume that either there are very few options here. -->
		<p:variable name="css-uri-base"
			select="if ($xhtml-dir-name) then if ($css-dir-name) concat("/>
		<p:variable name="image-uri-base" select="concat('../', $image-dir-name)"/>


		<!-- start by creating the paths -->
		<epub:create-paths>
			<p:with-option name="base-path" select="$root"/>
			<p:with-option name="content-dir-name" select="$content-dir-name"/>
			<p:with-option name="xhtml-dir-name" select="$xhtml-dir-nane"/>
			<p:with-option name="styles-dir-name" select="$styles-dir-name"/>
			<p:with-option name="images-dir-name" select="$images-dir-name"/>
		</epub:create-paths>


		<!-- metadata files -->
		<epub:create-opf name="create-opf">
			<p:input port="source">
				<p:pipe port="source" step="create-epub"/>
			</p:input>
			<p:with-option name="href" select="$opf-path"/>
		</epub:create-opf>


		<epub:create-ncx name="create-ncx">
			<p:input port="source">
				<p:pipe port="source" step="create-epub"/>
			</p:input>
			<p:with-option name="href" select="$ncx-path"/>
			<p:with-option name="xhtml-dir-name" select="$xhtml-dir-name"/>
		</epub:create-ncx>

	</p:declare-step>

	<p:declare-step name="create-paths" type="epub:create-paths">
		<p:documentation>
			<h:p>Internal routine used to set up the initial paths for the EPUB output.</h:p>
		</p:documentation>
	</p:declare-step>
</p:library>
