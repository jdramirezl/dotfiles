import datetime
import re

from src.constants.general import COLORS


def format_date(date: str = ""):
    if not date:
        return date
    return datetime.datetime.strptime(date, "%Y-%m-%dT%H:%M:%S.%fZ").strftime(
        "%Y-%m-%d %Hh:%Mm"
    )


def tree_print(iterable, indent=2):
    INDENT = 2
    if isinstance(iterable, dict):
        for key, value in iterable.items():
            if isinstance(value, dict) or isinstance(value, list):
                end = "\n"
            else:
                end = ": "
            print("  " * indent + COLORS.GREEN + str(key) + COLORS.ENDC, end=end)
            tree_print(value, indent + INDENT)
    elif isinstance(iterable, list):
        for value in iterable:
            tree_print(value, indent + INDENT)
    else:
        print(str(iterable))


def tree_to_list(iterable, path_list, path=[]) -> list:
    INDENT = 2
    if isinstance(iterable, dict):
        for key, value in iterable.items():
            if isinstance(value, dict) or isinstance(value, list):
                end = "\n"
            else:
                end = ": "
            path.append(key)
            path_list.append(path[:])
            tree_to_list(value, path_list, path)
            path.pop()
    elif isinstance(iterable, list):
        for value in iterable:
            tree_to_list(value, path_list, path)
    return path_list


# Change nested values in a dict or list based on a path
def change_nested_value(iterable, path, value):
    if len(path) == 1:
        iterable[path[0]] = value
    else:
        if path[0] in iterable:
            change_nested_value(iterable[path[0]], path[1:], value)
        else:
            iterable[path[0]] = {}
            change_nested_value(iterable[path[0]], path[1:], value)


def get_nested_value(iterable, path):
    if len(path) == 1:
        # check if the path exists
        if path[0] in iterable:
            return iterable[path[0]]
        else:
            return None
    else:
        if path[0] in iterable:
            return get_nested_value(iterable[path[0]], path[1:])
        else:
            return None


def limit_str(string, length=25):
    # limit but if the string is smaller than the limit, fill the rest with spaces
    if len(string) > length:
        return string[:length]
    return string + " " * (length - len(string))


def increase_version(version: str) -> str:
    match = re.search(r"\d+$", version)
    if match:
        last_number = match.group(0)
        new_last_number = str(int(last_number) + 1)
        version = version[: match.start()] + new_last_number + version[match.end() :]

    return version


# Delete printed lines
def clear_lines(n: int):
    s = "5    3.0.0-rc-2                                                                                                                          pending               "
    for _ in range(n):
        print("\033[A" + " " * len(s) + "\033[A")
