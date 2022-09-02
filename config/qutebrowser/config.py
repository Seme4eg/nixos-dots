import os
import glob

config.load_autoconfig(False)

###############################################################################
#                                   Imports                                   #
###############################################################################

# for path in glob.glob(os.path.expanduser('~/.config/qutebrowser/extra/*.py')):
#     config.source(path)

## Load theme
# config.source('theme-nord.py')
config.source('theme-gruvbox.py')
config.source('bindings.py')
config.source('fonts.py')
config.source('userscripts.py')

## Per-domain settings
c.content.user_stylesheets = glob.glob(os.path.expanduser('~/.local/share/qutebrowser/userstyles.css'))


###############################################################################
#                                  Misc Vars                                  #
###############################################################################

# Open every tab as a new window, Vimb style
# c.tabs.tabs_are_windows = True
c.tabs.show       = "multiple"
c.tabs.last_close = "close"
c.tabs.select_on_remove = "last-used"

c.auto_save.session         = True
c.scrolling.smooth          = True
c.session.lazy_restore      = True
c.content.autoplay          = False
c.content.pdfjs             = True
c.content.plugins           = True # why is it false by default?
c.completion.use_best_match = True
c.completion.height = "20%"
# c.downloads.location.prompt = False
c.downloads.location.directory = os.path.expanduser("~/Downloads")
c.downloads.position = 'bottom'

## Adblocking
# Use (superior) Brave adblock if available, or fall back to host blocking
c.content.blocking.method = "auto"
c.content.blocking.hosts.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
    'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext'
    # 'https://www.malwaredomainlist.com/hostslist/hosts.txt',
    # 'http://someonewhocares.org/hosts/hosts',
    # 'http://winhelp2002.mvps.org/hosts.zip',
    # 'http://malwaredomains.lehigh.edu/files/justdomains.zip',
]
# c.content.blocking.whitelist = []

# Scale pages and UI better for hidpi
c.qt.highdpi  = True
# c.zoom.default = 175

# Automatically turn on insert mode when a loaded page focuses a text field
c.input.insert_mode.auto_load = True

c.hints.selectors["code"] = [
    # Selects all code tags whose direct parent is not a pre tag
    ":not(pre) > code",
    "pre"
]

# XXX: idk bout that, testing
# c.input.links_included_in_focus_chain = False
c.new_instance_open_target = 'tab-silent'
c.prompt.filebrowser = False
c.prompt.radius = 0

c.spellcheck.languages = ['en-US', 'ru-RU']
c.session.lazy_restore = True
c.tabs.show = 'multiple'

# Use external editor
# Edit fields in Emacs with Ctrl+E
c.editor.command = ['emacsclient', '-c', '-F', '((name . "qutebrowser-editor"))', '+{line}:{column}', '{}']
# c.editor.command = ["emacsclient", "+{line}:{column}", "{file}"]
c.editor.encoding = 'utf-8'
# Though we set it, I use the more specialzied emacs-everywhere instead
# config.bind('<Ctrl+E>',    'edit-text', mode='insert')
# config.bind('<Ctrl+E>',    'hint inputs --first ;; edit-text', mode='normal')


###############################################################################
#                                    Theme                                    #
###############################################################################

# Use dark mode where possible
c.colors.webpage.darkmode.algorithm        = "lightness-cielab"
c.colors.webpage.preferred_color_scheme    = "dark"
c.colors.webpage.darkmode.enabled          = True
# c.colors.webpage.preferred_color_scheme  = "light"
# c.colors.webpage.darkmode.enabled        = False
# c.colors.webpage.darkmode.threshold.text = 230
# c.colors.webpage.darkmode.policy.images  = "never"
# c.colors.webpage.bg                      = "black"

