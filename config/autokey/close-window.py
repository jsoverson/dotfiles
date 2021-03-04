winClass = window.get_active_class()
if winClass == "code.Code":
    keyboard.send_keys("<ctrl>+<left>")
else:
    keyboard.send_key("<home>")

