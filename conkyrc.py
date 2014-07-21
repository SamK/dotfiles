#!/usr/bin/env python
import jinja2


templateLoader = jinja2.FileSystemLoader( searchpath="." )

# An environment provides the data necessary to read and
#   parse our templates.  We pass in the loader object here.
templateEnv = jinja2.Environment( loader=templateLoader )

TEMPLATE_FILE = "conkyrc.jinja"
template = templateEnv.get_template( TEMPLATE_FILE )


# Specify any input variables to the template as a dictionary.

maximum_width = 320

templateVars = { "maximum_width"      : str(maximum_width),
                 "graph_width"        : str(maximum_width),
                 "graph_width_small"  : str(int(maximum_width/2)),
                 "graph_height"       : "24",
                 "graph_height_small" : "24",
                 "bar_width"          : str(maximum_width),
                 "bar_width_small"    : "155",
                 "bar_height"         : "12",
                 "bar_height_half"    : "12",
                 "color_term"         : "grey",
                 "color_value"        : "FFFFFF",
                 "color_graph1"       : "F700FF",
                 "color_graph2"       : "FFFFFF",
}

# Finally, process the template to produce our final text.
outputText = template.render( templateVars )
print outputText.encode('utf-8')
