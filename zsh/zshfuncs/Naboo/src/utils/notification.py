import os


class Toast:
    sounds = {
        "success": "Glass",
        "failure": "Hero",
        "running": "Funk",
    }

    @staticmethod
    def notify(title, subtitle, message, state, url):
        sound = Toast.sounds[state]
        sound = "-sound {}".format(sound) if sound else ""

        t = "-title {!r}".format(title)
        s = "-subtitle {!r}".format(subtitle)
        m = "-message {!r}".format(message)
        u = "-open {!r}".format(url)
        # remove os.system output
        os.system(
            "terminal-notifier {} >/dev/null 2>&1".format(" ".join([m, t, s, u, sound]))
        )

    @staticmethod
    def success(subtitle: str, message: str = "", url: str = ""):
        title = "Naboo - Execution Success"
        Toast.notify(title, subtitle, message, "success", url)

    @staticmethod
    def error(subtitle: str, message: str = "", url: str = ""):
        title = "Naboo - Execution Error"
        Toast.notify(title, subtitle, message, "failure", url)

    @staticmethod
    def warning(subtitle: str, message: str = "", url: str = ""):
        title = "Naboo - Execution Warning"
        Toast.notify(title, subtitle, message, "failure", url)

    @staticmethod
    def running(subtitle: str, message: str = "", url: str = ""):
        title = "Naboo - Execution Running"
        Toast.notify(title, subtitle, message, "running", url)

    @staticmethod
    def info(subtitle: str, message: str = "", url: str = ""):
        title = "Naboo - Execution Info"
        Toast.notify(title, subtitle, message, "running", url)

