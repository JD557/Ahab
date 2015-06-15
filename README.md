Ahab
====

A simple docker/boot2docker helper script, to help with tedious docker tasks.
Named after [Captain Ahab](https://en.wikipedia.org/wiki/Captain_Ahab_(Moby-Dick)).

Commands
--------

* `sail`: Start/Restart boot2docker (`boot2docker down` followed by `boot2docker up`).
* `trust <registry>` Trust an insecure registry by adding a `EXTRA_ARGS="--insecure-registry <registry>"` line to the boot2docker profile in the boot2docker image.
* `follow <image_name>`: Search for container by image name and show its logs, like `docker logs -f <container>` (eg. `./ahab.sh follow elasticsearch`). It blocks until there is at least one container running that image.
* `execute <image_name> <other flags to be passed>`: Search for an image and launch a container (eg. `./ahab.sh execute elastic -p 9200:9200`).
* `kill`: Stop every running container (with `docker stop`) and remove them (with `docker rm`).
* `dispose`: Remove unused docker images (marked as `<none>`) with `docker rmi`.

If you want to pass extra flags to docker, simply add them at the end (eg. `./ahab.sh follow elasticsearch -t`).

TODO
----

* Improve help and give proper names to each command.
* Add proper citations to `trust` and `execute`
