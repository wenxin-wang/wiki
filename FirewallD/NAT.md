---
title: FirewallD NAT配置
---

```bash
EINF=公网网口
IINF=内网网口

EINF=macvlan-ext
IINF=br-nat
```

# 基础配置


首先，开启[路由模式](../路由模式.md)。

一般做法：公网口不接入`public` zone，而是`external` zone，后者专门用来做NAT；内网口放在`interval` zone：

```bash
# 先让 external zone 允许 ssh ，再添加端口上去！其实默认已经加了
sudo firewall-cmd --zone=external --add-service=ssh --permanent

sudo firewall-cmd --zone=external --add-interface=$EINF --permanent
sudo firewall-cmd --zone=internal --add-interface=$IINF --permanent
sudo firewall-cmd --zone=public --add-port=5201/tcp --permanent
sudo firewall-cmd --reload
```

# MASQUERADE

把内网源地址全部变为本机公网IP


## IPv4

```bash
sudo firewall-cmd --zone=external --add-masquerade --permanent
sudo firewall-cmd --reload
```

## IPv6

```bash
sudo firewall-cmd --zone=external --add-rich-rule='rule family=ipv6 masquerade' --permanent
sudo firewall-cmd --reload
```

# 端口转发

以下使得 *非本机* 的访问得以转发

```bash
EPORT=外部端口
IPORT=内部端口
IIP4=内部IPv4
IIP6=内部IPv6
PROTO=协议
```

```bash
sudo firewall-cmd --permanent --zone=external --add-forward-port=port=$EPORT:proto=$PROTO:toport=$IPORT:toaddr=$IIP4
sudo firewall-cmd --zone=external --add-rich-rule="rule family=ipv6 forward-port port=$EPORT protocol=$PROTO to-port=$IPORT to-addr=$IIP6" --permanent

sudo firewall-cmd --reload
sudo firewall-cmd --zone=external --list-all
```
