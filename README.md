# Docker PHP CLI

Docker image for PHP CLI with developing tools

* composer
* xdebug

Quick usage for PHP projects

```bash
docker run -it --rm -u $(id -u) -v $PWD:/app strider2038/php-cli-dev sh -l
```
