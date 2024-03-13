import sys
import yaml

from utils import bcolors, SEPARATOR
from task_image import TaskImage
from task import Task


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
        task_image = TaskImage()

        if option.lower() == "prepare":
            tags = []
            for i, arg in enumerate(args):
                if arg == "-t":
                    tag = {"name": args[i + 1]}
                    tags.append(tag)

            config["tags"] = tags

            # Prepare the task image
            new_name, new_version = task_image.prepare(config)
            print(
                f"{SEPARATOR} New task image: {bcolors.OKGREEN}{new_name}{bcolors.ENDC} - {bcolors.OKGREEN}{new_version}{bcolors.ENDC}"
            )

            # Check the deployment status
            config = {"name": new_name, "version": new_version}
            task_image.check_deployment_status(config)

        elif option.lower() == "check":
            task_image.check_deployment_status(config)
    elif run_type.lower() == "task":
        task = Task()
        if option.lower() == "check":
            task.check_run_status(config)
        elif option.lower() == "run":
            task.run(config)
