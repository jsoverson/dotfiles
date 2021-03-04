winClass = window.get_active_class()
if winClass == "hyper.Hyper" or winClass == "gnome-terminal-server.Gnome-terminal":
    keyboard.send_keys("<shift>+<ctrl>+c")
else:
    keyboard.send_keys("<ctrl>+c")

