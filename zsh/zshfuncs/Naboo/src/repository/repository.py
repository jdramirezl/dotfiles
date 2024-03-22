from abc import ABC, abstractmethod


class Repository(ABC):
    @abstractmethod
    def get(self, artifact):
        pass

    @abstractmethod
    def get_all(self):
        pass

    @abstractmethod
    def post(self, artifact) -> str:
        pass

