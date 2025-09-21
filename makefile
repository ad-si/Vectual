.PHONY: help
help: makefile
	@tail -n +4 makefile | grep ".PHONY"


.PHONY: format
format:
	npx elm-format --yes src/ tests/


.PHONY: test
test:
	npx elm-test


.PHONY: build
build: test docs.json public/index.html


.PHONY: dev
dev:
	@echo -e "Go to http://localhost:8000/src/Website.elm to see the app\n\n"
	npx elm reactor


docs.json: src elm.json node_modules
	npx elm make --docs=$@


public/index.html: src elm.json node_modules
	npx elm make src/Website.elm --output=$@


node_modules: package.json package-lock.json
	if test ! -d $@; \
	then npm install; \
	fi


.PHONY: deploy
deploy: build
	@echo "1. Open https://app.netlify.com/sites/vectual/deploys"
	@echo "2. Drag & drop the ./public directory"


.PHONY: clean
clean:
	rm -f docs.json
	rm -rf elm-stuff
	rm -rf node_modules
	rm -rf public
