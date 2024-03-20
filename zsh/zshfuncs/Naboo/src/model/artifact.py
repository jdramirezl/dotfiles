from typing import Dict
import datetime

from src.utils import utils
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
        if not date:
            return date  # '2024-03-13 17:00'
        datetime_obj = datetime.datetime.strptime(date, "%Y-%m-%d %H:%M")
        formatted_date = datetime_obj.strftime("%B %d, %Y at %I:%M %p")
        return formatted_date

    def __str__(self):
        output = ""
        # for key, value in self.__dict__.items():
        #     output += f"{COLORS.BLUE}{key}{COLORS.ENDC}: {value}\n"

        # only print the id, name, version, type, status, and creation date
        keys = ["id", "name", "version", "type", "status", "creation_date"]
        for key in keys:
            output += f"{COLORS.BLUE}{key}{COLORS.ENDC}: {self.__dict__[key]}\n"

        return output

    def to_artifact_dict(self) -> Dict[str, str]:
        """
        "id": "string",
          "version_expression": "string",
          "alias": "string"
        """
        return {"id": self.id, "version_expression": self.version, "alias": self.name}

    def to_runtime_dict(self) -> Dict[str, str]:
        return {
            self.name: self.value,
        }

    def to_output_dict(self) -> Dict[str, str]:
        return {
            self.name: self.version,
        }

    def increase_version(self):
        self.version = utils.increase_version(self.version)
