## Word conversion ##
Structured authoring is not user friendly. Few of our clients appear to want to use structured authoring — they want to use Word files. Modern Word files are zip archives containing XML. That means we can extract their content and convert it (with some effort) into structure XML of some sort.

Our project started as a tool for converting Word files to DocBook but the project scope didn't fit the existing tools available. So, we wrote one. Then another client wanted to do something very similar. We repurposed the code and wrote the tool for that client. The difference between the two projects was basically the set of named styles used. Unsurprisingly, a third client wanted something similar. And … we repurposed the code. At that point it became pretty clear that we should be separating the common parts of this tool out into some sort of framework. The end result is the docx2xml XProc pipeline. docx2xml is a pipeline designed to make conversion from styled Word files to someesort of structured XML as simple as possible.

## Building word conversions ##
The word2xml framework starts by extracting the individual XML files from the docx archive and wrapping them into a single document:

    <word-doc xmlns="http://www.corbas.co.uk/ns/word">
        <!--  xml files from docx -->
	</word-doc>
You create a particular XML conversion (DocBook, XHTML, etc) by providing a manifest  containing one or more (generally more) XSLT stylesheets. The wrapped word document is passed through these stylesheets until a final result is achieved. 

Generally, we've found that a process of progressive improvement gives the best results. We've also found that certain processes are common to most conversions. As a result we've built a couple of helpers for the process. 

Both of the helpers are tools that read a configuration file and use XSLT to generate another XSLT file which is then applied to the document. That means that repetitive tasks can be done without writing repetitive XSLT. 

### Structural Mappings
The first helper is designed to simplify the process of converting from Word elements to elements in the desired output language. One of the things we learned during out experiments was that early conversion to elements of the target language makes the conversion simpler. So we have defined a mapping file that looks something like:

	<map 
		xmlns="http://www.corbas.co.uk/ns/transforms/data"
		source-attribute="role" 
		ns="http://docbook.org/ns/docbook" 
		source-element="para">
		<mapping 
			source-value="doc-title" 
			target-element="title" 
			hint="doc-title" heading-level="0"/>
				
		<mapping 
			source-value="heading1" 
			target-element="title" 
			heading-level="1"/>
	
		<mapping
			source-value="blockquote"
			target-element="blockquote para"
		/>
	</map>
	
There's a RelaxNG schema for this mapping XML so that we can validate it. This particular map is part of a Word to DocBook conversion. This is evaluated immediately after the Word XML has been mapped to DocBook elements. We converted Word `p` elements to DocBook `para` elements placing the Word style name into the DocBook element's `role` attribute. 

The result of processing this mapping file is XSLT that  examines `para` elements and converts based on the value of the `role` attribute. Those are driven by the `source-element` and `source-attribute` attributes of the `map` element.  For example, the first mapping element will translate to the following XSLT:

	<xsl:template match="para[@role = 'doc-title']">
		<title cword:hint="doc-title" cword:level="0">
			<xsl:apply-templates select="@*[local-name() = 'id']"/>
			<xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
			<xsl:apply-templates select="node()"/>
		</title>
	</xsl:template>

The internals are not too important but you can see that we refined a title marked up as a style paragraph to a (more appropriate) `title` element. The finale `mapping` element demonstrates that multiple elements can be generated as well.  That mapping generates the following XSLT:

	<xsl:template match="para[@role = 'blockquote']">
		<blockquote>
			<para>
			<xsl:apply-templates select="@*[local-name() = 'id']"/>
			<xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
			<xsl:apply-templates select="node()"/>
			</para>
		</blockquote>
	</xsl:template>

The whole purpose of these mappings is to simplify the processing because conversion often requires these simple and very repetitive steps. This simple `map` format can do rather more than we've just shown but that will do for a demonstration. 

### Content Driven Mappings ###

The second conversion helper operates on content to do text driven conversions. We found that some conversions from Word needed to rely on the presence of particular patterns in content (for example, "Chapter 1" in the text might drive the conversion of an element to `title` from `para`).

	<map 
		xmlns="http://www.corbas.co.uk/ns/transforms/content-map"
		xmlns:map="http://www.corbas.co.uk/ns/transforms/content-map">
		<mapping 
			node="section" 
			context="h1">
		<starts-with>Notes</starts-with>
		<output>
        	<section class="notes" xmlns="http://www.w3.org/1999/xhtml"><map:apply/></section>
        </output>
    	</mapping>
		
		<mapping 
			node="section"
			context="h1[@role='title']">
			<starts-with>Chapter</starts-with>
			<starts-with>Part</starts-with>
			<output>
				<article xmlns="http://www.w3.org/1999/xhtml"><map:apply/><article>
			</output>
		</mapping>
	</map>
	
The mappings above are part of a conversion from Word to XHTML 5. They improve the semantics for particular components. Again, the `mapping` elements are compiled to XSLT 2.0  which is then applied to the input. For example, the second mapping generates the following XSLT:

	 <xsl:template match="section[starts-with(h1[@class='title'], 'Chapter')]">
	 	<article>
	 		<xsl:apply-templates/>
		</article>
      </xsl:template>

	 <xsl:template match="section[starts-with(h1[@class='title'], 'Part')]">
	 	<article>
	 		<xsl:apply-templates/>
		</article>
      </xsl:template>
		
One of our clients (a legal publisher) found that much of their output XML was driven by content in the Word document so this tool simplified their processing no end.

### The Manifest ###

The conversion process is driven by the manifest file. The manifest file lists XSL stylesheets that are to be applied to the content in sequence (where the output of one stylesheet is the input to the next).  Originally, we processed the two helper formats externally until we realised that a simple extension to the manifest would let us integrate the mapping file to XSLT conversion.

The manifest is a list of either `item` or `processed-item` elements:

	<manifest xmlns="http://www.corbas.co.uk/ns/transforms/data" xml:base="../../../">
		<item href="word-to-xml/xslt/rationalise-word-numbering.xsl"/>
		<item href="word-to-xml/xslt/word-to-xhtml5-elements.xsl"/>
		<item href="word-to-xml/xslt/refactor-lists.xsl"/>
		<processed-item stylesheet="word-to-xml/xslt/build-mapping-stylesheet.xsl">
			<item href="config/word-to-xhtml5-mapping.xml"/>
		</processed-item>
	
		<item href="models/word-to-xml/xslt/insert-sections.xsl"/>
	
		<processed-item stylesheet="word-to-xml/xslt/build-content-mapping-stylesheet.xsl">
			<item href="config/word-to-xhtml5-content-mapping.xml"/>
		</processed-item>
	
		<item href="models/word-to-xml/xslt/strip-non-xhtml.xsl"/>
	</manifest>

`item` elements are simply XSLT files. `processed-item` elements wrap `item` elements with an XSLT stylesheet to apply to it. When the manifest is loaded `processed-item` elements are processed and the resulting XSLT file is used.

The source document is loaded and passed to the first stylesheet. The result is then passed to the next stylesheet and so on. 

### Using the Framework ###

Using the framework simply requires writing a manifest and mapping files.  We have provided manifests that convert standard Word documents to DocBook and XHTML 5 as examples.