# julia_zeppelin
Docker Container for Apache Zeppelin with Julia included.

## Build Image

    docker-compose build

## Start Container

    docker-compose up -d

The Apache Zeppilin application is available here:

http://localhost:8080/

## Use Julia

1. Create new Note
2. Select Default Interpreter = `jupyter`
3. Add on top of each paragraph which should be executed with Julia:
`%jupyter(kernel=julia-1.4)`

Note that a new paragraph does not have the kernel information included as default, thus the last step has to be repeated for each paragraph.

More information is given here:

http://zeppelin.apache.org/docs/0.9.0-preview1/interpreter/jupyter.html

An example notebook is given in this repository.

## Disclaimer

This is a very crude setup to include Julia in Apache Zeppelin. Features like syntax highlighting are missing.

In principle, it should be possible to have a better integration, see here:

https://zeppelin.apache.org/docs/0.6.2/development/writingzeppelininterpreter.html

## Links

https://zeppelin.apache.org/

https://hub.docker.com/r/apache/zeppelin/

https://hub.docker.com/r/jupyter/datascience-notebook
