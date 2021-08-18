winClass = window.get_active_class()
if winClass == "Navigator.Firefox" or winClass == "Opera.Opera" or winClass == "vivaldi-stable.Vivaldi-stable":
    keyboard.send_keys("<ctrl>+<shift>+t")
else:
    keyboard.send_keys("<super>+<shift>+t")

