## multi raft

单个raft-group，例如etcd,所有的操作都只能在一个默认的group下面，所有的读写操作都在一个leader节点上，容易产生性能问题

multi raft多个group可以避免这个问题

最近一个dragonBoat的项目非常火，单独实现的multi-raft算法，已经可以用于生产来使用了