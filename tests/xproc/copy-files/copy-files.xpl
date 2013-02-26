<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="copy-files" type="epub:copy-files" xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:epub="http://www.corbas.net/ns/epub"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:pxf="http://exproc.org/proposed/steps/file"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">

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
		<p:pipe port="source" step="copy-files"/>
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

	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

	<!-- loop over the input -->
	<p:for-each name="process-files">

		<p:iteration-source select="//c:file"/>

		<pxf:copy name="copy-file">
			<p:with-option name="href" select="p:resolve-uri(/c:file/@name, $source)"/>
			<p:with-option name="target" select="$target"/>
		</pxf:copy>

	</p:for-each>

</p:declare-step>
