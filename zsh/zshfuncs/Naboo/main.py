from src.service import TaskService
from src.repository import TaskAPIRepository
from src.gui import TaskGUI

if __name__ == "__main__":
    task_gui = TaskGUI()
    task_gui.run_task()

    # repo = TaskAPIRepository()
    # service = TaskService(repo)
    # tasks = service.get_all()
    #
    # for task in tasks[: min(5, len(tasks))]:
    #     task = service.get(task.visible_id)
    #     print(task.to_post_dict())
