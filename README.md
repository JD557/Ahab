Ahab
====

A simple docker/boot2docker helper script, to help with tedious docker tasks.
Named after [Captain Ahab](https://en.wikipedia.org/wiki/Captain_Ahab_(Moby-Dick)).

Commands
--------

* `sail`: restart boot2docker (`boot2docker down` followed by `boot2docker up`)
* `follow <image_name>`: search an elastic search container by name and show it's logs in a ala `docker logs -f <container>` (eg. ``)
* `kill`: stops every running docker (with `docker stop`) instance and removes them with `docker rm`
* `dispose`: removes unused docker images (marked as `<none>`) with `docker rmi`

If you want to pass extra flags to docker, simply add them at the end (eg. `./ahab.sh follow elasticsearch -t`)

TODO
----

* Improve help and give proper names to each command.
