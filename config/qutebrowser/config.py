import os
import glob

config.load_autoconfig(False)

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

## Load theme
for path in glob.glob(os.path.expanduser('~/.config/qutebrowser/extra/*.py')):
    config.source(path)

## Per-domain settings
c.content.user_stylesheets = glob.glob(os.path.expanduser('~/.local/share/qutebrowser/userstyles.css'))

###############################################################################
#                                    Fonts                                    #
###############################################################################

# Fonts
monospace                   = "11pt Roboto"
c.fonts.completion.category = f"bold {monospace}"
c.fonts.completion.entry    = monospace
c.fonts.debug_console       = monospace
c.fonts.downloads           = monospace
c.fonts.keyhint             = monospace
c.fonts.messages.error      = monospace
c.fonts.messages.info       = monospace
c.fonts.messages.warning    = monospace
c.fonts.prompts             = monospace
c.fonts.statusbar           = monospace
c.fonts.tabs.selected       = monospace
c.fonts.tabs.unselected     = monospace
c.fonts.hints               = "bold 13px 'DejaVu Sans Mono'"
# c.fonts.hints = monospace

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

###############################################################################
#                                 Userscripts                                 #
###############################################################################

# TODO: i don't want to lose all other aliases
c.aliases = {
    "json": "spawn --userscript json_format native",
    # for alias below -> config.bind('o', 'dmenu')
    # "dmenu": "spawn --userscript dmenu_qutebrowser" # doesn't work
    "sd": "spawn --userscript open_download",
}

###############################################################################
#                                   Bindings                                  #
###############################################################################

# Universal Emacsien C-g alias for Escape
config.bind('<Ctrl-g>', 'clear-keychain ;; search ;; fullscreen --leave')
for mode in ['caret', 'command', 'hint', 'insert', 'passthrough', 'prompt', 'register']:
    config.bind('<Ctrl-g>', 'mode-enter normal')

config.bind('sd',  'sd')
config.bind(',r',  'spawn --userscript readability')
config.bind(',qr', 'spawn --userscript qr')
config.bind(',tp', 'spawn --userscript translate -t ru') # translate page
config.bind(',tt', 'spawn --userscript translate -t ru --text')
config.bind(';s',  'hint code userscript code_select')

# qute-pass
config.bind('zl',  'spawn --userscript qute-pass')
config.bind('zul', 'spawn --userscript qute-pass --username-only')
config.bind('zpl', 'spawn --userscript qute-pass --password-only')
config.bind('zol', 'spawn --userscript qute-pass --otp-only')

config.bind(',v', 'spawn ~/.config/mpv/umpv {url}')
config.bind(',V', 'hint links spawn ~/.config/mpv/umpv {hint-url}')
config.bind(';V', 'hint --rapid links spawn ~/.config/mpv/umpv {hint-url}')
# config.bind(';V', 'hint links spawn mpv {hint-url}') # XXX use it instead of top 3 lines?

config.bind('sr', 'config-source')
config.bind('tm', 'tab-mute')
# config.bind('wi', 'devtools right') # XXX needed or default?
config.bind("gI", "hint inputs")
config.bind('<Ctrl-e>', 'scroll down')
config.bind('<Ctrl-y>', 'scroll up')
config.bind('<Ctrl-[>', 'mode-leave', mode='passthrough')
# config.unbind('d') # Don't close window on lower-case 'd'

# promt mode
config.bind('<Ctrl-p>', 'prompt-item-focus prev', mode='prompt')
config.bind('<Ctrl-n>', 'prompt-item-focus next', mode='prompt')
# config.bind('n',      'prompt-accept no',       mode='prompt')
# config.bind('y',      'prompt-accept yes',      mode='prompt')

# Vim-style movement keys in command mode
config.bind('<Ctrl-j>', 'completion-item-focus --history next', mode='command')
config.bind('<Ctrl-k>', 'completion-item-focus --history prev', mode='command')


## Ex-commands


