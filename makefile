VERSION=0.2
PKG=batmesh-$(VERSION)
SRCTAR=$(PKG).tar.gz

$(SRCTAR):
	git archive --format=tar.gz --prefix=$(PKG)/ -o $(SRCTAR) $(VERSION)

gittar: $(SRCTAR)
