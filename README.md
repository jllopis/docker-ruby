Dockerfile for container with Ruby installed

# Version

Ruby 2.1.4
Postgresql-client 9.3

This image is intended to be used as base image for Ruby based containers. It does not define a **CMD** or
and **ENTRYPOINT**.

You can still boot it like:

    $ docker run -t -i ruby:2.1.4 /bin/bash -l

It includes some development packages to be able to compile native gems.
