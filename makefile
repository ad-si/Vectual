.PHONY: help
help: makefile
	@tail -n +4 makefile | grep ".PHONY"


.PHONY: format
format:
	elm-format --yes src/ tests/


.PHONY: test
test:
	elm-test-rs


.PHONY: build
build: test docs.json public/index.html


.PHONY: dev
dev:
	@echo -e "Go to http://localhost:8000/src/Website.elm to see the app\n\n"
	elm reactor


docs.json: src elm.json node_modules
	elm make --docs=$@


public/index.html: src elm.json node_modules
	elm make src/Website.elm --output=$@


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
