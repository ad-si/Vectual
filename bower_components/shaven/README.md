# Shaven

[![Build Status](https://travis-ci.org/adius/shaven.svg)](https://travis-ci.org/adius/shaven)

A **DOM building utility** and **Template engine** build upon **JsonML** with syntax sugar.

Checkout [adriansieber.com/shaven](http://adriansieber.com/shaven) for an extensive documentation.


```javascript
	shaven(
		[document.body,
			['h1#logo', 'Static Example', {style:'color:blue'}],
			['p','some example text'],
			['ul#list.bullets',
				['li', 'item1'],
                ['li.active', 'item2'],
                ['li',
                    ['a', 'item3', {href: '#'}]
                ]
			]
		]
	)
```

compiles to

```html
	<body>
		<h1 id="logo" style="color:blue">Static Example</h1>
		<p>some example text</p>
		<ul id="list" class="bullets">
			<li>item1</li>
			<li class="active">item2</li>
			<li><a href="#">item3</a></li>
		</ul>
	</body>
```


## Features

- Syntax Sugar for ids, classes and variable caching
- Support for namespaces. (Lets you build SVGs and other XML based languages)
- Callback functions on elements
- Returns a Object containing the root element and the elements with an id


## Advantages

- Leverage the full power of Javascript in your templates.
	=> No need to learn a new language!
- Directly integratable into Javascript files
- Works in front- and backend environment
- Templates normally tend to get more complicated with the number of variables
	as they need to get escaped in some way.
	With Shaven it's exactly the opposite. As variables are native to Shaven
	the templates get simpler with a increasing number of variables.
- Shaven templates can be easily build with every major programming language
	and their existing JSON/YAML tools.


## Installation

Check out [adriansieber.com/shaven](http://adriansieber.com/shaven) for a detailed description of how to install shaven.
