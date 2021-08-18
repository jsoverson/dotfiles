winClass = window.get_active_class()
if winClass == "Navigator.Firefox" or winClass == "Opera.Opera" or winClass == "vivaldi-stable.Vivaldi-stable":
    keyboard.send_keys("<ctrl>+r")
else:
    keyboard.send_keys("<super>+f")
