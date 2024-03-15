import datetime


def format_date(date: str = ""):
    if date == "":
        return date
    return datetime.datetime.strptime(date, "%Y-%m-%dT%H:%M:%S.%fZ").strftime(
        "%Y-%m-%d %Hh:%Mm"
    )

def tree_print(iterable, indent=0):
    if isinstance(iterable, dict):
        for key, value in iterable.items():
            print("  " * indent + str(key))
            tree_print(value, indent + 4)
    elif isinstance(iterable, list):
        for value in iterable:
            tree_print(value, indent + 4)
    else:
        print("  " * indent + str(iterable))

def limit_str(string, length=25):
    # limit but if the string is smaller than the limit, fill the rest with spaces
    if len(string) > length:
        return string[:length]
    return string + " " * (length - len(string))