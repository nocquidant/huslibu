# README

Command to run this container :

```
docker run -d -p 1313:1313 \
  -v $(pwd):/site/content \
  -v $(pwd)/public:/site/public \
  nocquidant/hsb:latest
```	
