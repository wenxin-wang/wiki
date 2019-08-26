---
title: netns使用
---

```bash
NETNS=ns0
```

# 创建netns

```bash
sudo ip netns add $NETNS
```

# 将某个interface（物理/虚拟）放入netns中

```bash
INF=veth0
```

```bash
sudo ip l set $INF netns $NETNS
```

# 在某个netns里运行进程

```bash
sudo ip netns exec $NETNS bash
```

# 创建虚拟以太网口对

```bash
sudo ip l add p0 type veth peer name p1
```

`p0`和`p1`之间是用神奇的看不见的网线连着的，是一根网线的两个端点。用它们可以把两
个netns连在一起。

```bash
sudo ip link set p0 netns ns0
sudo ip link set p1 netns ns1
```
iptables -t nat -A POSTROUTING -j SNAT --to-source (my vps ip address)
