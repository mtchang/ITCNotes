
#!/bin/bash
GITCMD="/usr/bin/git"
WORKPWD="/usr/share/nginx/html/jutainetflow/requ/"
GITPWD="/usr/share/nginx/html/jutainetflow/requ/.git/"
echo "$(date) Run user is $(whoami)"
echo "cd ${PWD}"
cd ${PWD}
${GITCMD} --git-dir=${GITPWD} --work-tree=${WORKPWD} status
${GITCMD} --git-dir=${GITPWD} --work-tree=${WORKPWD} fetch origin master
${GITCMD} --git-dir=${GITPWD} --work-tree=${WORKPWD} merge FETCH_HEAD
${GITCMD} --git-dir=${GITPWD} --work-tree=${WORKPWD} log -n 1
${GITCMD} --git-dir=${GITPWD} --work-tree=${WORKPWD} status

echo 'done'
