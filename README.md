# termvin
vaste your terminal outvut to the vorld vide veb

## setup
Configure  `url, slug length, max file size` at `termvin.v`.

```sh
docker-compose -f docker-compose.yml up -d --build
```

## example
```sh
cat source.py | nc localhost 9999
```
