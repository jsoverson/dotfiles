winClass = window.get_active_class()
if winClass == "hyper.Hyper" or winClass == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<super>+<left>")
else:
    keyboard.send_key("<home>")
