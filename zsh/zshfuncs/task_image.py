from re import A
import subprocess
import time
import yaml
import sys
import datetime
import git

from utils import notify, bcolors, SEPARATOR, ti_toast
from fda import FDA


class TaskImage:
    def __init__(self) -> None:
        self.fda = FDA()

    def get_by_name(self, name="") -> list:
        # Get the FDA instance
        fda = self.fda

        # Get the task images
        task_images = fda.get_task_images()

        # Get the selected task images
        selected_task_images = [
            task_image for task_image in task_images if task_image["name"] == name
        ]

        # Check if the task images are empty
        if not selected_task_images:
            notify(ti_toast["title"], ti_toast["failure"], "Task image not found", 2)
            return []

        return selected_task_images

    def get_by_name_and_version(self, name="", version="") -> dict:
        # Get the FDA instance
        fda = self.fda

        # Get the task images
        task_images = fda.get_task_images()

        # Get the selected task images
        selected_task_images = [
            task_image
            for task_image in task_images
            if task_image["name"] == name and task_image["version"] == version
        ]

        # Check if the task images are empty
        if not selected_task_images:
            notify(ti_toast["title"], ti_toast["failure"], "Task image not found", 2)
            return {}

        return selected_task_images[0]

    def select_with_name(self, name="") -> dict:
        # Get the task images
        selected_task_images = self.get_by_name(name)

        # prompt the user the select a version for the task image
        print(f"{SEPARATOR} Select a version for the task image:")
        version_options = {
            i + 1: task_image["version"]
            for i, task_image in enumerate(selected_task_images)
        }

        # Get the commit ids made by the local user
        repo = git.Repo(search_parent_directories=True)

        # Get email
        reader = repo.config_reader()
        email = reader.get_value("user", "email")

        for i, version in version_options.items():
            current_task_image = selected_task_images[i - 1]
            status = current_task_image["status"]
            username = current_task_image["username"]
            created_at = current_task_image["created_at"]
            commit = current_task_image["commit_id"]

            # Lookup the email of the user who made the commit
            git_user = ""
            try:
                git_user = subprocess.check_output(
                    ["git", "show", "-s", "--format=%ae", commit],
                    stderr=subprocess.STDOUT,
                ).decode("utf-8")
            except Exception as e:
                pass

            # Highlight the commit made by the local user
            if email in git_user:
                username = f"{bcolors.WARNING}{username}{bcolors.ENDC}"

            # process date with datetime
            created_at = datetime.datetime.strptime(
                created_at, "%Y-%m-%dT%H:%M:%S.%fZ"
            ).strftime("%Y-%m-%d %H:%M:%S")

            print(
                f"\t{i}. {bcolors.OKBLUE}{version}{bcolors.ENDC} - {status} - {username} - {created_at}"
            )
        version_index = int(input(f"{SEPARATOR} Enter the version number: "))
        selected_task_image = selected_task_images[version_index - 1]

        # Return the selected task image
        return selected_task_image

    def select(self) -> dict:
        # Get the FDA instance
        fda = self.fda

        # Find the tasks.yaml file
        tasks_yaml = fda.find_file("tasks.yml")
        if not tasks_yaml:
            notify(ti_toast["title"], ti_toast["failure"], "tasks.yaml not found", 2)
            raise FileNotFoundError("tasks.yaml not found")

        with open(tasks_yaml, "r") as file:
            task_dict = yaml.safe_load(file)

        # Get the tasks from the tasks.yaml file
        tasks = task_dict["tasks"]

        # prompt the user to select a task
        print(f"{SEPARATOR} Select a task:")
        task_options = {i + 1: task for i, task in enumerate(tasks)}
        for i, task in task_options.items():
            print(f"\t{i}. {bcolors.OKGREEN}{task}{bcolors.ENDC}")
        task_index = int(input(f"{SEPARATOR} Enter the task number: "))

        # Get the task images
        selected_task_images = self.get_by_name(task_options[task_index])

        # prompt the user the select a version for the task image
        print(f"{SEPARATOR} Select a version for the task image:")
        version_options = {
            i + 1: task_image["version"]
            for i, task_image in enumerate(selected_task_images)
        }

        # Get the commit ids made by the local user
        repo = git.Repo(search_parent_directories=True)

        # Get email
        reader = repo.config_reader()
        email = reader.get_value("user", "email")

        for i, version in version_options.items():
            current_task_image = selected_task_images[i - 1]
            status = current_task_image["status"]
            username = current_task_image["username"]
            created_at = current_task_image["created_at"]
            commit = current_task_image["commit_id"]

            # Lookup the email of the user who made the commit
            git_user = ""
            try:
                git_user = subprocess.check_output(
                    ["git", "show", "-s", "--format=%ae", commit],
                    stderr=subprocess.STDOUT,
                ).decode("utf-8")
            except Exception as e:
                pass

            # Highlight the commit made by the local user
            if email in git_user:
                username = f"{bcolors.WARNING}{username}{bcolors.ENDC}"

            # process date with datetime
            created_at = datetime.datetime.strptime(
                created_at, "%Y-%m-%dT%H:%M:%S.%fZ"
            ).strftime("%Y-%m-%d %H:%M:%S")

            print(
                f"\t{i}. {bcolors.OKBLUE}{version}{bcolors.ENDC} - {status} - {username} - {created_at}"
            )
        version_index = int(input(f"{SEPARATOR} Enter the version number: "))
        selected_task_image = selected_task_images[version_index - 1]

        # Return the selected task image
        return selected_task_image

    def check_deployment_status(self, config: dict) -> None:
        # Get the FDA instance
        fda = self.fda

        # Get configs
        name = config.get("name", "")
        version = config.get("version", "")

        # Check if the version is empty
        if not any(config.values()):
            selected_task_image = self.select()
        else:
            selected_task_image = self.get_by_name_and_version(name, version)

        if not selected_task_image:
            return

        # Get the task image id
        task_image_id = selected_task_image["visible_id"]

        # Show a toast message
        toast_message = f"Task image: {name} - {version}"
        notify(ti_toast["title"], ti_toast["starting"], toast_message, 1)

        # Start the model check
        print(f"{SEPARATOR} Checking deployment status...")
        start_time = time.time()

        LOADING_CHARS = ["|", "/", "-", "\\"]
        loading_index = 0
        print("Status: PENDING", end="\r")

        # Get current time
        get_time = time.time()
        print_time = time.time()

        # first 
        first = True

        # Make the first query
        output = fda.get_task_image(task_image_id)
        current_status = output["status"]

        while True:
            # set a temporal time 
            current_time = time.time()

            # Every 7 seconds, get the task image status
            if current_time - get_time > 7:
                output = fda.get_task_image(task_image_id)

                if output["errors"] or "ERROR" in output["status"]:
                    notify(ti_toast["title"], ti_toast["failure"], "", 2)
                    print(
                        f"Error: Unexpected status: '{output['status']}'\nErrors:\n{output['errors']}"
                    )
                    print(f"Logs:\n{output['logs_stderr']}")
                    return

                current_status = output["status"]
                if "DONE" in current_status:
                    break

            # Print every second
            if current_time - print_time > 0.5:
                print_time = current_time
                # erase the entire last line
                if first:
                    first = False
                else:
                    print("\033[A                             \033[A")

                # print the current status
                print(
                    f"Status: {current_status} {LOADING_CHARS[loading_index]}",
                )
                loading_index = (loading_index + 1) % len(LOADING_CHARS)

        # End the model check
        end_time = time.time()
        diff = end_time - start_time

        # Show in the minutes and seconds format
        diff = time.strftime("%M:%S", time.gmtime(diff))
        time_message = f"Deployment finished in {diff} seconds!"

        notify(
            ti_toast["title"],
            ti_toast["success"],
            time_message,
            1,
        )
        print(f"{SEPARATOR} Deployment finished in {diff} seconds!")

    def prepare(self, config: dict) -> tuple:
        fda = self.fda

        # Parse config
        if not any(config.values()):
            config = self.select()

        if not config:
            print(f"{SEPARATOR} Task image not found!")
            raise FileNotFoundError("Task image not found")

        name = config.get("name", "")
        version = config.get("version", "")
        tags = config.get("tags", [])

        name, version = fda.prepare_task_image(name, version, tags)
        return name, version
