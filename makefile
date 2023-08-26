.PHONY: help
help: makefile
	@tail -n +4 makefile | grep ".PHONY"


.PHONY: test
test:
	npx elm-test


.PHONY: build
build: test docs.json index.html


docs.json: src elm.json node_modules
	npx elm make --docs=$@


index.html: src elm.json node_modules
	npx elm make src/Website.elm


node_modules: package.json package-lock.json
	if test ! -d $@; \
	then npm install; \
	fi
