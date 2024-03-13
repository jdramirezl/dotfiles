from re import A
import subprocess
import time
import yaml
import sys
import datetime
import git
import yaml

from utils import notify, bcolors, SEPARATOR
from fda import FDA
from task_image import TaskImage
from utils import bcolors, SEPARATOR, ti_toast


class Task:
    def __init__(self) -> None:
        self.ti = TaskImage()

        # prompt the user to select a task image
        print(f"{SEPARATOR} Select a task image to run:")
        self.task_image = self.ti.select()

        self.fda = FDA()

    def get(self) -> dict:
        # Get the task image id
        task_image_id = self.task_image["visible_id"]

        # Get the FDA instance
        fda = self.fda

        # Get all tasks
        tasks = fda.get_tasks()

        # Get the selected tasks
        selected_tasks = [
            task for task in tasks if task["task_image_id"] == task_image_id
        ]

        # Check if the tasks are empty
        if not selected_tasks:
            notify(
                ti_toast["title"],
                ti_toast["failure"],
                "No tasks related to this Task-Image",
                2,
            )
            return {}

        # Prompt the user to select a task
        print(f"{SEPARATOR} Select a task:")
        task_options = {i + 1: task for i, task in enumerate(selected_tasks)}
        for i, task in task_options.items():
            print(f"\t{i}. {bcolors.OKGREEN}{task['name']}{bcolors.ENDC}")
        task_index = int(input(f"{SEPARATOR} Enter the task number: "))
        selected_task = task_options[task_index]

        # Return the selected task
        return selected_task

    def select(self, task_image_id: str) -> dict:
        # Get the FDA instance
        fda = self.fda

        # Get all tasks
        tasks = fda.get_tasks()

        # Filter the tasks by "task_image"
        selected_tasks = [task for task in tasks if task["task_image"] == task_image_id]

        # Check if the tasks are empty
        if not selected_tasks:
            return {}

        # Prompt the user to select a task
        print(f"{SEPARATOR} Select a task:")
        task_options = {i + 1: task for i, task in enumerate(selected_tasks)}
        for i, task in task_options.items():
            username = task["username"]
            status = task["status"]
            created_at = task["created_at"]
            # format the created_at date
            created_at = datetime.datetime.strptime(
                created_at, "%Y-%m-%dT%H:%M:%S.%fZ"
            ).strftime("%Y-%m-%d %H:%M:%S")
            print(
                f"\t{i}. {bcolors.OKGREEN}{created_at}{bcolors.ENDC} - {status} - {username}"
            )

        task_index = int(input(f"{SEPARATOR} Enter the task number: "))
        selected_task = task_options[task_index]

        # Return the selected task
        return selected_task

    def run(self, config: dict):
        # Get the FDA instance
        fda = self.fda

        # Get the artifacts
        artifacts = fda.get_artifacts()

        # Look for the tasks.yaml file
        tasks_yaml = fda.find_file("tasks.yml")

        # Check if the tasks.yaml file is empty
        if not tasks_yaml:
            notify(ti_toast["title"], ti_toast["failure"], "tasks.yaml not found", 2)
            raise FileNotFoundError("tasks.yaml not found")

        # Load the tasks.yaml file
        with open(tasks_yaml, "r") as file:
            task_dict = yaml.safe_load(file)

        # Get the tasks from the tasks.yaml file
        tasks = task_dict["tasks"]

        # pop "def_version"
        tasks.pop("def_version")

        # Create a list of dicts of name, inputs/runtime, inputs/artifacts, outputs
        task_list = []
        for task in tasks:
            task_list.append(
                {
                    "name": task,
                    "runtime_inputs": tasks[task].get("inputs", {}).get("runtime", []),
                    "artifacts": tasks[task].get("inputs", {}).get("artifacts", []),
                    "outputs": tasks[task].get("outputs", []),
                }
            )

        # Check if the tasks are empty
        while True:
            print(f"{SEPARATOR} Do you want to use another tasks parameters?")
            print(f"\t1. Use the parameters of a task of another task-image")
            print(f"\t2. Use the parameters of a task of this task-image")
            print(f"\t3. No, I want to choose the parameters or get default ones")
            use_params = int(input(f"{SEPARATOR} Enter the number: "))

            # Get the task-image id
            task_image_id = self.task_image["visible_id"]

            if use_params == 1:
                # Get the task-images with the same name
                task_image = self.ti.select_with_name(self.task_image["name"])

                # Get the id of the task-image
                task_image_id = task_image["visible_id"]

                # Set the use_params to 2
                use_params = 2

            if use_params == 2:
                # Select the task
                task = self.select(task_image_id)

                # Check if the task is empty
                if not task:
                    print(f"{SEPARATOR} No tasks related to this Task-Image")
                    continue

                break

            if use_params == 3:
                print("No")
                break


task = Task()
print(task.select(task.task_image["visible_id"]))