## Bindings for normal mode
# config.bind("'", 'enter-mode jump_mark')
# config.bind('+', 'zoom-in')
# config.bind('-', 'zoom-out')
# config.bind('.', 'repeat-command')
# config.bind('/', 'set-cmd-text /')
# config.bind(':', 'set-cmd-text :')
# config.bind(';I', 'hint images tab')
# config.bind(';O', 'hint links fill :open -t -r {hint-url}')
# config.bind(';R', 'hint --rapid links window')
# config.bind(';Y', 'hint links yank-primary')
# config.bind(';b', 'hint all tab-bg')
# config.bind(';d', 'hint links download')
# config.bind(';f', 'hint all tab-fg')
# config.bind(';h', 'hint all hover')
# config.bind(';i', 'hint images')
# config.bind(';o', 'hint links fill :open {hint-url}')
# config.bind(';r', 'hint --rapid links tab-bg')
# config.bind(';t', 'hint inputs')
# config.bind(';y', 'hint links yank')
# config.bind('<Alt-1>', 'tab-focus 1')
# config.bind('<Alt-2>', 'tab-focus 2')
# config.bind('<Alt-3>', 'tab-focus 3')
# config.bind('<Alt-4>', 'tab-focus 4')
# config.bind('<Alt-5>', 'tab-focus 5')
# config.bind('<Alt-6>', 'tab-focus 6')
# config.bind('<Alt-7>', 'tab-focus 7')
# config.bind('<Alt-8>', 'tab-focus 8')
# config.bind('<Alt-9>', 'tab-focus -1')
# config.bind('<Ctrl-A>', 'navigate increment')
# config.bind('<Ctrl-Alt-p>', 'print')
# config.bind('<Ctrl-B>', 'scroll-page 0 -1')
# config.bind('<Ctrl-D>', 'scroll-page 0 0.5')
# config.bind('<Ctrl-F5>', 'reload -f')
# config.bind('<Ctrl-F>', 'scroll-page 0 1')
# config.bind('<Ctrl-N>', 'open -w')
# config.bind('<Ctrl-PgDown>', 'tab-next')
# config.bind('<Ctrl-PgUp>', 'tab-prev')
# config.bind('<Ctrl-Q>', 'quit')
# config.bind('<Ctrl-Return>', 'follow-selected -t')
# config.bind('<Ctrl-Shift-N>', 'open -p')
# config.bind('<Ctrl-Shift-T>', 'undo')
# config.bind('<Ctrl-Shift-W>', 'close')
# config.bind('<Ctrl-T>', 'open -t')
# config.bind('<Ctrl-Tab>', 'tab-focus last')
# config.bind('<Ctrl-U>', 'scroll-page 0 -0.5')
# config.bind('<Ctrl-V>', 'enter-mode passthrough')
# config.bind('<Ctrl-W>', 'tab-close')
# config.bind('<Ctrl-X>', 'navigate decrement')
# config.bind('<Ctrl-^>', 'tab-focus last')
# config.bind('<Ctrl-h>', 'home')
# config.bind('<Ctrl-p>', 'tab-pin')
# config.bind('<Ctrl-s>', 'stop')
# config.bind('<Escape>', 'clear-keychain ;; search ;; fullscreen --leave')
# config.bind('<F11>', 'fullscreen')
# config.bind('<F5>', 'reload')
# config.bind('<Return>', 'follow-selected')
# config.bind('<back>', 'back')
# config.bind('<forward>', 'forward')
# config.bind('=', 'zoom')
# config.bind('?', 'set-cmd-text ?')
# config.bind('@', 'run-macro')
# config.bind('B', 'set-cmd-text -s :quickmark-load -t')
# config.bind('D', 'tab-close -o')
# config.bind('F', 'hint all tab')
# config.bind('G', 'scroll-to-perc')
# config.bind('H', 'back')
# config.bind('J', 'tab-next')
# config.bind('K', 'tab-prev')
# config.bind('L', 'forward')
# config.bind('M', 'bookmark-add')
# config.bind('N', 'search-prev')
# config.bind('O', 'set-cmd-text -s :open -t')
# config.bind('PP', 'open -t -- {primary}')
# config.bind('Pp', 'open -t -- {clipboard}')
# config.bind('R', 'reload -f')
# config.bind('Sb', 'open qute://bookmarks#bookmarks')
# config.bind('Sh', 'open qute://history')
# config.bind('Sq', 'open qute://bookmarks')
# config.bind('Ss', 'open qute://settings')
# config.bind('T', 'tab-focus')
# config.bind('ZQ', 'quit')
# config.bind('ZZ', 'quit --save')
# config.bind('[[', 'navigate prev')
# config.bind(']]', 'navigate next')
# config.bind('`', 'enter-mode set_mark')
# config.bind('ad', 'download-cancel')
# config.bind('b', 'set-cmd-text -s :quickmark-load')
# config.bind('cd', 'download-clear')
# config.bind('co', 'tab-only')
# config.bind('d', 'tab-close')
# config.bind('f', 'hint')
# config.bind('g$', 'tab-focus -1')
# config.bind('g0', 'tab-focus 1')
# config.bind('gB', 'set-cmd-text -s :bookmark-load -t')
# config.bind('gC', 'tab-clone')
# config.bind('gO', 'set-cmd-text :open -t -r {url:pretty}')
# config.bind('gU', 'navigate up -t')
# config.bind('g^', 'tab-focus 1')
# config.bind('ga', 'open -t')
# config.bind('gb', 'set-cmd-text -s :bookmark-load')
# config.bind('gd', 'download')
# config.bind('gf', 'view-source')
# config.bind('gg', 'scroll-to-perc 0')
# config.bind('gl', 'tab-move -')
# config.bind('gm', 'tab-move')
# config.bind('go', 'set-cmd-text :open {url:pretty}')
# config.bind('gr', 'tab-move +')
# config.bind('gt', 'set-cmd-text -s :buffer')
# config.bind('gu', 'navigate up')
# config.bind('h', 'scroll left')
# config.bind('i', 'enter-mode insert')
# config.bind('j', 'scroll down')
# config.bind('k', 'scroll up')
# config.bind('l', 'scroll right')
# config.bind('m', 'quickmark-save')
# config.bind('n', 'search-next')
# config.bind('o', 'set-cmd-text -s :open')
# config.bind('pP', 'open -- {primary}')
# config.bind('pp', 'open -- {clipboard}')
# config.bind('q', 'record-macro')
# config.bind('r', 'reload')
# config.bind('sf', 'save')
# config.bind('sk', 'set-cmd-text -s :bind')
# config.bind('sl', 'set-cmd-text -s :set -t')
# config.bind('ss', 'set-cmd-text -s :set')
# config.bind('th', 'back -t')
# config.bind('tl', 'forward -t')
# config.bind('u', 'undo')
# config.bind('v', 'enter-mode caret')
# config.bind('wB', 'set-cmd-text -s :bookmark-load -w')
# config.bind('wO', 'set-cmd-text :open -w {url:pretty}')
# config.bind('wP', 'open -w -- {primary}')
# config.bind('wb', 'set-cmd-text -s :quickmark-load -w')
# config.bind('wf', 'hint all window')
# config.bind('wh', 'back -w')
# config.bind('wi', 'inspector')
# config.bind('wl', 'forward -w')
# config.bind('wo', 'set-cmd-text -s :open -w')
# config.bind('wp', 'open -w -- {clipboard}')
# config.bind('xO', 'set-cmd-text :open -b -r {url:pretty}')
# config.bind('xb', 'config-cycle statusbar.hide')
# config.bind('xo', 'set-cmd-text -s :open -b')
# config.bind('xt', 'config-cycle tabs.show always switching')
# config.bind('xx', 'config-cycle statusbar.hide ;; config-cycle tabs.show always switching')
# config.bind('yD', 'yank domain -s')
# config.bind('yP', 'yank pretty-url -s')
# config.bind('yT', 'yank title -s')
# config.bind('yY', 'yank -s')
# config.bind('yd', 'yank domain')
# config.bind('yp', 'yank pretty-url')
# config.bind('yt', 'yank title')
# config.bind('yy', 'yank')
# config.bind('{{', 'navigate prev -t')
# config.bind('}}', 'navigate next -t')

