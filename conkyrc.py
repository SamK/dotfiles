#!/usr/bin/env python
import jinja2


templateLoader = jinja2.FileSystemLoader( searchpath="." )

# An environment provides the data necessary to read and
#   parse our templates.  We pass in the loader object here.
templateEnv = jinja2.Environment( loader=templateLoader )

TEMPLATE_FILE = "conkyrc.jinja"
template = templateEnv.get_template( TEMPLATE_FILE )


# Specify any input variables to the template as a dictionary.
templateVars = { "title" : "Test Example",
                 "description" : "A simple inquiry of function." }

# Finally, process the template to produce our final text.
outputText = template.render( templateVars )
print outputText.encode('utf-8')
