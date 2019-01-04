## tools tips

```shell
ab -k -c 8 -n 100000 "http://127.0.0.1:8080/v1/leftpad/?str=test&len=50&chr=*"
# -k   Enables HTTP keep-alive
# -c   Number of concurrent requests
# -n   Number of total requests to make
```