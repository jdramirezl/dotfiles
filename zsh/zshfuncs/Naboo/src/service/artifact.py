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

    def get_by_name(self, name: str) -> List[ArtifactModel]:
        artifacts = self.repository.get_all()
        return [artifact for artifact in artifacts if artifact.name == name]

    def create(self, artifact: ArtifactModel) -> None:
        pass

    def get_newest(self, name: str) -> Optional[ArtifactModel]:
        artifacts = self.repository.get_all()
        newest = None
        for artifact in artifacts:
            if artifact.name == name:
                if not newest:
                    newest = artifact
                else:
                    if artifact.creation_date > newest.creation_date:
                        newest = artifact
        return newest

    def get_oldest(self, name: str) -> Optional[ArtifactModel]:
        artifacts = self.repository.get_all()
        oldest = None
        for artifact in artifacts:
            if artifact.name == name:
                if not oldest:
                    oldest = artifact
                else:
                    if artifact.creation_date < oldest.creation_date:
                        oldest = artifact
        return oldest

    def get_by_type(self, artifact_type: str) -> List[ArtifactModel]:
        artifacts = self.repository.get_all()
        return [artifact for artifact in artifacts if artifact.type == artifact_type]

    def update_to_latest(self, artifact: ArtifactModel) -> ArtifactModel:
        # 1. Get the newest artifact
        newest = self.get_newest(artifact.name)

        if not newest:
            print(f"No latest artifact found for {artifact.name}")
            return artifact

        # 2. Update the artifact
        artifact = newest
        return artifact
