winClass = window.get_active_class()
if winClass == "hyper.Hyper":
    keyboard.send_keys("<shift>+<super>+<left>")
else:
    keyboard.send_keys("<shift>+<home>")

