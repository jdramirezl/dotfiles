# create a color for print enum
class COLORS:
    # reset
    HEADER = "\033[95m"
    ENDC = "\033[0m"

    # colors
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    RED = "\033[91m"
    YELLOW = "\033[93m"
    WHITE = "\033[97m"
    PURPLE = "\033[95m"

    # alerts
    DEBUG = BLUE
    SUCCESS = GREEN
    WARNING = YELLOW
    FAIL = RED

    # styles
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


class PRINT:
    # Loading icons
    LOADING_ICONS = ["|", "/", "-", "\\"]
    DIVIDER_DOUBLE = "========================================"
    DIVIDER_SINGLE = "----------------------------------------"
    SEPARATOR = ">>>>>>>>"
    PRINT_LEN = 15
    PRINT_LEN_LOW = 7


class FURY_URLS:
    # Fury URL
    FURY_URL = "https://web.furycloud.io/"