## Bindings for caret mode
# config.bind('$', 'move-to-end-of-line', mode='caret')
# config.bind('0', 'move-to-start-of-line', mode='caret')
# config.bind('<Ctrl-Space>', 'drop-selection', mode='caret')
# config.bind('<Escape>', 'leave-mode', mode='caret')
# config.bind('<Return>', 'yank selection', mode='caret')
# config.bind('<Space>', 'toggle-selection', mode='caret')
# config.bind('G', 'move-to-end-of-document', mode='caret')
# config.bind('H', 'scroll left', mode='caret')
# config.bind('J', 'scroll down', mode='caret')
# config.bind('K', 'scroll up', mode='caret')
# config.bind('L', 'scroll right', mode='caret')
# config.bind('Y', 'yank selection -s', mode='caret')
# config.bind('[', 'move-to-start-of-prev-block', mode='caret')
# config.bind(']', 'move-to-start-of-next-block', mode='caret')
# config.bind('b', 'move-to-prev-word', mode='caret')
# config.bind('c', 'enter-mode normal', mode='caret')
# config.bind('e', 'move-to-end-of-word', mode='caret')
# config.bind('gg', 'move-to-start-of-document', mode='caret')
# config.bind('h', 'move-to-prev-char', mode='caret')
# config.bind('j', 'move-to-next-line', mode='caret')
# config.bind('k', 'move-to-prev-line', mode='caret')
# config.bind('l', 'move-to-next-char', mode='caret')
# config.bind('v', 'toggle-selection', mode='caret')
# config.bind('w', 'move-to-next-word', mode='caret')
# config.bind('y', 'yank selection', mode='caret')
# config.bind('{', 'move-to-end-of-prev-block', mode='caret')
# config.bind('}', 'move-to-end-of-next-block', mode='caret')

