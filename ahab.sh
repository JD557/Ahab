#!/bin/bash

set -e

function start_docker_host {
	if hash docker-machine 2>/dev/null; then
		docker-machine start $DOCKER_MACHINE_NAME $*
	else
		boot2docker up $*
	fi
}

function stop_docker_host {
	if hash docker-machine 2>/dev/null; then
		docker-machine stop $DOCKER_MACHINE_NAME $*
	else
		boot2docker down $*
	fi
}

function trust_registry {
	local registry=$1
	shift
	if hash docker-machine 2>/dev/null; then
		docker-machine ssh $DOCKER_MACHINE_NAME $* "sudo sh -c 'echo \"EXTRA_ARGS=\\\"\\\$EXTRA_ARGS --insecure-registry $registry\\\"\" >> /var/lib/boot2docker/profile && /etc/init.d/docker restart'"
	else
		boot2docker ssh $* "sudo sh -c 'echo \"EXTRA_ARGS=\\\"--insecure-registry '$registry'\\\"\" > /var/lib/boot2docker/profile && /etc/init.d/docker restart'"
	fi
}

function log_follow {
	local ended_once=false
	local image=$1
	shift
	local args=$*
	while :
	do
		until containers=`docker ps | tail -n +2 | grep $image | grep -o "^[0-9a-f]\{12\}"`; do
			sleep 0.5
		done
		container=`echo $containers | head -n 1`
		if [ "$ended_once" = true ] ; then
			echo -e "==> New container [$container] found. Following logs now. <==\n"
		fi
		docker logs -f $args $container
		echo -e "\n==> Container [$container] terminated. Waiting for new. <=="
		ended_once=true
	done
}

case $1 in
	sail)
		echo -e "Naught’s an obstacle,\nnaught’s an angle to the iron way!\n"
		shift
		stop_docker_host $*
		start_docker_host $*
	;;
	trust)
		echo -e "Aye, aye!\n"
		shift
		trust_registry $*
	;;
	follow)
		echo -e "I'll chase him round Good Hope,\nand round the Horn,\nand round the Norway Maelstrom,\nand round perdition's flames before I give him up.\n"
		shift
		log_follow $*
	;;
	execute)
		echo -e "Imagine if you must,\na whale in a bust,\nname it you might\nas it is alive and white!\n"
		shift
		image=$1
		shift
		docker run -d $* $(docker images | tail -n +2 | grep $image | awk '{ print $1 }' | head -n 1)
	;;
	board)
		echo -e "A steak, a steak, ere I sleep!\nYou, Daggoo! overboard you go, and cut me one from his small!"
		shift
		image=$1
		shift
		docker exec -it $* $(docker ps | tail -n +2 | grep $image | awk '{ print $1 }' | head -n 1) bash
	;;
	kill)
		echo -e "Towards thee I roll, thou all-destroying but unconquering whale;\nto the last I grapple with thee;\nfrom hell's heart I stab at thee;\nfor hate's sake I spit my last breath at thee.\n"
		shift
		containers=`docker ps -a -q`
		docker stop $* $containers
		docker rm $* $containers
	;;
	dispose)
		echo -e "Sink all coffins and all hearses to one common pool!\n"
		shift
		docker rmi $* $(docker images -f "dangling=true" -q)
	;;
	*)
		echo -e "Usage: $0 COMMAND [arg...]\n\nA simple docker/boot2docker helper script, to help with tedious docker tasks.\n"
		echo -e "Commands:"
		echo -e "\tsail\tStart/Restart boot2docker/docker-machine (sail / sail <machine name>)"
		echo -e "\ttrust\tTrust an insecure registry (trust <registry> / trust <registry> <machine name>)"
		echo -e "\tfollow\tSearch for a container and prints its logs (follow <image name>)"
		echo -e "\texecute\tStart a container from an image name (execute <image name>)"
		echo -e "\tboard\tStart a shell inside a container (board <image name>)"
		echo -e "\tkill\tStop every running container and removes them"
		echo -e "\tdispose\tRemove unused docker images"
	;;
esac
