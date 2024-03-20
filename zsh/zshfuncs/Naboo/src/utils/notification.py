import os


class Toast:
    sounds = {
        "success": "Glass",
        "failure": "Hero",
        "running": "Funk",
    }

    @staticmethod
    def notify(title, subtitle, message, state, url):
        parts = []
        if state:
            sound = Toast.sounds[state]
            sound = "-sound {}".format(sound) if sound else ""
            parts.append(sound)

        if title:
            parts.append("-title {!r}".format(title))

        if subtitle:
            parts.append("-subtitle {!r}".format(subtitle))

        if message:
            parts.append("-message {!r}".format(message))

        if url:
            parts.append("-open {!r}".format(url))

        os.system(
            # "terminal-notifier {} >/dev/null 2>&1".format(" ".join([m, t, s, u, sound]))
            "terminal-notifier {}".format(" ".join(parts))
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
