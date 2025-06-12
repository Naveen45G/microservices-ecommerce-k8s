#!/bin/bash

# Move to the root of the Git repository
cd "$(git rev-parse --show-toplevel)" || exit 1

# Path to the Jenkinsfiles directory
JENKINS_DIR="jenkinsfiles"

# Loop through each file in the jenkinsfiles folder
for file in "$JENKINS_DIR"/*; do
  branch_name=$(basename "$file")  # e.g., "shippingservice"

  echo "Creating clean branch: $branch_name"

  # Copy the original Jenkinsfile to temp, renaming it to Jenkinsfile
  tmpfile="/tmp/Jenkinsfile"
  cp "$file" "$tmpfile"

  # Create orphan branch (no history)
  git checkout --orphan "$branch_name"

  # Remove all tracked files from Git index
  git rm -rf . > /dev/null 2>&1

  # Remove all untracked files/directories except .git
  find . -mindepth 1 -maxdepth 1 ! -name ".git" -exec rm -rf {} +

  # Move the Jenkinsfile back from /tmp
  mv "$tmpfile" Jenkinsfile

  # Add and commit only the renamed Jenkinsfile
  git add Jenkinsfile
  git commit -m "Initial commit for $branch_name Jenkinsfile"

  # (Optional) Push the branch to remote
  git push origin "$branch_name"

  # Switch back to main branch
  git checkout main
done

echo "✅ All branches created with Jenkinsfile successfully."

