OPENRESTY_PREFIX=/usr/local/openresty

PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)
INSTALL ?= install

.PHONY: all test install

all: ;

install: all
	$(INSTALL) -d $(DESTDIR)$(LUA_LIB_DIR)/resty/checkups/
	$(INSTALL) lib/resty/*.lua $(DESTDIR)$(LUA_LIB_DIR)/resty/

test: all
	pwd
	sudo $(INSTALL) lib/resty/*.lua $(OPENRESTY_PREFIX)/lualib/resty/
	sudo chmod +x util/lua-releng
	util/lua-releng
	#tail -n 20 t/servroot/logs/error.log
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I lib -r t/