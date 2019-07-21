use Test::Nginx::Socket;
 
repeat_each(2);
plan tests => repeat_each() * 3 * blocks();
 
no_shuffle();
run_tests();
 
__DATA__
 
=== TEST 1: sanity
--- config
    location /cidr {
		access_by_lua_block {
		    local ipcidr = require("resty.ipcidr")
		    local whitelist_ips = {
		      "127.0.0.1",
		      "10.10.10.0/24",
		      "192.168.0.0/16",
		  }
		    if ipcidr.ip_in_cidrs('192.168.0.25', whitelist_ips) then
		        echo OK
		    end
		}
    }
--- request
    GET /cidr
--- response_body
OK
--- error_code: 200