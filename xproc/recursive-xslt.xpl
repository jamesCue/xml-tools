<p:library version="1.0" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:p="http://www.w3.org/ns/xproc" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps">

	<p:declare-step name="recursive-xslt" type="ccproc:recursive-xslt"
		exclude-inline-prefixes="#all">

		<p:documentation>
			<p xmlns="http:/wwww.w3.org/1999/xhtml">This step takes a sequence of transformation
				elements (see <a href="doxconv.rnc">docxconv.rnc</a>) and executes them recursively
				applying the each stylesheet to the result of the previous stylesheet. The final
				result is the result of applying all the stylesheets in turn to the input
				document.</p>
		</p:documentation>

		<p:input port="source" sequence="false" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The primary input for the step is the
					document to be transformed.</p>
			</p:documentation>
		</p:input>

		<p:input port="transformations" sequence="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The secondary input port for the step
					contains the sequence of transformation elements to be executed.</p>
			</p:documentation>
		</p:input>

		<p:output port="result" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The output of the step is the transformed
					document.</p>
			</p:documentation>
		</p:output>

		<!-- Split of the first transformation from the sequence -->
		<p:split-sequence name="split-transformations" initial-only="true" test="position()=1">
			<p:input port="source">
				<p:pipe port="transformations" step="recursive-xslt"/>
			</p:input>
		</p:split-sequence>

		<!-- How many of these are left? We actually only care to know
	if there are *any* hence the limit. -->
		<p:count name="count-remaining-transformations" limit="1">
			<p:input port="source">
				<p:pipe port="not-matched" step="split-stylesheets"/>
			</p:input>
		</p:count>

		<!-- Ignore the result for now -->
		<p:sink/>

		<p:xslt>
			<p:input port="source">
				<p:pipe port="source" step="main"/>
			</p:input>
			<p:input port="stylesheet">
				<p:pipe port="matched" step="split-stylesheets"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>

		<!-- If there are any remaining stylesheets recurse. The primary
    	input is the result of our XSLT and the remaining
    	sequence from split-transformations above will be the 
    	transformation sequence 
   	-->
		<p:choose>

			<p:xpath-context>
				<p:pipe port="result" step="count-remaining-transformation"/>
			</p:xpath-context>

			<!-- If we have any transformations remaining recurse -->
			<p:when test="number(c:result)>0">

				<ccproc:recursive-xslt>

					<p:input port="transformations">
						<p:pipe port="not-matched" step="split-stylesheets"/>
					</p:input>

				</ccproc:recursive-xslt>

			</p:when>

			<!-- Otherwise, pass the output of our transformation back as the result -->
			<p:otherwise>

				<p:identity/>

			</p:otherwise>

		</p:choose>

	</p:declare-step>
	
	<p:declare-step type="ccproc:logged-transformation" name="logged-transformation">
		
		
		<p:documentation>
			<p xmlns="http:/wwww.w3.org/1999/xhtml">This step is used by the 
			recursive-xslt step to execute and log transformations.</p>
		</p:documentation>
		
		<p:input primary="true" port="source">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The primary input for the step is the
					document to be transformed.</p>
			</p:documentation>			
		</p:input>
		
		<p:input port="transformation">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The secondary input for the step is
				a <code>transformation element</code> as defined in <a href="docxconv.rnc">docxconv.rnc</a>.
				Note that the elements are flattened, groups removed and defaults made explicit before this
				step so the input transformation must have all relevant attributes (including ancestral
				logging attributes).</p>
			</p:documentation>
		</p:input>
		
		
		
	</p:declare-step>

</p:library>
