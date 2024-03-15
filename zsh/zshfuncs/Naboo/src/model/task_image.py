from src.utils import format_date
from src.settings import settings
from src.constants.general import COLORS


class TaskImageModel:
    def __init__(self, task_image: dict) -> None:
        # Task Image
        self.visible_id = task_image.get("visible_id", "")
        self.name = task_image.get("name", "")
        self.version = task_image.get("version", "")
        self.username = task_image.get("username", "")
        self.status = task_image.get("status", "")
        self.description = task_image.get("description", "")

        # Metadata
        self.task_type = task_image.get("task_type", "")
        self.branch = task_image.get("branch", "")
        self.tags = task_image.get("tags", "")
        self.tags_propagation_enabled = task_image.get(
            "tags_propagation_enabled", False
        )

        # Files
        self.local_task_file_path = task_image.get("local_tasks_spec_file_path", "")
        self.local_artifacts_file_path = task_image.get(
            "local_artifacts_spec_file_path", ""
        )

        # Git
        self.repository = task_image.get("repository", "")
        self.commit_id = task_image.get("commit_id", "")

        # Dates
        self.created_at = self.format_date(task_image.get("created_at", ""))
        self.updated_at = self.format_date(task_image.get("updated_at", ""))
        self.finished_at = self.format_date(task_image.get("finished_at", ""))

        # STDOUT and STDERR
        self.logs_stderr = task_image.get("logs_stderr", "")
        self.logs_stdout = task_image.get("logs_stdout", "")
        self.errors = task_image.get("errors", "")

    def format_date(self, date: str) -> str:
        return format_date(date)

    def update_from_dict(self, task_image: dict = {}):
        for key, value in task_image.items():
            if hasattr(self, key):
                if not getattr(self, key):
                    setattr(self, key, value)

    def to_post_dict(self) -> dict:
        body = {
            "name": self.name,
            "application": settings.APPLICATION,
            "version": self.version,
            "commit_id": self.commit_id,
            "local_tasks_spec_file_path": self.local_task_file_path,
            "local_artifacts_spec_file_path": self.local_artifacts_file_path,
            "repository": self.repository,
            "description": self.description,
            "branch": self.branch,
            "tags": self.tags,
            "tags_propagation_enabled": self.tags_propagation_enabled,
        }

        return body

    def __str__(self) -> str:
        # version status username created at
        return f"{COLORS.BLUE}{self.name}:{self.version}{COLORS.ENDC} - {self.status} - {self.username} - {self.created_at}"
