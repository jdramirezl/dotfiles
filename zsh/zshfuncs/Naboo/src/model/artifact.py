from typing import Dict

from src.utils import format_date
from src.constants.general import COLORS

class ArtifactModel:
    # init based on the json above with names joined by underscores and in lowercase
    def __init__(self, artifact: dict):
        # Basic info
        self.id = artifact.get("artifact_id", "")
        self.name = artifact.get("artifact_name", "")
        self.version = artifact.get("version", "")
        self.type = artifact.get("type", "")
        self.status = artifact.get("status", "")
        self.is_valid = artifact.get("is_valid", "")
        self.value = artifact.get("value", "")

        # Dates
        self.creation_date = self.format_date(artifact.get("creation_date", ""))

        # Metadata
        self.tags = artifact.get("tags", [])
        self.ttl = artifact.get("ttl", "")

    def update_from_dict(self, artifact: dict = {}):
        for key, value in artifact.items():
            if hasattr(self, key):
                if not getattr(self, key):
                    setattr(self, key, value)

    def format_date(self, date: str = ""):
        return format_date(date)

    def __str__(self):
        output = ""
        for key, value in self.__dict__.items():
            output += f"{COLORS.BLUE}{key}{COLORS.END}: {value}\n"
        return output

    def to_artifact_dict(self) -> Dict[str, str]:
        return {
            "id": self.id,
            "alias": self.name,
        }

    def to_runtime_dict(self) -> Dict[str, str]:
        return {
            self.name: self.value,
        }

    def to_output_dict(self) -> Dict[str, str]:
        return {
            self.name: self.version,
        }
