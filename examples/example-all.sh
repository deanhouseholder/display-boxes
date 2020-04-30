#!/bin/bash

source display-boxes.sh

headers='Git Alias	Runs	Description'

body='g	git	Quick shortcut to git command
gh	git help	Display Git help
g.	git add . && git status	Stage all changes and do a git status
ga	git add	Stage files for commit
gac	git add . && git commit && git push	Stage all files, commit (prompt for message) and push
gb	git branch	List all branches
gc	git commit	Commit staged files
gca	git commit -a --amend -C HEAD	Commit the latest changes as an ammendment to the last commit
gd	git diff	Show changes since last commit
gf	git fetch	Fetch new changes from remote repo
gl	git log	Show log of commits
gp	git pull	Pull latest changes from remote repo
gps	git push	Push commit(s) to remote repo
gs	git status	Git Status
branch	git checkout -b	Create a new branch or checkout existing branch
stash	git stash	Stash current changes
restore	git stash pop	Restore latest stashed changes
wip	git commit -am "WIP"	Make a "Work in Progress" commit'

for i in $(seq 6); do
  printf "\n=== Style $i ===\n\n"
  display-box "$headers" "$body" $i
done
echo
