# lua-resty-ipcidr

CIDR functions for working with IP addresses.

# Overview

```
access_by_lua_block {
    local ipcidr = require("resty.ipcidr")
    local whitelist_ips = {
      "127.0.0.1",
      "10.10.10.0/24",
      "192.168.0.0/16",
  }
    if not ipcidr.ip_in_cidrs(ngx.var.remote_addr, whitelist_ips) then
      return ngx.exit(ngx.HTTP_FORBIDDEN)
    end
}
```

# Methods
### ip_in_cidrs
`syntax: bool, err = ipcidr.ip_in_cidrs(ip, cidrs)`

Takes a string IPv4 address and a table of parsed CIDRs.

Returns a `true` or `false` if the IP exists within *any* of the specified networks.

Returns `nil` and an error message with an invalid IP