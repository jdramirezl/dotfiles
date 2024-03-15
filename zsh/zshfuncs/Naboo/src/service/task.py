from typing import List, Optional

from src.model import TaskModel
from src.repository import TaskRepository


class TaskService:
    def __init__(self, task_repository: TaskRepository) -> None:
        self.repository = task_repository

    def get(self, task_id: str) -> TaskModel:
        return self.repository.get(task_id)

    def get_all(self) -> List[TaskModel]:
        return self.repository.get_all()

    def create(self, task: TaskModel) -> None:
        self.repository.post(task)

    def get_by_username(self, username: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.username == username]

    def get_by_image_name(self, task_image_name: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.task_image_name == task_image_name]

    def get_by_image_version(self, task_image_version: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.task_image_version == task_image_version]

    def get_by_image_name_and_version(
        self, task_image_name: str, task_image_version: str
    ) -> List[TaskModel]:
        tasks = self.get_all()
        return [
            task
            for task in tasks
            if task.task_image_name == task_image_name
            and task.task_image_version == task_image_version
        ]

    def get_by_username_and_image_name(
        self, username: str, task_image_name: str
    ) -> List[TaskModel]:
        tasks = self.get_all()
        return [
            task
            for task in tasks
            if task.username == username and task.task_image_name == task_image_name
        ]
