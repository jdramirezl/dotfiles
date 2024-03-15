import yaml
import os
import datetime
import json


class File:
    @staticmethod
    def find_file(file_name: str) -> str:
        current_dir = os.getcwd()
        while True:
            file_path = os.path.join(current_dir, file_name)
            if os.path.isfile(file_path):
                return file_path

            # Move one directory up
            parent_dir = os.path.dirname(current_dir)

            # If parent directory is the same as current directory, it means we've reached the root
            if parent_dir == current_dir:
                print(f"File not found: {file_name}")
                return ""

            current_dir = parent_dir

    @staticmethod
    def read_yaml(file_path: str) -> dict:
        try:
            with open(file_path, "r") as file:
                return yaml.safe_load(file)
        except Exception as e:
            print(f"Error reading file: {e}")
            raise e

    @staticmethod
    def read_json(file_path: str) -> dict:
        try:
            with open(file_path, "r") as file:
                return json.load(file)
        except Exception as e:
            print(f"Error reading file: {e}")
            raise e

    @staticmethod
    def read_file(file_path: str) -> str:
        try:
            with open(file_path, "r") as file:
                return file.read()
        except Exception as e:
            print(f"Error reading file: {e}")
            raise e
