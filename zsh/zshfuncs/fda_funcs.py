import subprocess


def fdar(id):
    expected_outputs = []
    expected_inputs_runtime = []
    expected_inputs_artifacts = []

    output = subprocess.check_output(["fda", "task-image", "info", str(id)], text=True)

    current_section = ""
    for line in output.splitlines():
        if "Expected outputs:" in line:
            current_section = "expected_outputs"
        elif "runtime:" in line:
            current_section = "expected_inputs_runtime"
        elif "artifacts:" in line:
            current_section = "expected_inputs_artifacts"
        elif line.startswith("-"):
            parts = line.split(":")
            if current_section == "expected_outputs":
                expected_outputs.append(parts[-1].strip())
            elif current_section == "expected_inputs_runtime" and "name" in line:
                expected_inputs_runtime.append(parts[-1].strip())
            elif current_section == "expected_inputs_artifacts":
                expected_inputs_artifacts.append(parts[-1].strip())
        elif "Tags:" in line:
            break

    # Prompt user for versions and update list elements
    for i, item in enumerate(expected_outputs):
        version = input(f"Enter version for {item}: ")
        expected_outputs[i] = f"{item}:{version}"

    for i, item in enumerate(expected_inputs_runtime):
        version = input(f"Enter version for {item}: ")
        expected_inputs_runtime[i] = f"{item}:{version}"

    for i, item in enumerate(expected_inputs_artifacts):
        version = input(f"Enter version for {item}: ")
        expected_inputs_artifacts[i] = f"{item}:{version}"

    # Output the collected data
    print("Expected Outputs:")
    for item in expected_outputs:
        print(item)
    print("\nExpected Inputs/Runtime:")
    for item in expected_inputs_runtime:
        print(item)
    print("\nExpected Inputs/Artifacts:")
    for item in expected_inputs_artifacts:
        print(item)


id = input()
# fdar(id)
