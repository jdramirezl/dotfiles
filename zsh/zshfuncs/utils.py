import os


SEPARATOR = ">>>>>>>>"


class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"

ti_toast = {
    "title": "FDA Task Image",
    "success": "✅ Task preparation done!",
    "failure": "🚫 Task preparation Failed!",
    "starting": "🛠️ Starting task...",
}

"""
States:
    1: success
    2: failure
    3: warning
    4: info
"""

states_sound = {1: "Glass", 2: "Hero", 3: "Funk", 4: "Glass"}


def notify(title, subtitle, message, state):
    sound = states_sound[state]
    sound = "-sound {}".format(sound) if sound else ""

    t = "-title {!r}".format(title)
    s = "-subtitle {!r}".format(subtitle)
    m = "-message {!r}".format(message)
    os.system("terminal-notifier {}".format(" ".join([m, t, s, sound])))
