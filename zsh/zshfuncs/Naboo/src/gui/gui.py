# this class is responsible for the GUI of the application
# it will present the user through the CLI with ways to choose an specific task or task image
import datetime
import os

from typing import List, Optional, Union
from math import ceil

from src.fda import FDA
from src.utils import GitHub
from src.repository import (
    ArtifactCLIRepository,
    ArtifactLocalRepository,
    TaskImageAPIRepository,
    TaskLocalRepository,
    TaskAPIRepository,
)
from src.model import (
    ArtifactModel,
    TaskImageModel,
    TaskModel,
)

from src.service import TaskService
from src.service import ArtifactService
from src.service import TaskImageService

from src.constants.fda import FDA_FILE
from src.constants.general import PRINT, COLORS, FURY_URLS
from src.constants.task import TASK_MESSAGES
from src.constants.task_image import TASK_IMAGE_MESSAGES

from src.utils import File, Toast, utils

from src.settings import settings


class GUI:
    def __init__(self) -> None:
        self.fda = FDA()
        self.github = GitHub()

        # Start the services
        self.task_repository = TaskAPIRepository()
        self.task_service = TaskService(self.task_repository)

        self.task_image_repository = TaskImageAPIRepository()
        self.task_image_service = TaskImageService(self.task_image_repository)

    def _select(self, options: list) -> int:
        # Do the same as above but implement a pagination
        print(
            f"{PRINT.SEPARATOR} Choose a number or use n/p to navigate through the options:"
        )
        page = 0
        while True:
            output = ""
            lines_to_print = []
            # print(f"Page {page + 1}/{ceil(len(options) / 5)}")
            lines_to_print.append(f"Page {page + 1}/{ceil(len(options) / 5)}")
            n_of_options = min(5, len(options) - page * 5)
            for i, option in enumerate(options[page * 5 : page * 5 + n_of_options]):
                string = ""
                for element in option:
                    string += element + " " * 5
                index = i + 1
                string = f"{utils.limit_str(str(index), 5)}" + string
                lines_to_print.append(string)
            # If there are less than 5 options, print empty lines
            for _ in range(5 - n_of_options - 1):
                lines_to_print.append("")

            for line in lines_to_print:
                output += line + "\n"
            print(output)
            choice = input("Enter the number of the option: ")

            # if choice is empty, or is not a number, or is not in the range, print an error
            if choice == "n":
                page = min(page + 1, ceil(len(options) / 5) - 1)
            elif choice == "p":
                page = max(page - 1, 0)
            elif not choice or not choice.isdigit() or int(choice) - 1 > n_of_options:
                pass
            else:
                return int(choice) - 1

            # clear the printed options
            for _ in range(len(lines_to_print) + 2):
                print("\033[A                                      \033[A")

        return int(choice) - 1

    def _select_multiple(self, options: list, separator: str = " " * 5) -> List[int]:
        selected = []
        possible = [{i: option} for i, option in enumerate(options)]
        while True:
            output = ""
            for i, option in enumerate(options):
                string = ""
                # for j, element in enumerate(option):
                #     if j != len(option) - 1:
                #         string += element + separator
                #     else:
                #         string += element
                # if element is iterable, join it with the separator
                if isinstance(option, list):
                    string = separator.join(option)
                else:
                    string = option
                index = i + 1
                string = f"{utils.limit_str(str(index), 5)}" + string
                if i in selected:
                    output += f"{COLORS.PURPLE}{string}{COLORS.ENDC}\n"
                else:
                    output += string + "\n"
            print(output)
            choice = input("Enter the number of the option: ")

            if not choice:
                break
            if int(choice) - 1 in selected:
                selected.remove(int(choice) - 1)
            else:
                selected.append(int(choice) - 1)

            # clear the printed options
            for _ in range(len(options) + 2):
                print("\033[A                                      \033[A")

        return selected

    def choose_local_task(self) -> TaskModel:
        # Get the local task images
        local_images = self.fda.get_local_tasks()

        # Let the user choose the task image
        print(f"{PRINT.SEPARATOR} Choose a task image:")
        options = [
            [f"{COLORS.GREEN}{utils.limit_str(image.name)}{COLORS.ENDC}"]
            for image in local_images
        ]
        index = self._select(options)
        local_image = local_images[index]
        return local_image

    def choose(
        self, service: Union[TaskService, TaskImageService]
    ) -> Union[TaskModel, TaskImageModel]:
        # Get the local task images
        local_task = self.choose_local_task()
        local_task_name = local_task.name
        task = self.choose_with_name(local_task_name, service)
        return task

    def choose_with_name(
        self,
        name: str,
        service: Union[TaskService, TaskImageService],
    ) -> Union[TaskModel, TaskImageModel]:
        tasks = service.get_by_name(name)

        # Sort by creation date
        tasks = sorted(tasks, key=lambda x: x.created_at, reverse=True)

        # Let the user choose the task version
        options = []
        email = self.github.get_user_email()
        for task in tasks:
            # Data!
            commit = self.github.get_user_email_from_commit(task.commit_id)
            username = task.username
            status = task.status
            created_at = task.created_at

            # Limit each string
            option = [
                f"{COLORS.GREEN}{utils.limit_str(task.version, PRINT.PRINT_LEN)}{COLORS.ENDC}",
                utils.limit_str(status, PRINT.PRINT_LEN_LOW),
                utils.limit_str(username, PRINT.PRINT_LEN),
                created_at,
            ]

            if email in commit:
                option[2] = f"{COLORS.PURPLE}{option[2]}{COLORS.ENDC}"

            if "ERROR" in status:
                option[
                    1
                ] = f"{COLORS.RED}{utils.limit_str('ERROR', PRINT.PRINT_LEN_LOW)}{COLORS.ENDC}"

            options.append(option)

        print(f"{PRINT.SEPARATOR} Choose a version:")
        index = self._select(options)
        selected_task = tasks[index]
        selected_task = service.get(selected_task.visible_id)
        return selected_task

    def check_status(
        self,
        service: Union[TaskService, TaskImageService],
        MESSAGES,
        model: Optional[Union[TaskModel, TaskImageModel]] = None,
    ) -> None:
        if not model:
            task = self.choose(service)
        else:
            task = model

        # Send a toast
        Toast.info(
            MESSAGES.STARTING,
            f"Checking the status of the task {task.name}:{task.version}",
        )

        # Start a timer
        start = datetime.datetime.now()

        # Check its status
        status = self.fda.check_status(task.visible_id, service)

        # End the timer
        end = datetime.datetime.now()

        # Get the time diff
        diff = end - start
        diff = str(diff).split(".")[0]

        # Send a toast depending on the status
        message = f"The task {task.name}:{task.version}"

        url = (
            FURY_URLS.FURY_URL
            + f"{self.fda.application_name}/{MESSAGES.URL}{task.visible_id}"
        )
        if not status:
            Toast.error(
                MESSAGES.FAILURE,
                message + f" failed",
                url,
            )
        else:
            Toast.success(
                MESSAGES.SUCCESS,
                message + f" was checked in {diff}",
                url,
            )
