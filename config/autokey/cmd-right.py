winClass = window.get_active_class()
if winClass == "hyper.Hyper" or winClass == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<super>+<right>")
elif winClass == "org.gnome.meld.Meld":
    keyboard.send_keys("<ctrl>+r")
else:
    keyboard.send_keys("<end>")

