Redis Sentinels Ruby
====================

This is an example of how to setup a highly available redis using Docker.

All you need is [Docker](https://www.docker.com/) and
[Docker-Compose](https://docs.docker.com/compose/).

Clone the repository and startup everything

	docker-compose up -d

Now the fun can begin.

Let's take a look at the `redissentinel` container logs.

	docker-compose logs redissentinel

It should say something like this at the end

```
redissentinel_1 | [1] 02 Apr 11:34:12.018 # +monitor master mymaster 172.17.0.203 6379 quorum 1
redissentinel_1 | [1] 02 Apr 11:34:12.019 * +slave slave 172.17.0.205:6379 172.17.0.205 6379 @ mymaster 172.17.0.203 6379
```

The important parts are `+monitor master mymaster` and `+slave slave`. It means
the sentinel is watching the master and knows about the slave.

Now we know the redis cluster is running correctly. Let's take a look at our
"app". Make sure it is running and printing every 15 seconds. (in each loop it
writes to redis, that way we test that high availability is achieved later)

	docker-compose logs app

It should look something like this

```
app_1 | ------------
app_1 | ---LOOP 0---
app_1 | ------------
app_1 | ------------
app_1 | ---LOOP 1---
app_1 | ------------
app_1 | ------------
app_1 | ---LOOP 2---
app_1 | ------------
app_1 | ------------
app_1 | ---LOOP 3---
app_1 | ------------
...
```

To follow everything that's going to happen you might want to open 3 terminals.
One dislaying the `redissentinel` log. One displaying the `app` log and one to
kill the master redis server.

Stop the master with

	docker-compose stop redismaster

You should notice that redis-sentinel promotes the redis-slave to be the new
master and the "app" keeps printing as if nothing ever happened.

> Hint: redis sentinel remembers this by writing to it's config file. So make
> sure to `git checkout sentinel.conf` it to reset when you do multiple runs.

That's it, have fun!
