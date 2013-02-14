<p:library version="1.0" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:p="http://www.w3.org/ns/xproc" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps">

	<p:declare-step name="recursive-xslt" type="ccproc:recursive-xslt"
		exclude-inline-prefixes="#all">

		<p:documentation>
			<p xmlns="http:/wwww.w3.org/1999/xhtml">This step takes a sequence of transformation
				elements and executes them recursively applying the each stylesheet to the result of
				the previous stylesheet. The final result is the result of applying all the
				stylesheets in turn to the input document.</p>
		</p:documentation>

		<p:input port="source" sequence="false" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The primary input for the step is the
					document to be transformed.</p>
			</p:documentation>
		</p:input>

		<p:input port="stylesheets" sequence="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The secondary input port for the step
					contains the sequence of xslt stylesheets (already loaded) to be executed.</p>
			</p:documentation>
		</p:input>

		<p:output port="result" primary="true">
			<p:documentation>
				<p xmlns="http://www.w3.org/1999/xhtml">The output of the step is the transformed
					document.</p>
			</p:documentation>
		</p:output>
	
		<p:option name="counter" select="number(0)"/>		<!-- used for debug -->

		<!-- Split of the first transformation from the sequence -->
		<p:split-sequence name="split-stylesheets" initial-only="true" test="position()=1">
			<p:input port="source">
				<p:pipe port="stylesheets" step="recursive-xslt"/>
			</p:input>
		</p:split-sequence>



		<!-- How many of these are left? We actually only care to know  if there are *any* hence the limit. -->
		<p:count name="count-remaining-transformations" limit="1">
			<p:input port="source">
				<p:pipe port="not-matched" step="split-stylesheets"/>
			</p:input>
		</p:count>

		<!-- Ignore the result for now -->
		<p:sink/>

		<p:xslt name="run-single-xslt">
			<p:input port="source">
				<p:pipe port="source" step="recursive-xslt"/>
			</p:input>
			<p:input port="stylesheet">
				<p:pipe port="matched" step="split-stylesheets"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
		
		<p:store>
			<p:input port="source">
				<p:pipe port="result" step="run-single-xslt"/>
			</p:input>
			<p:with-option name="href" select="concat('/tmp/', $counter, '.xml')"/>
		</p:store>

		<!-- If there are any remaining stylesheets recurse. The primary
    	input is the result of our XSLT and the remaining
    	sequence from split-transformations above will be the 
    	transformation sequence 
   		-->
		<p:choose name="determine-recursion">

			<p:xpath-context>
				<p:pipe port="result" step="count-remaining-transformations"/>
			</p:xpath-context>
			
			

			<!-- If we have any transformations remaining recurse -->
			<p:when test="number(c:result)>0">

				<ccproc:recursive-xslt>

					<p:input port="stylesheets">
						<p:pipe port="not-matched" step="split-stylesheets"/>
					</p:input>
					
					<p:input port="source">
						<p:pipe port="result" step="run-single-xslt"/>
					</p:input>
					
					<p:with-option name="counter" select="number($counter) + 1"/>

				</ccproc:recursive-xslt>

			</p:when>

			<!-- Otherwise, pass the output of our transformation back as the result -->
			<p:otherwise>

				<p:identity>
					<p:input port="source">
						<p:pipe port="result" step="run-single-xslt"/>
					</p:input>
				</p:identity>

			</p:otherwise>

		</p:choose>

	</p:declare-step>



</p:library>
