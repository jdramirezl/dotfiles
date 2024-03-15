from src.utils import format_date
from src.model.artifact import ArtifactModel
from src.model.task_image import TaskImageModel
from src.constants.general import COLORS


class TaskModel:
    def __init__(self, task_dict: dict) -> None:
        # Task
        self.id = task_dict.get("id", "")
        self.visible_id = task_dict.get("visible_id", "")
        self.name = task_dict.get("name", "")
        self.task_type = task_dict.get("type", "")
        self.version = task_dict.get("version", "")
        self.username = task_dict.get("username", "")
        self.status = task_dict.get("status", "")

        # Params
        self.params = task_dict.get("params", {})
        self.tags = task_dict.get("tags", [])

        # Data
        self.criticality_settings = self.params.get("criticality_settings", {})

        # Inputs
        inputs = self.params.get("inputs", {})
        runtime_inputs = inputs.get("params", {})
        runtime_inputs = [
            {
                "artifact_name": key,
                "value": value,
            }
            for key, value in runtime_inputs.items()
        ]
        self.runtime_inputs = [ArtifactModel(input) for input in runtime_inputs]

        artifact_inputs = inputs.get("artifacts", [])
        artifact_inputs = [
            {
                "artifact_name": input["alias"],
                "artifact_id": input["id"],
            }
            for input in artifact_inputs
        ]
        self.artifact_inputs = [ArtifactModel(input) for input in artifact_inputs]

        # Outputs
        outputs = self.params.get("outputs_versions", {})
        outputs = [
            {
                "artifact_name": name,
                "version": version,
            }
            for name, version in outputs.items()
        ]
        self.outputs_versions = [ArtifactModel(output) for output in outputs]

        # Metadata
        self.commit_id = task_dict.get("commit_id", "")
        self.flavor = self.params.get("flavor", "")

        # Dates
        self.created_at = self.format_date(task_dict.get("created_at", ""))
        self.updated_at = self.format_date(task_dict.get("updated_at", ""))
        self.finished_at = self.format_date(task_dict.get("finished_at", ""))

        # Task Image
        task_image = {
            "visible_id": task_dict.get("task_image", {}),
            "name": task_dict.get("task_image_name", ""),
            "version": task_dict.get("task_image_version", ""),
        }
        self.task_image = TaskImageModel(task_image)
        self.task_image_name = task_dict.get("task_image_name", "")
        self.task_image_version = task_dict.get("task_image_version", "")

        # Outputs
        self.logs_stderr = task_dict.get("logs_stderr", "")
        self.logs_stdout = task_dict.get("logs_stdout", "")
        self.errors = task_dict.get("errors", "")

    def format_date(self, date: str) -> str:
        return format_date(date)

    def update_from_dict(self, task: dict = {}):
        for key, value in task.items():
            if hasattr(self, key):
                if not getattr(self, key):
                    setattr(self, key, value)

    def to_post_dict(self) -> dict:
        input_artifacts = [
            artifact.to_artifact_dict() for artifact in self.artifact_inputs
        ]

        runtime_params = {}
        for input in self.runtime_inputs:
            runtime_params = {**runtime_params, **input.to_runtime_dict()}

        output_params = {}
        for output in self.outputs_versions:
            output_params = {**output_params, **output.to_output_dict()}
        
        body = {
            "params": {
                "criticality_settings": self.criticality_settings,
                "inputs": {
                    "artifacts": input_artifacts,
                    "params": runtime_params,
                },
                "outputs_versions": output_params,
                "flavor": self.flavor,
            },
            "task_image": self.task_image_name,
            "tags": self.tags,
        }
        return body

    def __str__(self) -> str:
        # task image name, task image version, status, username, created_at
        return f"{COLORS.BOLD}{self.task_image_name}:{self.task_image_version}:{COLORS.ENDC} - {self.status} - {self.username} - {self.created_at}"
