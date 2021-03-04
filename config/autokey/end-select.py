winClass = window.get_active_class()
if winClass == "hyper.Hyper":
    keyboard.send_keys("<shift>+<super>+<right>")
else:
    keyboard.send_keys("<shift>+<end>")

