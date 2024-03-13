import datetime

class TaskImageModel:
    # task image
    visible_id: str
    name: str
    version: str
    username: str
    status: str

    # metadata
    task_type: str
    commit_id: str

    # dates
    created_at: str
    updated_at: str
    finished_at: str

    # outputs
    logs_stderr: str
    logs_stdout: str
    errors: str

    def __init__(self, task_image: dict) -> None:
        for key, value in task_image.items():
            # check if key is in dataclass
            if key in self.__dataclass_fields__:
                setattr(self, key, value)
        
        # Format the created_at and updated_at fields]
        self.created_at = self.format_date(self.created_at)
        self.updated_at = self.format_date(self.updated_at)
        self.finished_at = self.format_date(self.finished_at)
        
    def format_date(self, date: str) -> str:
        return datetime.datetime.strptime(
                date, "%Y-%m-%dT%H:%M:%S.%fZ"
            ).strftime("%Y-%m-%d %H:%M:%S")