from abc import abstractmethod
from typing import List
import yaml

from src.repository.repository import Repository
from src.constants.task_image import BASE_URL, TASK_IMAGE_URL

from src.model import TaskImageModel
from src.settings import settings
from src.utils import Request, File


class TaskImageRepository(Repository):
    @abstractmethod
    def get(self, task_image_id: str) -> TaskImageModel:
        pass

    @abstractmethod
    def get_all(self) -> List[TaskImageModel]:
        pass

    @abstractmethod
    def post(self, task_image: TaskImageModel) -> None:
        pass


class TaskImageAPIRepository(TaskImageRepository):
    def __init__(self, config: dict = {}) -> None:
        # Get application
        self.application = settings.APPLICATION
        self.token = settings.TOKEN

        self.URL = f"{BASE_URL}{self.application}/{TASK_IMAGE_URL}"

        # Define GET payload and headers
        self.get_payload = {
            "application": self.application,
        }

        self.headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

    def get(self, task_image_id: str) -> TaskImageModel:
        url = f"{self.URL}{task_image_id}/"

        print(f"Getting task image with id: {task_image_id}")
        response, status = Request.get(url, self.get_payload, self.headers)
        task_image = TaskImageModel(response)
        return task_image

    def get_all(self) -> List[TaskImageModel]:
        url = self.URL

        print(f"Getting all task images")
        response, status = Request.get(url, self.get_payload, self.headers)
        task_images = [TaskImageModel(task_image) for task_image in response["results"]]
        return task_images

    def post(self, task_image: TaskImageModel) -> None:
        url = self.URL

        print(f"Putting task image with id: {task_image.visible_id}")
        payload = task_image.to_post_dict()
        Request.post(url, payload, self.headers)



