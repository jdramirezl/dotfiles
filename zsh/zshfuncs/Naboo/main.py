import sys

from src.gui import TaskImageGUI, TaskGUI


if __name__ == "__main__":
    run_type = sys.argv[1]
    option = sys.argv[2]
    args = sys.argv[3:] if len(sys.argv) > 3 else []

    if len(args) > 1:
        name = args[0]
        version = args[-1]
        args = args[1:-1]
    else:
        name = ""
        version = ""
        args = []

    config = {"name": name, "version": version}

    if run_type.lower() == "task-image":
        task_image = TaskImageGUI()
        if option.lower() == "prepare":
            task_image.prepare_task_image()
        elif option.lower() == "check":
            task_image.check_image_prepare()
    elif run_type.lower() == "task":
        task = TaskGUI()
        if option.lower() == "check":
            task.check_task_prepare()
        elif option.lower() == "run":
            task.run_task()
