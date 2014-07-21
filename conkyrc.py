#!/usr/bin/env python
import jinja2
import os

templateLoader = jinja2.FileSystemLoader( searchpath=".")

# An environment provides the data necessary to read and
#   parse our templates.  We pass in the loader object here.
templateEnv = jinja2.Environment(loader=templateLoader,
                                 block_start_string = '<%',
                                 block_end_string = '%>',
                                 variable_start_string = '<<',
                                 variable_end_string = '>>',
                                 comment_start_string = '<#',
                                 comment_end_string = '#>'
)


TEMPLATE_FILE = "conkyrc.jinja"
template = templateEnv.get_template( TEMPLATE_FILE )


# Specify any input variables to the template as a dictionary.

def has_battery():
    battery_dir = '/sys/class/power_supply/BAT0'
    return os.path.exists(battery_dir) and os.listdir(battery_dir)

def has_hwmon():
    hwmon_dir = '/sys/class/hwmon'
    return os.path.exists(hwmon_dir) and  os.listdir(hwmon_dir)

def get_drives():
    drives = []
    fname = '/proc/partitions'
    with open(fname) as f:
        content = f.readlines()

    for line in content[2:]:
        elements = line.split()
        partition = elements[-1]
        if partition[-1].isalpha():
            drives.append('/dev/' + partition)
    return drives

def get_interfaces():
    interfaces = []
    fname = '/proc/net/dev'
    with open(fname) as f:
        content = f.readlines()
    for line in content[2:]:
        iface = line.split()[0]
        interfaces.append(iface[:-1])
    return sorted(interfaces)


def get_filesystems():
    filesystems = []
    fname = '/etc/mtab'
    exclude = ['debugfs', 'sysfs', 'fusectl', 'binfmt_misc', 'proc',
               'securityfs', 'devpts', 'tmpfs', 'devtmpfs', 'fuse.gvfs-fuse-daemon']
    with open(fname) as f:
        content = f.readlines()
    for line in content:
        el = line.split()
        if el[2] not in exclude:
            filesystems.append({'device': el[0], 'mountpoint': el[1], 'fstype': el[2]})

    return filesystems

maximum_width = 320

templateVars = { "maximum_width"      : str(maximum_width),
                 "graph_width"        : str(maximum_width),
                 "graph_width_small"  : str(int(maximum_width/2)-15),
                 "graph_height"       : "24",
                 "graph_height_small" : "24",
                 "bar_width"          : str(maximum_width),
                 "bar_width_small"    : "155",
                 "bar_height"         : "12",
                 "bar_height_small"   : "12",
                 "color_term"         : "grey",
                 "color1"             : "grey",
                 "color2"             : "FFFFFF",
                 "color_graph1"       : "FFFFFF",
                 "color_graph2"       : "F700FF",
                 "battery"            : has_battery(),
                 "hwmon"              : has_hwmon(),
                 "drives"             : get_drives(),
                 "filesystems"        : get_filesystems(),
                 "interfaces"         : get_interfaces(),
                 "bg_transparent"     : False,
}

# Finally, process the template to produce our final text.
outputText = template.render( templateVars )
print outputText.encode('utf-8')
