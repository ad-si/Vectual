# Contributing

In order to check if your changes did not break anything and is suitable for a
pull request simply run `$ npm run-script prepublish`.
The script consists of following steps:


## Testing

To run tests on server side simply execute `$ npm test`. This executes all tests in the mockup DOM environment [jsdom](https://github.com/tmpvar/jsdom) and in the nodejs environment.
To run the tests in a client side environment simply open [./test/index.html](./test/index.html) in a browser.


## Building

In order to build the final production-ready files from the source files run `$ jake -B`.


## Package

All package information is contained in `package.yaml` and will get synchronized to `package.json` and `bower.json` during the build process.
So make sure to only alter the `package.yaml` file directly.


## Style Guidelines

Checkout `package.yaml` for the JSHint and Jscs configurations.
