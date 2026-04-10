import subprocess
import shutil
import os
import argparse

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Build and copy Flutter web project.")
parser.add_argument("-m", "--message", required=True, help="message in github commit for flutter build.")
parser.add_argument("-p", "--path", required=True, help="Destination path to copy the build files.")
args = parser.parse_args()

destination_dir = args.path
commit_message = args.message

# Define paths
flutter_project_root = os.getcwd()  # Assumes script is run from Flutter root
target_main = "lib/ZZZZ_main/mainFile/main.dart"
build_command = f"flutter build web --target={target_main}"

source_build_dir = os.path.join(flutter_project_root, "build", "web")

# Run Flutter build command
print("Building Flutter web app...")
result = subprocess.run(build_command, shell=True, capture_output=True, text=True)
if result.returncode != 0:
    print("Error during build:", result.stderr)
    exit(1)

print("Flutter web build completed successfully.")

# Ensure destination directory exists
if not os.path.exists(destination_dir):
    os.makedirs(destination_dir)

# Copy build files (replace existing files without deleting anything)
print("Copying build files...")
if os.path.exists(source_build_dir):
    for src_dir, _, files in os.walk(source_build_dir):
        dest_dir = src_dir.replace(source_build_dir, destination_dir, 1)
        if not os.path.exists(dest_dir):
            os.makedirs(dest_dir)
        for file in files:
            src_file = os.path.join(src_dir, file)
            dest_file = os.path.join(dest_dir, file)
            shutil.copy2(src_file, dest_file)  # Preserve metadata
    print("Files copied successfully to:", destination_dir)
else:
    print("Error: Source build directory not found!", source_build_dir)
    exit(1)

# Git operations
print("Committing changes to Git...")
try:
    subprocess.run(["git", "add", "."], cwd=destination_dir, check=True)
    subprocess.run(["git", "commit", "-m", commit_message], cwd=destination_dir, check=True)
    subprocess.run(["git", "push", "origin", "main"], cwd=destination_dir, check=True)
    print("Changes pushed to Git repository.")
except subprocess.CalledProcessError as e:
    print("Error during Git operations:", e)
