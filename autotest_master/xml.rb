require 'rexml/document'

file = File.new("test.xml", "w+")

doc = REXML::Document.new

element = doc.add_element('book', {'name' => 'programming', 'author' => "joe chu"})
chapter1 = element.add_element("chapter",{"title"=>'chapter 1'})

chapter1.add_text "chapter 1 content"

doc.write
file.puts doc.write


<book author='joe chu' name='programming'>
	<chapter title='chapter 1'>chapter 1 content</chapter>
</book>
<book author='joe chu' name='programming'>
	<chapter title='chapter 1'>chapter 1 content</chapter>
</book>