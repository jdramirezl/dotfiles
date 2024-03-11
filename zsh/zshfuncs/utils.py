import os
import requests

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


class FDA:
    def __init__(self) -> None:
        self.BASE_URL = "https://scheduler-fda.furycloud.io/"
        self.APPLICATION_NAME = ""
        self.get_current_app()

    def find_file(self, file_name: str) -> str:
        current_dir = os.getcwd()
        while True:
            file_path = os.path.join(current_dir, file_name)
            if os.path.isfile(file_path):
                return file_path

            # Move one directory up
            parent_dir = os.path.dirname(current_dir)

            # If parent directory is the same as current directory, it means we've reached the root
            if parent_dir == current_dir:
                return ""

            current_dir = parent_dir

    def get_current_app(self) -> None:
        file_path = self.find_file(".fury")
        if file_path:
            with open(file_path, "r") as file:
                app_name = file.read()
                app_name = app_name.split(":")[1]
                app_name = app_name.strip()
                self.APPLICATION_NAME = app_name
        else:
            raise Exception("No .fury file found")

    def get_task_images(self) -> list:
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/task_images/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        # Run an os command to get the token "fury get-token"
        token = os.popen("fury get-token").read().strip()
        # Get everything afeter the "Bearer " part
        token = token.split("Bearer ")[1]

        headers = {
            "x-tiger-token": f"Bearer {token}",
        }

        response = requests.request("GET", url, headers=headers, data=payload)

        response_dict = response.json()

        task_images = response_dict["results"]

        return task_images

    def get_task_image(self, task_image_id: str) -> dict:
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/task_images/{task_image_id}/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        # Run an os command to get the token "fury get-token"
        token = os.popen("fury get-token").read().strip()
        # Get everything afeter the "Bearer " part
        token = token.split("Bearer ")[1]

        headers = {
            "x-tiger-token": f"Bearer {token}",
        }

        response = requests.request("GET", url, headers=headers, data=payload)

        response_dict = response.json()

        return response_dict