## Bindings for command mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='command')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='command')
# config.bind('<Alt-D>', 'rl-kill-word', mode='command')
# config.bind('<Alt-F>', 'rl-forward-word', mode='command')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='command')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='command')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='command')
# config.bind('<Ctrl-D>', 'completion-item-del', mode='command')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='command')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='command')
config.bind('<Ctrl-B>', 'rl-backward-word', mode='command')
config.bind('<Ctrl-F>', 'rl-forward-word', mode='command')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='command')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='command')
# config.bind('<Ctrl-N>', 'command-history-next', mode='command')
# config.bind('<Ctrl-P>', 'command-history-prev', mode='command')
# config.bind('<Ctrl-Shift-Tab>', 'completion-item-focus prev-category', mode='command')
# config.bind('<Ctrl-Tab>', 'completion-item-focus next-category', mode='command')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='command')
# config.bind('<Ctrl-W>', 'rl-unix-word-rubout', mode='command')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='command')
# config.bind('<Down>', 'command-history-next', mode='command')
# config.bind('<Escape>', 'leave-mode', mode='command')
# config.bind('<Return>', 'command-accept', mode='command')
# config.bind('<Shift-Delete>', 'completion-item-del', mode='command')
# config.bind('<Shift-Tab>', 'completion-item-focus prev', mode='command')
# config.bind('<Tab>', 'completion-item-focus next', mode='command')
# config.bind('<Up>', 'command-history-prev', mode='command')

## Bindings for hint mode
# config.bind('<Ctrl-B>', 'hint all tab-bg', mode='hint')
# config.bind('<Ctrl-F>', 'hint links', mode='hint')
# config.bind('<Ctrl-R>', 'hint --rapid links tab-bg', mode='hint')
# config.bind('<Escape>', 'mode-leave', mode='hint')
# config.bind('<Return>', 'follow-hint', mode='hint')

## Bindings for insert mode
# config.bind('<Ctrl-E>', 'open-editor', mode='insert')
# config.bind('<Escape>', 'leave-mode', mode='insert')
# config.bind('<Shift-Ins>', 'insert-text {primary}', mode='insert')

## Bindings for passthrough mode
# config.bind('<Ctrl-V>', 'leave-mode', mode='passthrough')

