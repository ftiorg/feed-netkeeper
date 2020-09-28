# 改了些了啥
基于 [feed-netkeeper(7354190a43)](https://github.com/CCnut/feed-netkeeper/tree/7354190a4304ab161ee9ab65249a50850db366d6)修改
- 路由器连接到 wifi
- openvpn 客户端
- 远程拨号 
- 网络状态 LED (斐讯k2) 

给小伙伴用的，仅测试山理Netkeeper，其他地区不能用。

# feed-netkeeper
本软件源包含四个软件

仅适用于Openwrt 19.07
Openwrt 18.06请使用18.06的[分支](https://github.com/CCnut/feed-netkeeper/tree/openwrt-18.06)

```
netkeeper（闪讯插件）
luci-proto-netkeeper（闪讯拨号界面）
netkeeper-interception（闪讯拦截服务）
luci-app-netkeeper-interception（闪讯拦截服务界面）
```

选择```luci-app-netkeeper-interception```即可全部编译

请自行编译安装后使用

# 使用方法

## 普通插件

在 _网络 -> 接口 -> 编辑WAN -> 选择闪讯拨号 -> 确认切换_ 后

然后输入 _用户名_ 和 _密码_ 选择对应的 _闪讯插件_ 保存应用即可拨号

## 拦截插件

在 _网络 -> 接口 -> 编辑WAN -> 选择闪讯拨号 -> 确认切换_ 后

选择 _闪讯拦截_ 插件并开启闪讯拦截服务后，在PC端使用闪讯客户端拨号，会自动获取用户名与密码并拨号

**可以不用填写 _用户名_ 和 _密码_**

### 特别鸣谢
netkeeper的核心源码来自于miao1007的[Openwrt-NetKeeper](https://github.com/miao1007/Openwrt-NetKeeper)
