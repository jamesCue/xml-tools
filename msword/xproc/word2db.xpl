<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:cword="http://www.corbas.co.uk/ns/word"
	name="wordToDocBook" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" version="1.0"
	xmlns:corbas="http://www.corbas.co.uk/ns/xproc"
	xmlns:wprop="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps">

	<p:documentation>
		<h2 xmlns="http:/www.w3.org/1999/xhtml">word2db.xp</h2>
		<table class="revisions" xmlns="http:/www.w3.org/1999/xhtml">
			<caption>Revisions</caption>
			<thead>
				<tr>
					<th>Revision</th>
					<th>2010-02-08</th>
					<th>Comment</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>1</td>
					<td>2010-02-08</td>
					<td>Initial Version</td>
				</tr>
				<tr>
					<td>2</td>
					<td>2010-03-19</td>
					<td>Added support for loading and merging the document.xml.rels file in order to
						access URLs for linked images. Added move-graphics step to allow images to
						be placed correctly.</td>
				</tr>
				<tr>
					<td>3</td>
					<td>2010-03-29</td>
					<td>Added support for loading app.xml for document properties and numbering.xml
						for list handling.</td>
				</tr>
				<tr>
					<td>4</td>
					<td>2012-05-28</td>
					<td>Removed load code to replace with standalone module.</td>
				</tr>
				<tr>
					<td>5</td>
					<td>2012-08-06</td>
					<td>Added block quote refactoring code.</td>
				</tr>
				<tr>
					<td>6</td>
					<td>2012-08-23</td>
					<td>Added code to handle dedications</td>
				</tr>
				<tr>
					<td>7</td>
					<td>2012-08-27</td>
					<td>Updated to use ccproc:store-identity and added options to make it simpler to
						use. Removed refactoring code to separate file for ease of maintenance.
						Improved documentation. </td>
				</tr>
				<tr>
					<td>8</td>
					<td>2013-01-30</td>
					<td>Updated to use external configuration files and XSLT manifests. Where
						possible, options have become parameters </td>
				</tr> 
				<tr>
					<td>9</td>
					<td>2013-03-03</td>
					<td>Documentation moved to xhtml.</td>
				</tr>
			</tbody>
		</table>
		<p xmlns="http:/www.w3.org/1999/xhtml">XProc script to unzip a word docx document,
			extract metadata and convert to DocBook xml</p>
	</p:documentation>

	<p:option name="package-url" required="true">
		<p:documentation>
			<p  xmlns="http:/www.w3.org/1999/xhtml">A URL point to the docx file to be converted
				to XML</p>
		</p:documentation>
	</p:option>

	<p:input port="manifest" kind="document">
		<p:documentation><p xmlns="http:/www.w3.org/1999/xhtml">The manifest file list the xslt
				stylesheets to be applied in turn to the result of converting the docx file to a
				portmanteau xml file.</p></p:documentation>
	</p:input>


	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="docx2xml.xpl"/>
	<p:import href="load-sequence-from-file.xpl"/>
	<p:import href="recursive-xslt.xpl"/>


	<!-- Extract docx file to a wrapped xml file -->
	<ccproc:docx2xml name="extract-document">
		<p:with-option name="package-url" select="$package-url"/>
	</ccproc:docx2xml>

	<!-- Use the recursive xslt tools to process the manifest
    listing of xslt files. -->
	<ccproc:load-sequence-from-file name="load-stylesheets">
		<p:input port="source">
			<p:pipe port="manifest" step="wordToDocBook"/>
		</p:input>
	</ccproc:load-sequence-from-file>

	<ccproc:recursive-xslt name="convert-to-docbook">
		<p:input port="source">
			<p:pipe port="result" step="extract-document"/>
		</p:input>
		<p:input port="stylesheets">
			<p:pipe port="result" step="load-stylesheets"/>
		</p:input>
	</ccproc:recursive-xslt>

</p:pipeline>
