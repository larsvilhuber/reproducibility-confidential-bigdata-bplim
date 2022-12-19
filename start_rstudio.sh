#!/bin/bash
PWD=$(pwd)
repo=compensation-benchmark
space=larsvilhuber
dockerrepo=$space/$repo
case $USER in
  vilhuber)
  #WORKSPACE=$HOME/Workspace/git/
  WORKSPACE=$PWD
  ;;
  codespace)
  WORKSPACE=/workspaces
  ;;
esac
  
# build the docker if necessary

docker pull $dockerrepo
BUILD=yes
arg1=$1

if [[ $? == 1 ]]
then
  ## maybe it's local only
  docker image inspect $dockerrepo> /dev/null
  [[ $? == 0 ]] && BUILD=no
fi
# override
BUILD=no
[[ "$arg1" == "force" ]] && BUILD=yes

if [[ "$BUILD" == "yes" ]]; then
docker build . -t $dockerrepo
nohup docker push $dockerrepo&
fi

docker run -e DISABLE_AUTH=true -v $WORKSPACE:/home/rstudio --rm -p 8787:8787 $dockerrepo
