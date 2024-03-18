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
from src.constants.general import PRINT, COLORS, FURY_URLS
from src.constants.task import TASK_MESSAGES
from src.constants.task_image import TASK_IMAGE_MESSAGES

from src.utils import File, Toast, utils

from src.settings import settings
from src.gui.gui import GUI


class TaskImageGUI(GUI):
    def __init__(self, master, task):
        super().__init__()

    def check_image_prepare(self) -> None:
        self.check_status(self.task_image_service, TASK_IMAGE_MESSAGES)

    def prepare_task_image(self) -> None:
        service = self.task_image_service
        task = self.choose(service)

        # Get the new version
        new_version = utils.increase_version(task.version)

        # Ask the user to confirm the new version or change it
        print(f"{PRINT.SEPARATOR} The new version is {new_version}")
        confirm = input("Do you want to use it ? (y/n): ")
        if confirm.lower() != "y":
            new_version = input("Enter the new version: ")

        # set the new version
        task.version = new_version

        # Show the user the task to be prepared
        print(f"{PRINT.SEPARATOR} The new task:")
        task_image_body = task.to_post_dict()
        utils.tree_print(task_image_body)

        # Get every keys
        path_list = []
        values_to_change = utils.tree_to_list(task_image_body, [], path_list)
        print(f"{PRINT.SEPARATOR} The keys to change:")
        for value in values_to_change:
            print(value)

        # Get the commit message
        commit = task.commit_id
        commit_message = self.github.get_commit_message(commit)
        print(
            f"{PRINT.SEPARATOR} {COLORS.RED}HINT ->{COLORS.ENDC} Latest commit: {commit_message}"
        )

        # Ask the user to confirm the new task
        confirm = input("Do you want to prepare this task ? (y/n): ")
        if confirm.lower() != "y":
            return

        # Toast the user
        Toast.info(
            TASK_IMAGE_MESSAGES.STARTING,
            f"Preparing the task {task.name}:{task.version}",
        )

        self.fda.prepare_image(task)
        self.check_status(self.task_image_service, TASK_IMAGE_MESSAGES, task)
