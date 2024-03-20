import os

from abc import abstractmethod
from typing import List

from src.constants.task import BASE_URL, TASK_URL
from src.repository.repository import Repository

from src.settings import settings
from src.model import (
    TaskModel,
)
from src.utils import Request, File


class TaskRepository(Repository):
    @abstractmethod
    def get(self, task_id: str) -> TaskModel:
        pass

    @abstractmethod
    def get_all(self) -> List[TaskModel]:
        pass

    @abstractmethod
    def post(self, task: TaskModel) -> None:
        pass


class TaskAPIRepository(TaskRepository):
    def __init__(self) -> None:
        self.application = settings.APPLICATION
        self.token = settings.TOKEN

        self.URL = f"{BASE_URL}{self.application}/{TASK_URL}"

        # Define GET payload and headers
        self.get_payload = {
            "application": self.application,
        }

        self.headers = {
            "x-tiger-token": f"Bearer {self.token}",
        }

    def get(self, task_id: str) -> TaskModel:
        url = f"{self.URL}{task_id}"
        response, status = Request.get(url, self.get_payload, self.headers)
        return TaskModel(response)

    def get_all(self) -> List[TaskModel]:
        url = f"{self.URL}"
        response, status = Request.get(url, self.get_payload, self.headers)
        return [TaskModel(task) for task in response["results"]]

    def post(self, task: TaskModel) -> None:
        url = f"{self.URL}"
        payload = task.to_post_dict()
        response, status = Request.post(url, payload, self.headers)


class TaskCLIRepository(TaskRepository):
    def get(self, task_id: str) -> TaskModel:
        raise Exception("Not implemented")

    def get_all(self) -> List[TaskModel]:
        raise Exception("Not implemented")

    def post(self, task: TaskModel) -> None:
        """
        The CLI command to run a task is:
            fda run --input-param name:value (for each input param) --input-artifact-id name:id (for each input artifact) --output-version name:version (for each output version) --flavor <flavor> --tag tag (for each tag) <task_image_id>
        """
        # get the task image id
        task_image_id = task.task_image_id

        # get the inputs
        input_params = task.runtime_inputs
        input_artifacts = task.artifact_inputs

        # get the outputs
        outputs = task.outputs_versions

        # get the flavor
        flavor = task.flavor

        # get the tags
        tags = task.tags

        # get the criticality level
        criticality_level = task.criticality_level

        # build the command
        command = "fda run"
        for input_param in input_params:
            command += f" --input-param {input_param.name}:{input_param.value}"
        for input_artifact in input_artifacts:
            command += f" --input-artifact-id {input_artifact.name}:{input_artifact.id}"
        for output in outputs:
            command += f" --output-version {output.name}:{output.version}"
        command += f" --flavor {flavor}"
        command += f" --criticality-level {criticality_level}"
        for tag in tags:
            tag = tag["name"]
            command += f" --tag {tag}"
        command += f" {task_image_id}"

        # run the command
        print(f"Running the command: {command}")
        os.system(command)


class TaskLocalRepository(TaskRepository):
    def __init__(self, config: dict = {}) -> None:
        self.task_file = config.get("task_file", "tasks.yml")

    def get(self, task_name: str) -> TaskModel:
        tasks = self.get_all()
        for task in tasks:
            if task.name == task_name:
                return task
        print(f"Task image {task_name} not found")
        raise Exception(f"Task image {task_name} not found")

    def get_all(self) -> List[TaskModel]:
        # find the file in the current directory or in the parent directories
        tasks = File.read_yaml(self.task_file)

        if not tasks:
            print("No task images found")
            raise Exception("No task images found")

        # filter
        tasks = tasks["tasks"]
        del tasks["def_version"]

        serialized_tasks = []
        for name, body in tasks.items():
            inputs = body.get("inputs", {})
            artifact_inputs = inputs.get("artifacts", [])
            artifact_inputs = [
                {
                    "alias": artifact_input["name"],
                    "id": "",
                }
                for artifact_input in artifact_inputs
            ]

            runtime_inputs = inputs.get("runtime", [])
            runtime_inputs = {
                runtime_input["name"]: runtime_input.get("default", "")
                for runtime_input in runtime_inputs
            }

            outputs = body.get("outputs", [])
            outputs = {output: "" for output in outputs}
            task = TaskModel(
                {
                    "task_image_name": name,
                    "task_type": body["type"],
                    "params": {
                        "entrypoint": body["context"]["entrypoint"],
                        "inputs": {
                            "artifacts": artifact_inputs,
                            "params": runtime_inputs,
                        },
                        "outputs_versions": outputs,
                        "flavor": body["context"]["flavor"],
                    },
                }
            )

            serialized_tasks.append(task)

        return serialized_tasks

    def post(self, task: TaskModel) -> None:
        pass
