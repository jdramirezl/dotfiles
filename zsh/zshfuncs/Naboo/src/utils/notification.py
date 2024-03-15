import os

class Toast:
    sounds = {
        "success": "Glass",
        "failure": "Hero",
        "running": "Funk",
    }

    @staticmethod
    def notify(title, subtitle, message, state):
        sound = Toast.sounds[state]
        sound = "-sound {}".format(sound) if sound else ""

        t = "-title {!r}".format(title)
        s = "-subtitle {!r}".format(subtitle)
        m = "-message {!r}".format(message)
        os.system("terminal-notifier {}".format(" ".join([m, t, s, sound])))

    @staticmethod
    def success(title, subtitle, message):
        Toast.notify(title, subtitle, message, "success")

    @staticmethod
    def error(title, subtitle, message):
        Toast.notify(title, subtitle, message, "failure")
        
    @staticmethod
    def warning(title, subtitle, message):
        Toast.notify(title, subtitle, message, "failure")

    @staticmethod
    def running(title, subtitle, message):
        Toast.notify(title, subtitle, message, "running")

    @staticmethod
    def info(title, subtitle, message):
        Toast.notify(title, subtitle, message, "running")