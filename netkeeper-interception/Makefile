# Copyright (C) 2019 CCnut
#
# This is free software, licensed under the GNU General Public License v2.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=netkeeper-interception
PKG_RELEASE:=1
PKG_VERSION:=0.1

include $(INCLUDE_DIR)/package.mk


define Package/netkeeper-interception
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Netkeeper Account Dump Plugin
  DEPENDS:=ppp +openvpn-openssl +rp-pppoe-server
endef

define Package/netkeeper-interception/conffiles
/etc/netkeeper-interception/pppoe-server-options
/etc/config/netkeeper-interception
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/netkeeper-interception/install
	$(CP) ./files/* $(1)/
	$(shell) chmod +x $(1)/usr/bin/led
	$(shell) chmod +x $(1)/usr/bin/netcheck
	$(INSTALL_DIR) $(1)/usr/lib/pppd/2.4.7
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/builds/*.so $(1)/usr/lib/pppd/2.4.7/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./init/netkeeper-interception.init $(1)/etc/init.d/netkeeper-interception
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./init/openvpn-client.init $(1)/etc/init.d/openvpn-client
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./init/netcheck.init $(1)/etc/init.d/netcheck
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
