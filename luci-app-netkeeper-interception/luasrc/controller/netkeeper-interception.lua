module("luci.controller.netkeeper-interception", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/netkeeper-interception") then
		return
	end
	local page
	page = entry({"admin", "services", "netkeeper-interception"}, cbi("netkeeper-interception"), _("Netkeeper Interception"), 100)
	page.dependent = true
	entry({"admin","services","netkeeper-interception","status"},call("act_status")).leaf=true
	entry({"admin","services","netkeeper-interception","authreq"},call("act_authreq")).leaf=true
	entry({"admin","services","netkeeper-interception","apstatus"},call("act_apstatus")).leaf=true
	if string.gsub(luci.sys.exec("uci get netkeeper-interception.config.enabled_r"),"\n","") == "1" then
		entry({"remote" },call("act_remote")).leaf=true
	end
end

function act_status()
	local e={}
	if nixio.fs.access("/var/run/netkeeper-interception.pid") then
		e.running=luci.sys.call("pgrep pppoe-server|grep $(cat /var/run/netkeeper-interception.pid) -q")==0
	else
		e.running=0
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X ', string.byte(c))
    end))
end

function act_authreq()
	local e={}
	if nixio.fs.access("/var/Last_AuthReq") then
		local r=nixio.fs.readfile("/var/Last_AuthReq")
		e.success = true
		e.account = r
	else
		e.success = false
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function act_remote()
	local e={}
	if luci.http.formvalue("post") == string.gsub(luci.sys.exec("uci get netkeeper-interception.config.token"),"\n","") then
		local account = luci.http.formvalue("account")
		if account then
			local r = io.open("/var/Last_AuthReq", "w")
			r:write(account)
			r:close()
			e.result = true
			e.message = "success"
		else
			e.result = false
			e.message = "no account"
		end
	else
		e.result = false
		e.message = "token error"
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function act_apstatus()
	local e={}
	if string.gsub(luci.sys.exec("uci get wireless.client.disabled"), "\n", "") == "0" then
		e.enabled = true
		local ip = string.gsub(luci.sys.exec("ifconfig wlan1 | grep 'inet addr' | awk '{ print $2}' | awk -F: '{print $2}'"),"\n","")
		if ip == "" then
			e.message = "正在连接到无线网络..."
		else
			e.message = "已连接到: ".. string.gsub(luci.sys.exec("uci get wireless.client.ssid"), "\n", "") .." IP: " .. ip
		end
	else
		e.enabled = false
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

