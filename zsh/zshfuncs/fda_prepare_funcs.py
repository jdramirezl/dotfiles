import subprocess
import time
import yaml

from utils import notify, FDA

ti_toast = {
    "title": "FDA Task Image",
    "success": "✅ Task preparation done!",
    "failure": "🚫 Task preparation Failed!",
    "starting": "🛠️ Starting task preparation",
}


def check_deployment_status():
    version = input("Enter version: ")

    notify(ti_toast["title"], ti_toast["starting"], "", 4)

    start_time = time.time()

    while True:
        try:
            output = subprocess.check_output(
                ["fda", "task-image", "info", version], text=True
            )
        except subprocess.CalledProcessError as e:
            notify(ti_toast["title"], ti_toast["failure"], "", 2)
            print(e.output)
            return 1

        current_status = output.split("Status: ")[1].split("\n")[0].strip()
        if "PREPARED" in current_status:
            break
        elif current_status in [
            "STARTING PREPARE",
            "'PREPARE VALIDATION'",
            "PREPARING",
            "",
        ]:
            continue
        else:
            notify(ti_toast["title"], ti_toast["failure"], "", 2)
            errors = "\n".join(
                [
                    line.strip()
                    for line in output.split("Errors:")[1].split("\n")
                    if line.strip().startswith("-")
                ]
            )
            print(errors)
            return 1  # Stop execution with error
        print(f"\r\033{current_status}")
        time.sleep(7)
    end_time = time.time()
    diff = end_time - start_time
    time_message = f"Deployment finished in {diff} seconds!"

    notify(
        ti_toast["title"],
        ti_toast["success"],
        time_message,
        1,
    )


check_deployment_status()
# function check_deployment_status() {
#   local version output
#   version=$1
#
#   toast "🛠️ Starting task preparation"
#   while true; do
#     local current_status
#     output=$(fda task-image info "$version")
#     current_status=$(echo "$output" | grep -o 'Status: .*' | sed 's/Status: //' | sed 's/^ *//;s/ *$//')
#     if [[ $current_status == *"PREPARED"* ]]; then
#         toast "✅ Task preparation done!"
#         break
#     elif [[ $current_status == *"STARTING PREPARE"* ||
#         $current_status == *"'PREPARE VALIDATION'"* ]]; then
#         continue
#     elif [[ $current_status == *"PREPARING"* ||
#         $current_status == *''* ]]; then
#         continue
#     else
#         toast-error "🚫 Task preparation Failed!"
#         echo "Error: Unexpected status: '$current_status'"
#         echo "Errors:"
#         errors=$(echo "$output" | grep -A9999 'Errors:' | sed -n '/Errors:/,$p' | grep '^ *-')
#         echo "$errors"
#         return 1  # Stop execution with error
#     fi    # echo only the Status line from the output
#     echo -e "\r\033$current_status"
#     sleep 7
#   done
#
#   echo "$output"
#   echo "Deployment finished!"
# }
#
# function fdap() {
#     local name version tags
#     name=$1
#     version=${*: -1}
#     echo "$name"
#     echo "$version"
#     shift 1
#     tags=()
#
#     while [[ $# -gt 0 ]]; do
#         if [[ "$1" == "--tag" ]]; then
#             shift
#             tags+=("$1")
#         fi
#         shift
#     done
#
#     echo "$tags"
#
#     # Construct the fda command
#     local fda_command="fda prepare $name --version $version"
#     for tag in "${tags[@]}"; do
#         fda_command+=" --tag $tag"
#     done
#
#     echo $fda_command
#
#     # Execute the constructed fda command
#     {
#         local fda_output
#         fda_output=$(eval "$fda_command")
#     } || {
#         echo "FDA prepare failed!"
#         return 1
#     }
#     echo "$fda_output"
#
#     # Extract the Task Image ID using grep and cut
#     {
#         local task_image_id
#         task_image_id=$(echo "$fda_output" | grep "Task Image ID" | cut -d ':' -f 2- | tr -d '[:space:]')
#     } || {
#         echo "FDA prepare failed!"
#         return 1
#     }
#     # run the check_deployment_status command with the task image id
#     check_deployment_status $task_image_id
# }
#
#
