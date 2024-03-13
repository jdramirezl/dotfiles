import os
import requests
import git

from utils import bcolors, SEPARATOR

DEBUG = False


def debug_print(message: str) -> None:
    if DEBUG:
        print(message)


class FDA:
    def __init__(self) -> None:
        self.BASE_URL = "https://scheduler-fda.furycloud.io/"
        self.ARTIFACTS_URL = (
            "http://prod-artifacts.artifacts-service.melifrontends.com/v2/"
        )
        self.APPLICATION_NAME = ""
        self.get_current_app()
        try:
            token = os.popen("fury get-token").read().strip()
        except Exception as e:
            debug_print(f"Error getting token: {e}")
            raise e
        # Get everything afeter the "Bearer " part
        self.token = token.split("Bearer ")[1]
        os.environ["TIGER_TOKEN"] = self.token

    def find_file(self, file_name: str) -> str:
        debug_print(f"Finding file: {file_name}")
        current_dir = os.getcwd()
        while True:
            file_path = os.path.join(current_dir, file_name)
            if os.path.isfile(file_path):
                debug_print(f"File found: {file_path}")
                return file_path

            # Move one directory up
            parent_dir = os.path.dirname(current_dir)

            # If parent directory is the same as current directory, it means we've reached the root
            if parent_dir == current_dir:
                print(f"File not found: {file_name}")
                return ""

            current_dir = parent_dir

    def _make_request(self, url: str, method: str, payload: dict) -> tuple:
        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        try:
            response = requests.request(method, url, headers=headers, data=payload)
        except requests.exceptions.RequestException as e:
            debug_print(f"Error making request: {e}")
            return {}, 500

        return response.json(), response.status_code

    def get_current_app(self) -> None:
        debug_print("Getting current app...")
        file_path = self.find_file(".fury")
        if file_path:
            with open(file_path, "r") as file:
                app_name = file.read()
                app_name = app_name.split(":")[1]
                app_name = app_name.strip()
                self.APPLICATION_NAME = app_name
        else:
            raise Exception("No .fury file found")

        print(f"Found current app: {self.APPLICATION_NAME}")

    def get_task_images(self) -> list:
        debug_print(f"Getting task images")
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/task_images/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        response_dict, status = self._make_request(url, "GET", payload)

        task_images = response_dict["results"]

        debug_print(f"Got task images: {len(task_images)}")
        return task_images

    def get_task_image(self, task_image_id: str) -> dict:
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/task_images/{task_image_id}/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        response_dict, status = self._make_request(url, "GET", payload)

        if status != 200:
            print(f"Error getting task image: {response_dict}")
            raise Exception(f"Error getting task image: {response_dict}")

        return response_dict

    def _get_new_version(self, version: str) -> str:
        version_list = version.split("-")
        last_number = version_list[-1]

        # Iterate from back to front, looking for only numbers
        new_last_number = ""
        last_number_list = list(last_number)
        for i in range(len(last_number_list) - 1, -1, -1):
            if last_number_list[i].isdigit():
                new_last_number = last_number_list[i] + new_last_number
            else:
                break

        new_last_number = int(new_last_number)
        new_last_number += 1

        last_number = last_number.replace(
            str(new_last_number - 1), str(new_last_number)
        )
        version_list[-1] = str(last_number)
        version = "-".join(version_list)

        return version

    def prepare_task_image(self, name: str, version: str, tags: list) -> tuple:
        print("Preparing task image")
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/task_images/"

        version = self._get_new_version(version)

        # Ask if new version is acceptable
        print(f"{SEPARATOR} New version: {bcolors.OKGREEN}{version}{bcolors.ENDC}")
        print(
            f"{SEPARATOR} Is this version acceptable? {bcolors.OKGREEN}(y/n){bcolors.ENDC}"
        )
        response = input()
        if response.lower() != "y":
            # Ask for new version
            print(
                f"{SEPARATOR} Please enter new version: {bcolors.OKGREEN}(e.g. 1.0.0-1){bcolors.ENDC}"
            )
            version = input()

        # Parse tags. They are in the format dict: {"name": "tag_name"}
        tags = [tag["name"] for tag in tags]

        # Get current git configs
        repo = git.Repo(search_parent_directories=True)
        commit_id = repo.head.object.hexsha
        commit_message = repo.head.object.message
        repository = repo.remotes.origin.url
        branch = repo.active_branch.name
        last_commit = repo.head.commit

        payload = {
            "name": name,
            "application": self.APPLICATION_NAME,
            "version": version,
            "commit_id": commit_id,
            "local_tasks_spec_file_path": "tasks.yml",
            "local_artifacts_spec_file_path": "artifacts.yml",
            "repository": repository,
            "description": "",
            "branch": branch,
            "tags": tags,
            "tags_propagation_enabled": True,
        }

        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        # Ask for confirmation
        print("\n")
        print(f"{SEPARATOR} This will prepare a task image with the following details:")
        for key, value in payload.items():
            print(f"\t{bcolors.OKGREEN}{key}{bcolors.ENDC}: {value}")
        print(
            f"\n{bcolors.FAIL}HINT --> commit_message: {commit_message}{bcolors.ENDC}"
        )
        print(
            f" Do you want to continue? {bcolors.OKGREEN}{SEPARATOR}(y/n){bcolors.ENDC}"
        )
        response = input()
        if response.lower() != "y":
            print("Task image preparation cancelled")
            raise Exception("Task image preparation cancelled")

        response_dict, status = self._make_request(url, "POST", payload)

        # Check response status
        if status != 201:
            print(f"Error preparing task image: {response_dict}")
            raise Exception(f"Error preparing task image: {response_dict}")

        print(f"Task image sent to prepare: {name} - {version}")

        return name, version

    def get_tasks(self) -> list:
        print(f"Getting tasks")
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/tasks/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        response_dict, status = self._make_request(url, "GET", payload)
        tasks = response_dict["results"]

        return tasks

    def get_task(self, task_id: str) -> dict:
        print(f"Getting task")
        url = f"{self.BASE_URL}v1/applications/{self.APPLICATION_NAME}/scheduler/tasks/{task_id}/"

        # example payload
        payload = {
            "application": self.APPLICATION_NAME,
        }

        headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

        response_dict, status = self._make_request(url, "GET", payload)

        return response_dict

    def run_task(self, task_image_id: str) -> dict:
        print(f"Running task")
        # Get the task-image based on the id
        task_image = self.get_task_image(task_image_id)

        # Get the task-image name, tags, inputs and outputs

        return response_dict

    def get_artifacts(self) -> list:
        # We dont have an api for this, lets call a cli command
        # first export the token as environ

        # Then call the command fda artifact list --limit 0 and parse the output
        command = "fda artifact list --limit 0"
        artifacts = os.popen(command).read().strip()
        artifacts = artifacts.split("\n")
        headers = artifacts[0]
        headers = list(filter(None, headers.split("  ")))
        # strip the headers
        headers = [header.strip() for header in headers]
        artifacts = artifacts[2:]
        # split by " " and ignore empty strings
        artifacts = [list(filter(None, artifact.split("  "))) for artifact in artifacts]
        # strip
        artifacts = [
            [artifact.strip() for artifact in artifact] for artifact in artifacts
        ]
        # assign the headers to the artifacts
        artifacts = [dict(zip(headers, artifact)) for artifact in artifacts]

        return artifacts
