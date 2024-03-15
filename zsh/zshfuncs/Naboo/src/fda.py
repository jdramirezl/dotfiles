import datetime
import os

from typing import Union, List

from src.utils import GitHub
from src.repository import (
    TaskImageAPIRepository,
    TaskAPIRepository,
    TaskLocalRepository,
    ArtifactLocalRepository,
)
from src.model import (
    TaskImageModel,
    TaskModel,
    ArtifactModel,
)

from src.service import (
    TaskService,
    TaskImageService,
    ArtifactService,
)

from src.constants.fda import FDA_FILE
from src.constants.artifact import ARTIFACT_LOCAL_FILE
from src.constants.task_image import TASK_IMAGE_LOCAL_FILE
from src.constants.general import PRINT

from src.utils import File

from src.settings import settings


class FDA:
    def __init__(self, config: dict = {}) -> None:
        # Get the root path of the current repository
        self.github = GitHub()
        self.root_path = self.github.get_repo_root()

        # Get the application name
        fury_filename = config.get("fury_file_path", FDA_FILE)
        fury_file_path = f"{self.root_path}/{fury_filename}"
        self.application_name = self.get_fda(fury_file_path)

        # Get the token
        self.token = self.get_token()

        # Set the settings
        os.environ["TIGER_TOKEN"] = self.token
        settings.TOKEN = self.token
        settings.APPLICATION = self.application_name

    def get_token(self) -> str:
        try:
            token = os.popen("fury get-token").read().strip()
        except Exception as e:
            print(f"Unable to get the token: {e}")
            raise e
        # Get everything afeter the "Bearer " part
        return token.split("Bearer ")[1]

    def get_fda(self, fury_file_path: str) -> str:
        content = File.read_file(fury_file_path)
        app_name = content.split(":")[1].strip()
        return app_name

    def check_status(
        self, id: str, service: Union[TaskImageService, TaskService]
    ) -> bool:
        check_curr_time = datetime.datetime.now()
        print_curr_time = datetime.datetime.now()

        loading_icons = PRINT.LOADING_ICONS
        loading_index = 0

        while True:
            if (datetime.datetime.now() - check_curr_time).seconds > 7:
                check_curr_time = datetime.datetime.now()
                image = service.get(id)
                if "DONE" in image.status:
                    break

                errors = image.errors
                logerrors = image.logs_stderr
                if errors or "ERROR" in image.status:
                    print(
                        f"Error: Unexpected status: '{image.status}'\nErrors:\n{errors}\nLogs:\n{logerrors}"
                    )
                    return False

            if (datetime.datetime.now() - print_curr_time).seconds > 0.1:
                print_curr_time = datetime.datetime.now()
                print(f"STATUS: RUNNING {loading_icons[loading_index]}", end="\r")
                loading_index = (loading_index + 1) % len(loading_icons)

        print(f"STATUS: DONE", " " * 10)
        return True

    def prepare_image(self, task_image: TaskImageModel) -> None:
        api_repository = TaskImageAPIRepository()
        task_image_service = TaskImageService(api_repository)
        task_image_service.create(task_image)

    def run_task(self, task: TaskModel) -> None:
        api_repository = TaskAPIRepository()
        task_service = TaskService(api_repository)
        task_service.create(task)

    def get_local_tasks(self) -> List[TaskImageModel]:
        local_repository = TaskLocalRepository({
            "task_image_file": self.root_path + "/" + TASK_IMAGE_LOCAL_FILE
        })
        
        service = TaskImageService(local_repository)
        return service.get_all()
    
    def get_local_artifacts(self) -> List[ArtifactModel]:
        local_repository = ArtifactLocalRepository({
            "artifact_file": self.root_path + "/" + ARTIFACT_LOCAL_FILE
        })
        
        service = ArtifactService(local_repository)
        return service.get_all()
