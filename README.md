# README

A simple slides builder using [Hugo](https://gohugo.io/) with [reveal-hugo](https://github.com/dzello/reveal-hugo)

While in writing mode, use this command :

```
docker run -d -p 1313:1313 \
  -v $(pwd)/myfolder:/site/content/myfolder \
  nocquidant/huslibu:latest serve --bind=0.0.0.0 -D
```	

While in building mode, use this command (be sure public dir exists) :

```
docker run \
  -v $(pwd):/site/content \
  -v $(pwd)/public:/site/public \
  nocquidant/huslibu:latest
```	
