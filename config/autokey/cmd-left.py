winClass = window.get_active_class()
if winClass == "hyper.Hyper" or winClass == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<super>+<left>")
elif winClass == "org.gnome.meld.Meld":
    keyboard.send_keys("<ctrl>+l")
else:
    keyboard.send_keys("<home>")

