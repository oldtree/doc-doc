docker run -it -d -p 9042:9042 -p 7199:7199 -p 7000:7000 -p 7001:7001 -p 9160:9160 --memory 1g --cpuset-cpus="0,1" scylladb/scylla:latest 