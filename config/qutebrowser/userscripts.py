# TODO: i don't want to lose all other aliases
c.aliases = {
    "json": "spawn --userscript json_format native",
    # for alias below -> config.bind('o', 'dmenu')
    # "dmenu": "spawn --userscript dmenu_qutebrowser" # doesn't work
    "sd": "spawn --userscript open_download",
}

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
