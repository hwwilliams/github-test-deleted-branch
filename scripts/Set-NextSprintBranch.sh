if [[ $(git fetch origin && git branch -r) =~ $NEXT_SPRINT_BRANCH_NAME ]]; then
  echo "Checking out existing sprint branch '$NEXT_SPRINT_BRANCH_NAME'"
  git checkout $NEXT_SPRINT_BRANCH_NAME

  if ! git merge-base --is-ancestor origin/main $NEXT_SPRINT_BRANCH_NAME; then
    echo "Existing sprint branch '$NEXT_SPRINT_BRANCH_NAME' is not up to date with origin/main"

    echo "Attempting to merge origin/main into existing sprint branch '$NEXT_SPRINT_BRANCH_NAME'"
    git merge origin/main --strategy-option theirs

    echo "Pushing sprint branch '$NEXT_SPRINT_BRANCH_NAME' to origin"
    git push origin $NEXT_SPRINT_BRANCH_NAME
  fi
else
  echo "Creating new sprint branch '$NEXT_SPRINT_BRANCH_NAME' based on origin/main"
  git checkout -b $NEXT_SPRINT_BRANCH_NAME origin/main

  echo "Pushing sprint branch '$NEXT_SPRINT_BRANCH_NAME' to origin"
  git push origin $NEXT_SPRINT_BRANCH_NAME
fi
