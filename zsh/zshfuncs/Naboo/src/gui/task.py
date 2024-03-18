import datetime
import os

from typing import List, Optional, Union

from src.fda import FDA
from src.utils import GitHub
from src.repository import (
    ArtifactCLIRepository,
    ArtifactLocalRepository,
    TaskImageAPIRepository,
    TaskLocalRepository,
    TaskAPIRepository,
)
from src.model import (
    ArtifactModel,
    TaskImageModel,
    TaskModel,
)

from src.service import TaskService
from src.service import ArtifactService
from src.service import TaskImageService

from src.constants.fda import FDA_FILE
from src.constants.general import PRINT, COLORS, FURY_URLS
from src.constants.task import TASK_MESSAGES, TASK_CONFIG
from src.constants.task_image import TASK_IMAGE_MESSAGES

from src.utils import File, Toast, utils

from src.settings import settings
from src.gui.gui import GUI


class TaskGUI(GUI):
    def __init__(self):
        super().__init__()

        # Create a task service
        self.task_service = TaskService(TaskAPIRepository())

        # Create an artifact service
        self.artifact_service = ArtifactService(ArtifactCLIRepository({}))

    def check_task_prepare(self) -> None:
        self.check_status(self.task_service, TASK_MESSAGES)

    def update_artifact(self, artifact: ArtifactModel) -> None:
        # 1. Let the user choose a new version
        artifacts = self.artifact_service.get_by_name(artifact.name)

        if not artifacts:
            print(f"{TASK_MESSAGES.FAILURE} No artifacts found")
            return

        print(f"artifacts: {artifacts}")

        # 2. Let the user choose one of the versions
        index = self._select([[artifact.version] for artifact in artifacts])
        new_version = artifacts[index]

        # 2. Update the artifact
        artifact.name = new_version.name
        artifact.version = new_version.version

    def update_artifacts_to_latest(
        self, artifacts: List[ArtifactModel]
    ) -> List[ArtifactModel]:
        # Get the newest artifact
        repository = ArtifactCLIRepository({})
        artifact_service = ArtifactService(repository)

        for i, artifact in enumerate(artifacts):
            newest = artifact_service.get_newest(artifact.name)
            if newest:
                artifacts[i] = newest

        return artifacts

    def autofill_task(self, task: TaskModel) -> None:
        artifact_service = ArtifactService(ArtifactCLIRepository({}))
        artifacts = artifact_service.get_all()

        # 1. Autofill the inputs
        task.artifact_inputs = self.update_artifacts_to_latest(task.artifact_inputs)

        # 2. Autofill the outputs
        task.outputs_versions = self.update_artifacts_to_latest(task.outputs_versions)

        # 2a. Update the outputs versions
        for artifact in task.outputs_versions:
            artifact.increase_version()

    def update_from_old_task(self, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Choose an old task version to use for the new values")
        old_task = self.choose_with_name(task.name, self.task_service)

        # 1. Update the task with the old task
        task.update_from_other_task(old_task)

    def update_tags(self, task: TaskModel) -> None:
        while True:
            # 1. Get the current tags
            print(f"{PRINT.SEPARATOR} Current tags:")
            for i, tag in enumerate(task.tags):
                print(f"{i+1}. {tag['name']}")

            print(f"{PRINT.SEPARATOR} What do you want to do ?")
            print("1. Add a tag")
            print("2. Remove a tag")
            print("3. Cancel")

            choice = input("Enter the number of the option: ")

            if choice == "1":
                value = input("Enter the new tag: ")
                task.tags.append({"name": value})
            elif choice == "2":
                index = self._select([[tag["name"]] for tag in task.tags])
                task.tags.pop(index)
            elif choice == "3":
                break
            else:
                print("Invalid choice")

    def update_artifact_inputs(self, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Current artifact inputs:")
        for i, artifact in enumerate(task.artifact_inputs):
            print(f"{i+1}. {artifact.name} -> {artifact.version}")
        # 2. Let the user choose an artifact to update
        options = [[artifact.name] for artifact in task.artifact_inputs]
        index = self._select(options)
        artifact = task.artifact_inputs[index]

        # 3. Start an artifactCLIService and let the user choose a new version for an artiwfact with the same name
        self.update_artifact(artifact)

    def update_runtime_inputs(self, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Current runtime inputs:")
        for i, task_input in enumerate(task.runtime_inputs):
            print(f"{i+1}. {task_input.name} -> {task_input.value}")
        # 2. Let the user choose an input to update
        options = [[input.name] for input in task.runtime_inputs]
        index = self._select(options)
        task_input = task.runtime_inputs[index]

        # 3. Update the input
        value = input("Enter the new value: ")
        task_input.value = value

    def update_outputs_versions(self, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Current outputs versions:")
        for i, output in enumerate(task.outputs_versions):
            print(f"{i+1}. {output.name} -> {output.version}")

        # 2. Let the user choose an output to update
        options = [[output.name] for output in task.outputs_versions]
        index = self._select(options)
        output = task.outputs_versions[index]

        # 3. Update the output
        value = input("Enter the new version: ")
        output.version = value

    def update_section_manually(self, task: TaskModel) -> None:
        # You can:
        # Change a criticality_settings/level
        # Change a params/flavor
        # add or remove tags
        # or change the params/inputs/artifacts, params/inputs/params, params/outputs_versions but not add or remove them

        # 1. Let the user choose a section
        while True:
            # print the task
            print(f"{PRINT.SEPARATOR} The task to be updated:")
            utils.tree_print(task.to_post_dict())

            print(f"{PRINT.SEPARATOR} Choose a section to update")

            print(f"1. Criticality Settings Level")
            print(f"2. Flavor")
            print(f"3. Tags")
            print(f"4. Artifact Inputs")
            print(f"5. Runtime Inputs")
            print(f"6. Outputs Versions")
            print(f"7. Go back")

            choice = input("Enter the number of the option: ")

            if choice == "1":
                index = self._select([[level] for level in TASK_CONFIG.CRITICALITY])
                task.criticality_settings["level"] = TASK_CONFIG.CRITICALITY[index]
            elif choice == "2":
                index = self._select([[flavor] for flavor in TASK_CONFIG.FLAVOR])
                task.flavor = TASK_CONFIG.FLAVOR[index]
            elif choice == "3":
                self.update_tags(task)
            elif choice == "4":
                self.update_artifact_inputs(task)
            elif choice == "5":
                self.update_runtime_inputs(task)
            elif choice == "6":
                self.update_outputs_versions(task)
            elif choice == "7":
                pass
            else:
                print("Invalid choice")

    def get_task_sections(self, task: TaskModel) -> dict:
        sections = []
        utils.tree_to_list(task.to_post_dict(), sections)

        dict_sections = {}
        for i, section in enumerate(sections):
            section_path, value = section

            original_section_path = section_path

            if section_path[0] == "params":
                section_path = section_path[1:]

            if section_path[:-1]:
                section_path = section_path[:-1]

            if isinstance(section_path[-1], int):
                section_path = section_path[:-1]

            key = tuple(section_path)
            if not key in dict_sections.keys():
                dict_sections[key] = []

            dict_sections[key].append([original_section_path, value, i])
        return dict_sections

    def choose_task_sections(self, task: TaskModel) -> List[str]:
        dict_sections = self.get_task_sections(task)

        # 1. Let the user choose what to update
        print(f"{PRINT.SEPARATOR} What section do you want to update ?")
        # ask the user if they want to update a single value or the whole section
        print(f"1. Update all")
        print(f"2. Update a single value")
        print(f"3. Cancel")

        options = {i: section for i, section in enumerate(dict_sections.keys())}
        while True:
            choice = input("Enter the number of the option: ")
            if choice == "1":
                indexes = [i for i in range(len(dict_sections))]
                break
            elif choice == "2":
                indexes = self._select_multiple(
                    list(dict_sections.keys()), separator=" -> "
                )
                break
            elif choice == "3":
                indexes = []
            else:
                print("Invalid choice")
        sections = [dict_sections[options[i]] for i in indexes]
        return sections

    def run_task(self) -> None:
        # 1. Let the user choose a local task
        local_task = self.choose_local_task()
        local_task_name = local_task.name

        # 2. Let the user choose a task_image version for it (if it exists)
        task_image = self.choose_with_name(local_task_name, self.task_image_service)

        # 2a. Fill the task with the task_image parameters
        if task_image:
            local_task.tags = task_image.tags
            local_task.task_image_id = task_image.visible_id
            local_task.version = task_image.version
            local_task.name = task_image.name

        # 3. Autofill the task
        self.autofill_task(local_task)

        # 4. Let the user update parts of the task
        while True:
            print(f"{PRINT.SEPARATOR} The task to be run:")
            utils.tree_print(local_task.to_post_dict())

            print(f"{PRINT.SEPARATOR} What do you want to do ?")
            print("1. Run the task")
            print("2. Update with an old task")
            print("3. Update a value manually")
            print("4. Cancel")

            choice = input("Enter the number of the option: ")

            if choice == "1":
                print(f"{PRINT.SEPARATOR} Running the task...")
                self.task_service.create(local_task)
            elif choice == "2":
                self.update_from_old_task(local_task)
            elif choice == "3":
                self.update_section_manually(local_task)
            else:
                print("Invalid choice")
