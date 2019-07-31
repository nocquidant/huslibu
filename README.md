# README

A simple slides builder using [Hugo](https://gohugo.io/) with [reveal-hugo](https://github.com/dzello/reveal-hugo)

While in draft mode, use this command :

```
docker run -d -p 1313:1313 \
  -v $(pwd)/myprez:/site/content/myprez \
  nocquidant/huslibu:latest
```	

To build the static site, use this command (be sure the 'public' directory exists from your side) :

```
docker run \
  -v $(pwd):/site/content \
  -v $(pwd)/public:/site/public \
  nocquidant/huslibu:latest hugo
```	
