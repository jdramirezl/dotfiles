from typing import List, Optional

from src.model import ArtifactModel
from src.repository import ArtifactRepository


class ArtifactService:
    def __init__(self, artifact_repository: ArtifactRepository) -> None:
        self.repository = artifact_repository

    def get(self, artifact_id: str) -> ArtifactModel:
        return self.repository.get(artifact_id)

    def get_all(self) -> List[ArtifactModel]:
        return self.repository.get_all()

    def get_by_name(self, name: str) -> Optional[ArtifactModel]:
        artifacts = self.repository.get_all()
        for artifact in artifacts:
            if artifact.name == name:
                return artifact
        return None

    def create(self, artifact: ArtifactModel) -> None:
        pass
