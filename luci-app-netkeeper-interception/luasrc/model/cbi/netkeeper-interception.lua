local sys = require "luci.sys"

m = Map("netkeeper-interception")
m.title	= "校园网登录"
m.description = "本地和远程两种方法进行登录"

m:section(SimpleSection).template = "netkeeper-interception/netkeeper-interception_authreq"

s = m:section(TypedSection, "netkeeper-interception")
s.title = "本地账号拦截"
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Local Interception"), translate("Login with Netkeeper Software on PC over lan"))
enable.optional = false
enable.rmempty = false

iface = s:option(ListValue, "iface", translate("Specifies the LAN Interface to listen"),
	translate("Specifies the Lan Interface that needs to be Listen by The PPPoE Server"))
for _, e in ipairs(sys.net.devices()) do
	if e ~= "lo" then iface:value(e) end
end
iface.optional = false
iface.rmempty = false

status = s:option(TextValue, "status", "运行状态", "本地账号拦截服务")
status.template = "netkeeper-interception/netkeeper-interception_status"

r = m:section(TypedSection, "netkeeper-interception")
r.title = "远程账号登录"
r.addremove = false
r.anonymous = true

enable_r = r:option(Flag, "enabled_r", translate("Remote Interception"), translate("Login over HTTP request"))
enable_r.optional = false
enable_r.rmempty = false

token = r:option(Value, "token", translate("HTTP token"), translate("HTTP request token"))
token.optional = false
token.rmempty = false

c = m:section(TypedSection, "netkeeper-interception")
c.title = "无线网络连接"
c.addremove = false
c.anonymous = true

ssid = c:option(Value, "ssid","SSID", "无线网络名称")
ssid.optional = false
ssid.rmempty = false

password = c:option(Value, "password", "密码", "无线网络密码")
password.optional = false
password.rmempty = false
password.password = true

apswitch = c:option(Button, "apswitch", "连接", "修改ssid和密码后请先保存")
apswitch.inputtitle = string.gsub(sys.exec("uci get wireless.client.disabled"), "\n", "") == "0" and "断开连接" or "开始连接"
function apswitch.write(self, section, value)
	if string.gsub(sys.exec("uci get network.wwan"), "\n", "") ~= "interface" then
		sys.call("uci set network.wwan=interface")
		sys.call("uci set network.wwan.proto='dhcp'")
		sys.call("uci commit network")
		sys.call("/etc/init.d/network reload")
	end
	if string.gsub(sys.exec("uci get wireless.client.disabled"), "\n", "") == "0" then
		sys.call("uci del wireless.client")
		sys.call("uci commit wireless")
		sys.call("wifi reload")
	else
		sys.call("uci set wireless.client=wifi-iface")
		sys.call("uci set wireless.client.disabled='0'")
		sys.call("uci set wireless.client.ssid='"..string.gsub(sys.exec("uci get netkeeper-interception.config.ssid"), "\n", "").."'")
		sys.call("uci set wireless.client.encryption='sae'")
		sys.call("uci set wireless.client.device='radio1'")
		sys.call("uci set wireless.client.mode='sta'")
		sys.call("uci set wireless.client.key='"..string.gsub(sys.exec("uci get netkeeper-interception.config.password"), "\n", "").."'")
		sys.call("uci set wireless.client.network='wwan'")
		sys.call("uci set wireless.client.encryption='psk2'")
		sys.call("uci commit wireless")
		sys.call("wifi reload")
	end
end

apstatus = c:option(TextValue, "apstatus", "连接状态", "无线网络连接状态")
apstatus.template = "netkeeper-interception/netkeeper-interception_apstatus"

o = m:section(TypedSection, "netkeeper-interception")
o.title = "openvpn设置"
o.addremove = false
o.anonymous = true

openvpn = o:option(Flag, "openvpn", "开关"), "OPENVPN客户端,用于远程登录")
openvpn.optional = false
openvpn.rmempty = false

ovpn = o:option(Value, "ovpn", "OVPN", "OPENVPN配置文件")
ovpn.optional = false
ovpn.rmempty = false

vpnstatus = o:option(TextValue, "vpnstatus", "连接状态", "OPENVPN连接状态")
vpnstatus.template = "netkeeper-interception/netkeeper-interception_vpnstatus"

return m