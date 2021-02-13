build/index.html: index.html | build
	mv $< $@


index.html: src elm.json
	elm-test
	elm make --docs=docs.json
	elm make src/Website.elm
	mv ./index.html $@


build:
	mkdir build
