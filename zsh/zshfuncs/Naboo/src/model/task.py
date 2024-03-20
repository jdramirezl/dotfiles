from re import A
from src.utils import utils
from src.model.artifact import ArtifactModel
from src.model.task_image import TaskImageModel
from src.constants.general import COLORS


class TaskModel:
    def __init__(self, task_dict: dict) -> None:
        # Task
        self.id = task_dict.get("id", "")
        self.visible_id = task_dict.get("visible_id", "")
        self.task_type = task_dict.get("type", "")
        self.username = task_dict.get("username", "")
        self.status = task_dict.get("status", "")

        # Params
        self.params = task_dict.get("params", {})
        self.tags = task_dict.get("tags", [])

        # Data
        self.criticality_settings = self.params.get(
            "criticality_settings", {"level": "test"}
        )

        self.criticality_level = self.criticality_settings.get("level", "test")

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
        self.flavor = self.params.get("flavor", "small")

        # Dates
        self.created_at = self.format_date(task_dict.get("created_at", ""))
        self.updated_at = self.format_date(task_dict.get("updated_at", ""))
        self.finished_at = self.format_date(task_dict.get("finished_at", ""))

        # Task Image
        self.task_image_id = task_dict.get("task_image", "")
        self.name = task_dict.get("task_image_name", "")
        self.version = task_dict.get("task_image_version", "")

        # Outputs
        self.logs_stderr = task_dict.get("logs_stderr", "")
        self.logs_stdout = task_dict.get("logs_stdout", "")
        self.errors = task_dict.get("errors", "")

    def format_date(self, date: str) -> str:
        return utils.format_date(date)

    def print_change(self, old_value: str, new_value: str, name: str) -> None:
        # use colors
        print(f"{COLORS.BOLD}{name}{COLORS.ENDC}: {old_value} -> {new_value}")

    def update_from_other_task(self, task: "TaskModel") -> None:
        # print: old value -> new value
        # self.print_change(
        #     self.flavor,
        #     task.flavor,
        #     "Flavor",
        # )
        self.flavor = task.flavor

        # Add new tags only
        for tag in task.tags:
            if tag not in self.tags:
                # self.print_change("", tag, "Tag")
                self.tags.append(tag)

        # Update inputs that exist in both tasks, dont add new ones or remove old ones
        for input in task.runtime_inputs:
            for self_input in self.runtime_inputs:
                if input.name == self_input.name:
                    self_input.value = input.value

        # Update inputs that exist in both tasks, dont add new ones or remove old ones
        for input in task.artifact_inputs:
            for self_input in self.artifact_inputs:
                if input.name == self_input.name:
                    self_input.id = input.id

        # Update outputs that exist in both tasks, dont add new ones or remove old ones
        for output in task.outputs_versions:
            for self_output in self.outputs_versions:
                if output.name == self_output.name:
                    self_output.version = output.version

    def to_post_dict(self) -> dict:
        input_artifacts = [
            artifact.to_artifact_dict() for artifact in self.artifact_inputs
        ]

        runtime_params = {}
        for input in self.runtime_inputs:
            runtime_params = {**runtime_params, **input.to_runtime_dict()}

        output_params = {
            output.name: output.version for output in self.outputs_versions
        }

        body = {
            "params": {
                "criticality_settings": {
                    "level": self.criticality_level,
                },
                "inputs": {
                    "artifacts": input_artifacts,
                    "params": runtime_params,
                },
                "outputs_versions": output_params,
                "flavor": self.flavor,
                "retry": {
                    "repetitions": 0,
                },
            },
            "task_image": self.task_image_id,
            "tags": self.tags,
        }
        return body

    def print_with_indent(self, string: str, indent: int = 0) -> None:
        print("  " * indent + string)

    def __str__(self) -> str:
        base_indent = 0
        lines = []
        lines.append([f"{COLORS.BOLD}Task{COLORS.ENDC}", base_indent])
        lines.append(["Params", base_indent + 1])
        lines.append(["Criticality Settings", base_indent + 2])
        lines.append([f"Level: {self.criticality_level}", base_indent + 3])
        lines.append(["Inputs", base_indent + 1])
        lines.append(["Artifacts", base_indent + 2])
        for artifact in self.artifact_inputs:
            lines.append([str(artifact.to_artifact_dict()), base_indent + 3])
        lines.append(["Params", base_indent + 2])
        for input in self.runtime_inputs:
            lines.append([str(input.to_runtime_dict()), base_indent + 3])
        lines.append(["Outputs Versions", base_indent + 1])
        for output in self.outputs_versions:
            lines.append([str(output.to_artifact_dict()), base_indent + 2])
        lines.append([f"Flavor: {self.flavor}", base_indent + 1])
        lines.append(["Task Image", base_indent])
        lines.append([f"Name: {self.name}", base_indent + 1])
        lines.append([f"Version: {self.version}", base_indent + 1])
        lines.append(["Tags", base_indent])
        for tag in self.tags:
            lines.append([tag, base_indent + 1])
        for line in lines:
            self.print_with_indent(line[0], line[1])

        return ""
