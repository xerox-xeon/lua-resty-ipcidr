local bit = require "bit"
local lshift = bit.lshift
local bnot = bit.bnot
local band = bit.band

local _M = { _VERSION = "0.20" }


local function ip2long( ip )
	if ip == nil then return nil end
	local o1,o2,o3,o4 = ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
	local num = 2^24*o1 + 2^16*o2 + 2^8*o3 + o4
	return num
end

local function unsign(bin)
    if bin < 0 then
        return 4294967296 + bin
    end
    return bin
end

local function ip_CIDR_Check(ip, CIDR)
	local ip_ip = ip2long(ip)
	net, mask = string.match(CIDR, "(.*)%/(.*)")
	if net == nil then net = CIDR end
	local ip_net = ip2long(net)
	if mask then
		local mask_num   = tonumber(mask)
		if not mask_num or (mask_num > 32 or mask_num < 0) then
	        return nil, "Invalid prefix: /"..tonumber(mask)
	    end
	    local ip_mask = bnot(lshift(1, 32 - mask) - 1) 
	    local ip_ip_net = unsign(band(ip_ip, ip_mask))
	    return ip_ip_net == ip_net
	else
	    return ip_ip == ip_net
	end    
	
end

local function ip_in_cidrs( ip_addr, CIDRS )
	for _,cidr in ipairs(CIDRS) do
        if ip_CIDR_Check(ip_addr, cidr) then
            return true
        end
    end
    return false
end

_M.ip_in_cidrs = ip_in_cidrs
return _M