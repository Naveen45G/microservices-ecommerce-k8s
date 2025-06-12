#Delete All Local Branches Except main
for branch in $(git branch | grep -v "main"); do
    git branch -D "$branch"
done

#Delete All Remote Branches Except main
for branch in $(git branch -r | grep origin | grep -v "main" | awk -F'/' '{print $2}'); do
    git push origin --delete "$branch"
done
