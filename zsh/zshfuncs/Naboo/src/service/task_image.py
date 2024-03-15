from typing import List, Optional

from src.model import TaskImageModel
from src.repository import TaskImageRepository


class TaskImageService:
    def __init__(self, task_image_repository: TaskImageRepository) -> None:
        self.repository = task_image_repository

    def create(self, task_image: TaskImageModel) -> None:
        self.repository.post(task_image)

    def get(self, task_image_id: str) -> TaskImageModel:
        return self.repository.get(task_image_id)

    def get_all(self) -> List[TaskImageModel]:
        return self.repository.get_all()

    def get_by_name(self, task_image_name: str) -> List[TaskImageModel]:
        task_images = self.get_all()
        return [task_image for task_image in task_images if task_image.name == task_image_name]

    def get_by_version(self, task_image_version: str) -> List[TaskImageModel]:
        task_images = self.get_all()
        return [
            task_image for task_image in task_images if task_image.version == task_image_version
        ]

    def get_by_name_and_version(
        self, task_image_name: str, task_image_version: str
    ) -> Optional[TaskImageModel]:
        task_images = self.get_all()
        for task_image in task_images:
            if (
                task_image.name == task_image_name
                and task_image.version == task_image_version
            ):
                return task_image
        return None

    def get_by_username(self, username: str) -> List[TaskImageModel]:
        task_images = self.get_all()
        return [
            task_image for task_image in task_images if task_image.username == username
        ]
