#
# Makefile
# Shewer Lu, 2020-07-21 07:01
#
RIME= /mnt/c/Program\ Files\ \(x86\)/Rime/weasel-0.14.3
DEPLOYER= WeaselDeployer.exe
.PONEY: all update deploy
all: update deploy 
	@echo "Makefile needs your attention"


# vim:ft=make
#
update:
	cp lua/format.lua  $(Rime)/lua
	cp lua/reverse_switch.lua $(Rime)/lua
	cp rime.lua $Rime


deploy:
	- rm $(WTMP)/rime* 
	$(RIME)/$(DEPLOYER) /deploy 




