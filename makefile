build/index.html: src
	elm-test
	elm make --docs=docs.json
	elm make src/Website.elm
