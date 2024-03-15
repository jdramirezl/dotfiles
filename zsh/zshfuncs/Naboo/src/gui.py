# this class is responsible for the GUI of the application
# it will present the user through the CLI with ways to choose an specific task or task image
import datetime
import os

from typing import List, Optional, Union

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
from src.constants.general import PRINT, COLORS

from src.utils import File, limit_str, Toast

from src.settings import settings



class GUI:
    def __init__(self) -> None:
        self.fda = FDA()
        self.github = GitHub()
        
    def _select(self, options: list) -> int:
        for i, option in enumerate(options):
            string = ""
            for element in option:
                string += element + " " * 5
            index = i + 1
            string = f"{limit_str(str(index), 5)}" + string 
            print(string)
        choice = input("Enter the number of the option: ")
        return int(choice)-1
    
    def choose_local_task(self) -> str:
        # Get the local task images
        local_images = self.fda.get_local_tasks()

        # Let the user choose the task image
        print(f"{PRINT.SEPARATOR} Choose a task image:")
        options = [
            [f"{COLORS.GREEN}{limit_str(image.name)}{COLORS.ENDC}"]
            for image in local_images
        ]
        index = self._select(options)
        local_image = local_images[index]
        local_image_name = local_image.name
        return local_image_name
    
    def choose_task(self) -> TaskModel:
        # Choose a local task
        local_task = self.choose_local_task()
        task = self.choose_task_with_name(local_task)
        return task
    
    def choose_task_image(self) -> TaskImageModel:
        # Choose a local task image
        local_image = self.choose_local_task()
        task_image = self.choose_task_image_with_name(local_image)
        return task_image

    def choose_task_with_name(self, name: str) -> TaskModel:
        # Get the task service
        repository = TaskAPIRepository()
        service = TaskService(repository)
        tasks = service.get_by_image_name(name)

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

            # Limit each string
            option = [
                f"{COLORS.GREEN}{limit_str(task.task_image_version, PRINT.PRINT_LEN)}{COLORS.ENDC}",
                limit_str(task.status, PRINT.PRINT_LEN_LOW),
                limit_str(username, PRINT.PRINT_LEN),
                task.created_at
            ]
            
            if email in commit:
                option[2] = f"{COLORS.PURPLE}{option[2]}{COLORS.ENDC}"

            if "ERROR" in status:
                option[1] = f"{COLORS.RED}{limit_str('ERROR', PRINT.PRINT_LEN_LOW)}{COLORS.ENDC}"
            
            options.append(option)

        print(f"{PRINT.SEPARATOR} Choose a version for the task:")
        index = self._select(options)
        task = tasks[index]
        return task

        
    def choose_task_image_with_name(self, name: str) -> TaskImageModel:
        repository = TaskImageAPIRepository()
        service = TaskImageService(repository)
        images = service.get_by_name(name)

        # Sort by creation date
        images = sorted(images, key=lambda x: x.created_at, reverse=True)

        # Let the user choose the task image version
        options = []
        email = self.github.get_user_email()
        for image in images:
            # Data!
            commit = self.github.get_user_email_from_commit(image.commit_id)
            username = image.username
            status = image.status

            # Limit each string
            option = [
                f"{COLORS.GREEN}{limit_str(image.version, PRINT.PRINT_LEN)}{COLORS.ENDC}",
                limit_str(image.status, PRINT.PRINT_LEN_LOW),
                limit_str(username, PRINT.PRINT_LEN),
                image.created_at
            ]
            
            if email in commit:
                option[2] = f"{COLORS.PURPLE}{option[2]}{COLORS.ENDC}"

            if "ERROR" in status:
                option[1] = f"{COLORS.RED}ERROR{COLORS.ENDC}"
            
            options.append(option)

        print("Choose a version:")
        index = self._select(options)
        selected_image = images[index]
        return selected_image
    
    def check_image_prepare(self, config: dict = {}) -> bool:
        # Prepare
        repository = TaskImageAPIRepository()
        service = TaskImageService(repository)

        # Look if there is a name and version in the config
        name = config.get("name", "")
        version = config.get("version", "")

        if not name or not version:
            task_image = self.choose_task_image()
        else:
            
            task_image = service.get_by_name_and_version(name, version)

        

        # Send a toast
        Toast.info(f"Checking the status of the task image {task_image.name}:{task_image.version}")

        # Start a timer
        start = datetime.datetime.now()

        # Check its status
        status = self.fda.check_status(task_image.visible_id, service)

        # End the timer
        end = datetime.datetime.now()

        # Get the time diff
        diff = end - start

        # Send a toast depending on the status
        if not status:
            title = f"Task-Image update: {task_image.name}:{task_image.version}"
            subtitle = f"The task image finished with an error"
            message = f"Time running {diff}"
            Toast.error(title, subtitle, message)
        else:
            title = f"Task-Image update: {task_image.name}:{task_image.version}"
            subtitle = f"The task image finished successfully"
            message = f"Time running {diff}"
            Toast.success(title, subtitle, message)





