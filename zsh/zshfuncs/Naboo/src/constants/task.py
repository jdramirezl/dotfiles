BASE_URL = "https://scheduler-fda.furycloud.io/v1/applications/"
TASK_URL = "scheduler/tasks/"


class TASK_MESSAGES:
    TITLE = "FDA Task"
    SUCCESS = "✅ Task preparation done!"
    FAILURE = "🚫 Task preparation Failed!"
    STARTING = "🛠️ Starting task..."

    URL = "tasks/"


class TASK_CONFIG:
    CRITICALITY = [
        "test",
        "low",
        "medium",
        "high",
    ]

    FLAVOR = [
        "small",
        "medium",
        "large",
        "xlarge",
        "gpu",
    ]
