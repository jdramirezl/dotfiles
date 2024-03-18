from typing import List, Optional

from src.model import TaskModel, ArtifactModel
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

    def get_by_name(self, name: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.name == name]

    def get_by_version(self, version: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.version == version]

    def get_by_name_and_version(self, name: str, version: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [task for task in tasks if task.name == name and task.version == version]

    def get_by_username_and_name(self, username: str, name: str) -> List[TaskModel]:
        tasks = self.get_all()
        return [
            task for task in tasks if task.username == username and task.name == name
        ]