## Bindings for prompt mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='prompt')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='prompt')
# config.bind('<Alt-D>', 'rl-kill-word', mode='prompt')
# config.bind('<Alt-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='prompt')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='prompt')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='prompt')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='prompt')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='prompt')
config.bind('<Ctrl-B>', 'rl-backward-word', mode='prompt')
config.bind('<Ctrl-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='prompt')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='prompt')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='prompt')
# config.bind('<Ctrl-W>', 'rl-unix-word-rubout', mode='prompt')
# config.bind('<Ctrl-X>', 'prompt-open-download', mode='prompt')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='prompt')
# config.bind('<Down>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Escape>', 'leave-mode', mode='prompt')
# config.bind('<Return>', 'prompt-accept', mode='prompt')
# config.bind('<Shift-Tab>', 'prompt-item-focus prev', mode='prompt')
# config.bind('<Tab>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Up>', 'prompt-item-focus prev', mode='prompt')
# config.bind('n', 'prompt-accept no', mode='prompt')
# config.bind('y', 'prompt-accept yes', mode='prompt')

## Bindings for register mode
# config.bind('<Escape>', 'leave-mode', mode='register')


###############################################################################
#                                    Theme                                    #
###############################################################################

# --- Nord theme ---

nord = {
    # Polar Night
    'nord0': '#2e3440',
    'nord1': '#3b4252',
    'nord2': '#434c5e',
    'nord3': '#4c566a',
    # Snow Storm
    'nord4': '#d8dee9',
    'nord5': '#e5e9f0',
    'nord6': '#eceff4',
    # Frost
    'nord7': '#8fbcbb',
    'nord8': '#88c0d0',
    'nord9': '#81a1c1',
    'nord10': '#5e81ac',
    # Aurora
    'nord11': '#bf616a',
    'nord12': '#d08770',
    'nord13': '#ebcb8b',
    'nord14': '#a3be8c',
    'nord15': '#b48ead',
}

## Background color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.bg = nord['nord0']

## Bottom border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.bottom = nord['nord0']

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.top = nord['nord0']

## Foreground color of completion widget category headers.
## Type: QtColor
c.colors.completion.category.fg = nord['nord5']

## Background color of the completion widget for even rows.
## Type: QssColor
c.colors.completion.even.bg = nord['nord1']

## Background color of the completion widget for odd rows.
## Type: QssColor
c.colors.completion.odd.bg = nord['nord1']

## Text color of the completion widget.
## Type: QtColor
c.colors.completion.fg = nord['nord4']

## Background color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.bg = nord['nord3']

## Bottom border color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.border.bottom = nord['nord3']

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.item.selected.border.top = nord['nord3']

## Foreground color of the selected completion item.
## Type: QtColor
c.colors.completion.item.selected.fg = nord['nord6']

## Foreground color of the matched text in the completion.
## Type: QssColor
c.colors.completion.match.fg = nord['nord13']

## Color of the scrollbar in completion view
## Type: QssColor
c.colors.completion.scrollbar.bg = nord['nord1']

## Color of the scrollbar handle in completion view.
## Type: QssColor
c.colors.completion.scrollbar.fg = nord['nord5']

## Background color for the download bar.
## Type: QssColor
c.colors.downloads.bar.bg = nord['nord0']

## Background color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.bg = nord['nord11']

## Foreground color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.fg = nord['nord5']

## Color gradient stop for download backgrounds.
## Type: QtColor
c.colors.downloads.stop.bg = nord['nord15']

## Color gradient interpolation system for download backgrounds.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
c.colors.downloads.system.bg = 'none'

## Background color for hints. Note that you can use a `rgba(...)` value
## for transparency.
## Type: QssColor
c.colors.hints.bg = nord['nord13']

## Font color for hints.
## Type: QssColor
c.colors.hints.fg = nord['nord0']

## Font color for the matched part of hints.
## Type: QssColor
c.colors.hints.match.fg = nord['nord10']

## Background color of the keyhint widget.
## Type: QssColor
c.colors.keyhint.bg = nord['nord1']

## Text color for the keyhint widget.
## Type: QssColor
c.colors.keyhint.fg = nord['nord5']

## Highlight color for keys to complete the current keychain.
## Type: QssColor
c.colors.keyhint.suffix.fg = nord['nord13']

## Background color of an error message.
## Type: QssColor
c.colors.messages.error.bg = nord['nord11']

## Border color of an error message.
## Type: QssColor
c.colors.messages.error.border = nord['nord11']

## Foreground color of an error message.
## Type: QssColor
c.colors.messages.error.fg = nord['nord5']

## Background color of an info message.
## Type: QssColor
c.colors.messages.info.bg = nord['nord8']

## Border color of an info message.
## Type: QssColor
c.colors.messages.info.border = nord['nord8']

## Foreground color an info message.
## Type: QssColor
c.colors.messages.info.fg = nord['nord5']

## Background color of a warning message.
## Type: QssColor
c.colors.messages.warning.bg = nord['nord12']

## Border color of a warning message.
## Type: QssColor
c.colors.messages.warning.border = nord['nord12']

## Foreground color a warning message.
## Type: QssColor
c.colors.messages.warning.fg = nord['nord5']

## Background color for prompts.
## Type: QssColor
c.colors.prompts.bg = nord['nord2']

# ## Border used around UI elements in prompts.
# ## Type: String
c.colors.prompts.border = '1px solid ' + nord['nord0']

## Foreground color for prompts.
## Type: QssColor
c.colors.prompts.fg = nord['nord5']

## Background color for the selected item in filename prompts.
## Type: QssColor
c.colors.prompts.selected.bg = nord['nord3']

## Background color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.bg = nord['nord15']

## Foreground color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.fg = nord['nord5']

## Background color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.bg = nord['nord15']

## Foreground color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.fg = nord['nord5']

## Background color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.bg = nord['nord2']

## Foreground color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.fg = nord['nord5']

## Background color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.bg = nord['nord2']

## Foreground color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.fg = nord['nord5']

## Background color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.bg = nord['nord14']

## Foreground color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.fg = nord['nord1']

## Background color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.bg = nord['nord0']

## Foreground color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.fg = nord['nord5']

## Background color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.bg = nord['nord10']

## Foreground color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.fg = nord['nord5']

## Background color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.bg = nord['nord3']

## Foreground color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.fg = nord['nord5']

## Background color of the progress bar.
## Type: QssColor
c.colors.statusbar.progress.bg = nord['nord5']

## Foreground color of the URL in the statusbar on error.
## Type: QssColor
c.colors.statusbar.url.error.fg = nord['nord11']

## Default foreground color of the URL in the statusbar.
## Type: QssColor
c.colors.statusbar.url.fg = nord['nord5']

## Foreground color of the URL in the statusbar for hovered links.
## Type: QssColor
c.colors.statusbar.url.hover.fg = nord['nord8']

## Foreground color of the URL in the statusbar on successful load
## (http).
## Type: QssColor
c.colors.statusbar.url.success.http.fg = nord['nord5']

## Foreground color of the URL in the statusbar on successful load
## (https).
## Type: QssColor
c.colors.statusbar.url.success.https.fg = nord['nord14']

## Foreground color of the URL in the statusbar when there's a warning.
## Type: QssColor
c.colors.statusbar.url.warn.fg = nord['nord12']

## Background color of the tab bar.
## Type: QtColor
c.colors.tabs.bar.bg = nord['nord3']

## Background color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.bg = nord['nord3']

## Foreground color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.fg = nord['nord5']

## Color for the tab indicator on errors.
## Type: QtColor
c.colors.tabs.indicator.error = nord['nord11']

## Color gradient start for the tab indicator.
## Type: QtColor
# c.colors.tabs.indicator.start = nord['violet']

## Color gradient end for the tab indicator.
## Type: QtColor
# c.colors.tabs.indicator.stop = nord['orange']

## Color gradient interpolation system for the tab indicator.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
c.colors.tabs.indicator.system = 'none'

## Background color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.bg = nord['nord3']

## Foreground color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.fg = nord['nord5']

# ## Background color of selected even tabs.
# ## Type: QtColor
c.colors.tabs.selected.even.bg = nord['nord0']

# ## Foreground color of selected even tabs.
# ## Type: QtColor
c.colors.tabs.selected.even.fg = nord['nord5']

# ## Background color of selected odd tabs.
# ## Type: QtColor
c.colors.tabs.selected.odd.bg = nord['nord0']

# ## Foreground color of selected odd tabs.
# ## Type: QtColor
c.colors.tabs.selected.odd.fg = nord['nord5']

## Background color for webpages if unset (or empty to use the theme's
## color)
## Type: QtColor
# c.colors.webpage.bg = 'white'
