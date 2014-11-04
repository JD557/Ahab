#!/bin/bash
noColor='\033[0m'
red='\033[0;31m'

case $1 in
	sail)
		echo -e "Aye, aye!\n"
        shift
		boot2docker down $*
		boot2docker up $*
	;;
    follow)
        echo -e "I'll chase him round Good Hope,\nand round the Horn,\nand round the Norway Maelstrom,\nand round perdition's flames before I give him up.\n"
        shift
        until containers=`docker ps | grep $1 | grep --o "[0-9a-f]\{12\}"`; do
            :
        done
        container=`echo $containers | head -n 1`
        shift
        docker logs -f $container $*
    ;;
    kill)
		echo -e "Towards thee I roll, thou all-destroying but unconquering whale;\nto the last I grapple with thee;\nfrom hell's heart I stab at thee;\nfor hate's sake I spit my last breath at thee.\n"
		shift
        docker stop $* $(docker ps -a -q)
        docker rm $* $(docker ps -a -q)
	;;
	dispose)
		echo -e "Sink all coffins and all hearses to one common pool!!\n"
		shift
		docker images | grep "<none>" | grep --o "[0-9a-f]\{12\}" | xargs docker rmi $*
	;;
	*) echo -e "I ${red}sail${noColor} the seven seas,\nTo ${red}follow${noColor} my catch,\nI ${red}kill${noColor} the mighty whales,\nAnd ${red}dispose${noColor} of them in batch"
esac
