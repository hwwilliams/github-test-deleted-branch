next_sprint_branch_name='${{ steps.get_next_sprint_branch.outputs.SPRINT_BRANCH_NAME }}'

if [[ $(git fetch origin && git branch -r) =~ $next_sprint_branch_name ]]; then
  echo "Checking out existing sprint branch '$next_sprint_branch_name'"
  git checkout $next_sprint_branch_name

  if ! git merge-base --is-ancestor origin/main $next_sprint_branch_name; then
    echo "Existing sprint branch '$next_sprint_branch_name' is not up to date with origin/main"

    echo "Attempting to merge origin/main into existing sprint branch '$next_sprint_branch_name'"
    git merge origin/main --strategy-option theirs

    echo "Pushing sprint branch '$next_sprint_branch_name' to origin"
    git push origin $next_sprint_branch_name
  fi
else
  echo "Creating new sprint branch '$next_sprint_branch_name' based on origin/main"
  git checkout -b $next_sprint_branch_name origin/main

  echo "Pushing sprint branch '$next_sprint_branch_name' to origin"
  git push origin $next_sprint_branch_name
fi
