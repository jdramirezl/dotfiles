import re
import subprocess
import yaml

from typing import List
from abc import abstractmethod

from src.utils import File
from src.repository.repository import Repository
from src.model import ArtifactModel


class ArtifactRepository(Repository):
    @abstractmethod
    def get(self, artifact_id: str) -> ArtifactModel:
        pass

    @abstractmethod
    def get_all(self) -> List[ArtifactModel]:
        pass

    @abstractmethod
    def post(self, artifact: ArtifactModel) -> None:
        pass


class ArtifactCLIRepository(ArtifactRepository):
    def __init__(self, config):
        pass

    def get(self, artifact_id: str) -> ArtifactModel:
        artifacts = self.get_all()
        for artifact in artifacts:
            if artifact.id == artifact_id:
                return artifact
        print(f"Artifact {artifact_id} not found")
        raise Exception(f"Artifact {artifact_id} not found")

    def get_all(self) -> List[ArtifactModel]:
        command = "fda artifact list --limit 0"
        # artifacts_output = subprocess.check_output(command, shell=True).decode().strip()
        try:
            artifacts_output = (
                subprocess.check_output(command, shell=True).decode().strip()
            )
        except subprocess.CalledProcessError as e:
            print(f"Error: {e}")
            print(f"Output: {e.output}")
            return []
        artifacts = artifacts_output.split("\n")

        headers = re.split(r"  +", artifacts[0].strip())
        headers = [header.strip().lower().replace(" ", "_") for header in headers]
        # replace creation_date_(utc) by creation_date
        headers = [
            header.replace("creation_date_(utc)", "creation_date") for header in headers
        ]

        artifacts = [re.split(r"  +", artifact.strip()) for artifact in artifacts[2:]]

        artifacts = [
            {header: value for header, value in zip(headers, artifact)}
            for artifact in artifacts
        ]

        artifacts = [ArtifactModel(artifact) for artifact in artifacts]

        if not artifacts:
            print("No artifacts found")
            raise Exception("No artifacts found")
        return artifacts

    def post(self, artifact):
        raise NotImplementedError


class ArtifactLocalRepository(ArtifactRepository):
    def __init__(self, config):
        self.artifact_file = config.get("artifact_file", "artifacts.yml")

    def get(self, artifact_name: str) -> ArtifactModel:
        artifacts = self.get_all()
        for artifact in artifacts:
            if artifact.name == artifact_name:
                return artifact
        print(f"Artifact {artifact_name} not found")
        raise Exception(f"Artifact {artifact_name} not found")

    def get_all(self) -> List[ArtifactModel]:
        artifacts = File.read_yaml(self.artifact_file)

        if not artifacts:
            print("No artifacts found")
            raise Exception("No artifacts found")

        # filter
        artifacts = artifacts["artifacts"]
        del artifacts["def_version"]

        artifacts = [
            {"artifact_name": artifact_name, **artifact}
            for artifact_name, artifact in artifacts.items()
        ]
        artifacts = [ArtifactModel(artifact) for artifact in artifacts]

        return artifacts

    def post(self, artifact):
        raise NotImplementedError
