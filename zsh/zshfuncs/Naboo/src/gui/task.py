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
    TaskCLIRepository,
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

        # 2. Let the user choose one of the versions
        index = self._select([[artifact.version] for artifact in artifacts])
        new_version = artifacts[index]

        # 2. Update the artifact
        # iter through the artifacts attributes
        print(
            f"{PRINT.SEPARATOR} New artifact: {new_version.name} {new_version.version}"
        )
        for attribute in new_version.__dict__:
            setattr(artifact, attribute, getattr(new_version, attribute))

    def update_artifact_to_latest(self, artifact: ArtifactModel) -> ArtifactModel:
        # Get the newest artifact
        repository = ArtifactCLIRepository({})
        artifact_service = ArtifactService(repository)

        newest = artifact_service.get_newest(artifact.name)

        return newest if newest else artifact

    def autofill_task(self, task: TaskModel) -> None:
        artifact_service = ArtifactService(ArtifactCLIRepository({}))
        artifacts = artifact_service.get_all()

        # 1. Autofill the inputs
        for i, artifact in enumerate(task.artifact_inputs):
            # 1a. Autofill the artifact
            task.artifact_inputs[i] = self.update_artifact_to_latest(artifact)

        # 2. Autofill the outputs
        for i, artifact in enumerate(task.outputs_versions):
            # 2a. Autofill the artifact
            task.outputs_versions[i] = self.update_artifact_to_latest(artifact)

        # 2a. Update the outputs versions
        for artifact in task.outputs_versions:
            artifact.increase_version()

    def update_from_old_task(self, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Choose an old task version to use for the new values")
        old_task = self.choose_with_name(task.name, self.task_service)

        if not old_task:
            return None

        # 1. Update the task with the old task
        task.update_from_other_task(old_task)

        utils.clear_lines(1)

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

            utils.clear_lines(6 + len(task.tags))

            if choice == "1":
                value = input("Enter the new tag: ")
                task.tags.append({"name": value})
                utils.clear_lines(1)
            elif choice == "2":
                index = self._select([[tag["name"]] for tag in task.tags])
                task.tags.pop(index)
            elif choice == "3":
                break
            else:
                print("Invalid choice")

    def update_runtime_inputs(self, task_input: ArtifactModel) -> None:
        value = input("Enter the new value: ")
        task_input.value = value
        utils.clear_lines(1)

    def update_outputs_versions(self, output: ArtifactModel) -> None:
        value = input("Enter the new version: ")
        output.version = value
        utils.clear_lines(1)

    def select_string(self, options, parameter, task: TaskModel) -> None:
        print(f"{PRINT.SEPARATOR} Choose a {parameter}")
        index = self._select(options)

        setattr(task, parameter, options[index][0])
        utils.clear_lines(1)

    def update_section_manually(self, task: TaskModel) -> None:
        # 1. Let the user choose a section
        while True:
            # print the task
            print(f"{PRINT.SEPARATOR} The task to be updated:")
            post_dict = task.to_post_dict()
            utils.tree_print(post_dict)

            # Get the items in each section
            sections = []

            # for criticality level
            sections.append(
                [
                    # "criticality_settings/level",
                    f"{COLORS.GREEN}criticality_settings/level{COLORS.ENDC}",
                    task.criticality_level,
                    (
                        self.select_string,
                        [[level] for level in TASK_CONFIG.CRITICALITY],
                        "criticality_level",
                        task,
                    ),
                ]
            )

            # for flavor
            sections.append(
                [
                    # "flavor",
                    f"{COLORS.GREEN}flavor{COLORS.ENDC}",
                    task.flavor,
                    (
                        self.select_string,
                        [[flavor] for flavor in TASK_CONFIG.FLAVOR],
                        "flavor",
                        task,
                    ),
                ]
            )

            # for tags
            sections.append(["tags", task.tags, (self.update_tags, task)])

            # for artifact inputs
            for i, artifact in enumerate(task.artifact_inputs):
                sections.append(
                    [
                        # f"artifact_inputs/{artifact.name} {artifact.version}", printwith color!
                        f"{COLORS.GREEN}artifact_input -> {artifact.name}{COLORS.ENDC} {artifact.version}",
                        artifact.id,
                        (self.update_artifact, task, artifact),
                    ]
                )

            # for runtime inputs
            for i, runtime_input in enumerate(task.runtime_inputs):
                sections.append(
                    [
                        # f"runtime_inputs/{runtime_input.name}",
                        f"{COLORS.GREEN}runtime_input -> {runtime_input.name}{COLORS.ENDC}",
                        runtime_input.value,
                        (self.update_runtime_inputs, runtime_input),
                    ]
                )

            # for outputs versions
            for i, output in enumerate(task.outputs_versions):
                sections.append(
                    [
                        # f"outputs_versions/{output.name}",
                        f"{COLORS.GREEN}output -> {output.name}{COLORS.ENDC}",
                        output.version,
                        (self.update_outputs_versions, output),
                    ]
                )

            # Add a go back option
            sections.append([f"{COLORS.RED}Go back{COLORS.ENDC}", None, None])

            # Let the user choose a section
            print(f"{PRINT.SEPARATOR} Choose a section to update")
            option = lambda x: f"{x[0]}: {x[1]}"
            index = self._select(
                [[option(section)] for section in sections], PAGE_MAX=len(sections)
            )

            if index == len(sections) - 1:
                break
            elif index > len(sections) - 1:
                print("Invalid choice")
                continue

            # Call the function with the parameters
            function, *parameters = sections[index][2]
            function(*parameters)
            utils.clear_lines(len(sections) + 1 + len(post_dict))

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
            post_dict = local_task.to_post_dict()
            utils.tree_print(post_dict)

            print(f"{PRINT.SEPARATOR} What do you want to do ?")
            print("1. Run the task")
            print("2. Update with an old task")
            print("3. Update a value manually")
            print("4. Cancel")

            choice = input("Enter the number of the option: ")

            to_clear = 7 + len(utils.tree_to_list(post_dict, []))
            utils.clear_lines(to_clear)

            if choice == "1":
                print(f"{PRINT.SEPARATOR} Running the task...")
                # self.task_service.create(local_task)
                # Create a service with CLI
                repository = TaskCLIRepository()
                service = TaskService(repository)
                id = service.create(local_task)
                print(f"{PRINT.SEPARATOR} The task has been created with the id: {id}")

                local_task.visible_id = id

                # monitor task status
                self.check_status(self.task_service, TASK_MESSAGES, local_task)
                break
            elif choice == "2":
                self.update_from_old_task(local_task)
            elif choice == "3":
                self.update_section_manually(local_task)
            elif choice == "4":
                break
            else:
                print("Invalid choice")
