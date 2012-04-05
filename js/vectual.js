(function (window, document, undefined) {
    var svg, // SVG DOMfragment
        c, // Configuration
        xhtmlNS = "http://www.w3.org/1999/xhtml",
        svgNS = "http://www.w3.org/2000/svg",
        xlinkNS = "http://www.w3.org/1999/xlink";

    function toRad(degrees) {
        return degrees * (Math.PI / 180);
    }

    function v(config) {

        var defs,
            size,
            text;

        // extend configuration file
        c = config;

        // Set defaults
        c.id = config.id || false;
        c.title = config.title || "vectual.js";
        c.inline = config.inline || false;
        c.animations = (config.animations) ? true : false;
        c.height = config.height || 300;
        c.width = config.width || 500;
        c.colors = config.colors || ['yellow', 'green', 'blue', 'brown', 'grey', 'yellow', 'green', 'blue', 'brown', 'yellow', 'green', 'blue', 'brown'];

        // Calculate
        c.tuples = [];
        c.keys = [];
        c.values = [];
        c.sorted = {
            'key':[],
            'val':[]
        };
        c.size = 0;
        c.totalValue = 0;
        c.max = {"key":"", "val":0};
        c.min = {"key":"", "val":0};
        c.range = {};

        for (var i in c.data) {

            if (c.data.hasOwnProperty(i)) {

                //get maxium and minimum value and corresponding key
                if (c.data[i] > c.max.val) {
                    c.max.key = i;
                    c.max.val = c.data[i];
                }
                if (c.data[i] < c.min.val) {
                    c.min.key = i;
                    c.min.val = c.data[i];
                }

                c.totalValue += Number(c.data[i]); //get sum of all Values

                c.size++; //get length of object

                c.keys.push(i);
                c.values.push(c.data[i]);
                c.tuples.push([i, c.data[i]]); //get sortable array
            }
        }

        //sort array
        c.tuples.sort(function (a, b) {
            return a[1] < b[1] ? 1 : a[1] > b[1] ? -1 : 0
        });

        //split into key/value arrays
        for (var a = 0; a < c.tuples.length; a++) {
            c.sorted.key.push(c.tuples[a][0]);
            c.sorted.val.push(c.tuples[a][1]);
        }

        svg = DOMinate(
            ['svg', {
                'version':"1.1",
                'class':(c.inline) ? 'vectual_inline' : 'vectual',
                'width':c.width,
                'height':c.height,
                'viewBox':"0 0 " + c.width + " " + c.height},
                ['defs',
                    ['linearGradient#rect_background', {
                        x1:'0%',
                        y1:'0%',
                        x2:'0%',
                        y2:'100%'},
                        ['stop', {
                            offset:'0%',
                            style:'stop-color:rgb(80,80,80); stop-opacity:1'}
                        ],
                        ['stop', {
                            offset:'0%',
                            style:'stop-color:rgb(40,40,40); stop-opacity:1'}
                        ]
                    ],
                    ['filter#dropshadow',
                        ['feGaussianBlur', {
                            'in':'SourceAlpha',
                            stdDeviation:0.5,
                            result:'blur'}
                        ],
                        ['feOffset', {
                            'in':'blur',
                            dx:'2',
                            dy:'2',
                            result:'offsetBlur'}
                        ],
                        ['feComposite', {
                            'in':'SourceGraphic',
                            'in2':'offsetBlur',
                            result:'origin'}
                        ]
                    ]
                ],
                ['rect', {
                    'class':'vectual_background',
                    'x':0,
                    'y':0,
                    'width':c.width,
                    'height':c.height,
                    'rx':c.inline ? '' : 10,
                    'ry':c.inline ? '' : 10}
                ],
                ['text', c.title, {
                    'class':'vectual_title',
                    'x':20,
                    'y':(10 + c.height * 0.05),
                    'style':'font-size:' + (c.height * 0.05) + 'px'
                }]
            ]
            , svgNS);


        DOMinate([document.getElementById(c.id) , [svg]]);

        return {
            pieChart:function () {
                return new Pie();
            },
            lineChart:function () {
                return new Line();
            },
            barChart:function () {
                return new Bar();
            },
            tagCloud:function () {
                return new Tagcloud();
            }
        };
    }


    function Pie() {
        var pie,
            circle,
            text,
            radius = Math.min(c.height, c.width * 0.2),
            lastx = -radius,
            lasty = 0,
            angle_all = 0;

        pie = DOMinate(
            ['g', { 'transform':'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')'}]
            , svgNS);

        DOMinate([svg, [pie]]);


        if (c.totalValue == c.max.val) { //only one value

            DOMinate(
                [pie,
                    ['circle', {
                        'class':'vectual_pie_sector',
                        'cx':'0',
                        'cy':'0',
                        'r':radius,
                        'fill':c.colors[1]
                    }],
                    ['text', c.max.key, {
                        'class':'vectual_pie_text_single, vectual_pie_text',
                        'x':'0',
                        'y':'0',
                        'style':'font-size:' + (radius * 0.3) + 'px',
                        'text-anchor':'middle',
                        'stroke-width':(radius * 0.006)
                    }]
                ]
                , svgNS);

        } else {
            for (var i = 0; i < c.size; i++) {
                drawSector(i); //Pie sector
            }
        }

        function drawSector(i) {
            var position, angle_all_rad, angle_all_last, angle_this, angle_translate, angle_add,
                trans_deg, tx, ty, sector, size, path, ani, text, animate, title, nextx, nexty;

            if (((c.sorted.val[i] / c.totalValue) * 360) > 180) size = '0 1,0';
            else size = '0 0,0';

            //Angle
            angle_all_last = angle_all;
            angle_this = ((c.sorted.val[i] / c.totalValue) * 360);
            angle_all = angle_this + angle_all;
            angle_all_rad = toRad(angle_all);

            //Shift direction of sector: add previous angle to half of the current
            angle_add = angle_this / 2;
            trans_deg = angle_all_last + angle_add;
            angle_translate = toRad(trans_deg);

            tx = -(Math.cos(angle_translate)) * radius;
            ty = (Math.sin(angle_translate)) * radius;

            nextx = -(Math.cos(angle_all_rad) * radius);
            nexty = (Math.sin(angle_all_rad) * radius);

            position = (trans_deg <= 75) ? 'end' : (trans_deg <= 105) ? 'middle' :
                (trans_deg <= 255) ? 'start' : (trans_deg <= 285) ? 'middle' : 'end';


            sector = DOMinate(
                [pie,
                    ['g', {'class':"vectual_pie_sector"}]
                ]
                , svgNS);

            /* Not working

             if (c.animations) {

             DOMinate(
             [sector,
             ['animateTransform', {
             attributeName:'transform',
             begin:'mouseover',
             type:'translate',
             to:(tx * 0.2) + ', ' + (ty * 0.2),
             dur:'1s',
             additive:'replace',
             fill:'freeze'}
             ],
             ['animateTransform', {
             attributeName:'transform',
             begin:'mouseout',
             type:'translate',
             to:'0,0',
             dur:'1s',
             additive:'replace',
             fill:'freeze'}
             ]
             ]
             , svgNS);
             }
             */

            path = DOMinate(
                ['path', {
                    'class':'vectual_pie_sector_path',
                    'style':'stroke-width:' + (radius * 0.015) + ';fill:' + c.colors[i],
                    'd':'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z'}
                ]
                , svgNS);

            DOMinate([sector, [path]]);


            if (c.animations) {

                DOMinate(
                    [path,
                        ['animate', {
                            'attributeName':'opacity',
                            'from':'0',
                            'to':'1',
                            'dur':'0.6s',
                            'fill':'freeze'}
                        ],
                        ['animateTransform', {
                            'attributeName':'transform',
                            'type':'rotate',
                            'dur':'1s',
                            'calcMode':'spline',
                            'keySplines':'0 0 0 1',
                            'values':angle_all_last + ',0,0; 0,0,0',
                            'additive':'replace',
                            'fill':'freeze'}
                        ]
                    ]
                    , svgNS);
            }

            text = DOMinate(
                ['text', {
                    'class':'vectual_pie_text',
                    'x':(tx * 1.2),
                    'y':(ty * 1.2),
                    'text-anchor':position,
                    'style':'font-size:' + (angle_this * radius * 0.002 + 8) + 'px',
                    'fill':c.colors[i],
                    'transform':'translate(0, 5)'}
                ]
                , svgNS);

            DOMinate([sector, [text]]);


            if (c.animations) {

                DOMinate(
                    [text,
                        ['animate', {
                            'attributeName':'opacity',
                            'begin':'0s',
                            'values':'0;0;1',
                            'dur':'1s',
                            'fill':'freeze'}
                        ]
                    ]
                    , svgNS);
            }

            DOMinate(
                [sector,
                    ['title',
                        c.sorted.key[i] + ' | ' +
                            c.sorted.val[i] + ' | ' +
                            (Math.round(c.sorted.val[i] / c.totalValue * 100) ) + '%'
                    ]
                ]
                , svgNS);

            lastx = nextx;
            lasty = nexty;
        }
    }

    function Bar() {

        var bars,
            yDensity = 0.1,
            yRange = (c.max.val - c.min.val),
            a,
            g,
            line,
            text,
            graphHeight = c.height * 0.8,
            graphWidth = c.width * 0.95,
            coSysHeight = c.height * 0.6,
            coSysWidth = c.width * 0.85;


        bars = DOMinate(
            ['g', {
                transform:'translate(' + (graphWidth * 0.1) + ', ' + graphHeight + ')'}
            ]
            , svgNS);

        DOMinate([svg, [bars]]);

        horizontalLoop();
        verticalLoop();

        for (var i = 0; i < c.size; i++) {
            buildBar(i);
        }


        function buildBar(i) {

            var bar = DOMinate(
                ['rect', {
                    'class':'vectual_bar_bar',
                    'x':(i * (coSysWidth / c.size)),
                    'y':-(c.values[i] - c.min.val) * (coSysHeight / yRange),
                    'height':(c.values[i] - c.min.val) * (coSysHeight / yRange),
                    'width':(0.7 * (coSysWidth / c.size)) },
                    ['title', c.keys[i] + ':  ' + c.values[i]]
                ]
                , svgNS);

            bars.appendChild(bar);


            if (c.animations) {

                DOMinate(
                    [bar,
                        ['animate', {
                            'attributeName':'height',
                            'from':'0',
                            'to':(c.values[i] - c.min.val) * (coSysHeight / yRange),
                            'begin':'0s',
                            'dur':'1s',
                            'fill':'freeze'}
                        ],
                        ['animate', {
                            attributeName:'y',
                            from:'0',
                            to:-(c.values[i] - c.min.val) * (coSysHeight / yRange),
                            begin:'0s',
                            dur:'1s',
                            fill:'freeze'}
                        ],
                        ['animate', {
                            'attributeName':'opacity',
                            'from':'0',
                            'to':'0.8',
                            'begin':'0s',
                            'dur':'1s',
                            'fill':'freeze',
                            'additive':'replace'}
                        ],
                        ['animate', {
                            'attributeName':'fill',
                            'to':'rgb(100,210,255)',
                            'begin':'mouseover',
                            'dur':'0.1s',
                            'fill':'freeze',
                            'additive':'replace'}
                        ],
                        ['animate', {
                            'attributeName':'fill',
                            'to':'rgb(0,150,250)',
                            'begin':'mouseout',
                            'dur':'0.2s',
                            'fill':'freeze',
                            'additive':'replace'}
                        ]
                    ]
                    , svgNS);
            }
        }

        function horizontalLoop() {

            var cssClass;

            for (var i = 0; i < c.size; i++) {

                cssClass = (i == 0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y';

                DOMinate(
                    [bars,
                        ['line', {
                            'class':cssClass,
                            'x1':(coSysWidth / c.size) * i,
                            'y1':'5',
                            'x2':(coSysWidth / c.size) * i,
                            'y2':-coSysHeight
                        }],
                        ['text', c.keys[i], {
                            'class':'vectual_coordinate_labels_x',
                            'transform':'rotate(40 ' + ((coSysWidth / c.size) * i) + ', 10)',
                            'x':((coSysWidth / c.size) * i),
                            'y':'10'}
                        ]
                    ]
                    , svgNS);

            }
        }

        function verticalLoop() {

            var styleClass, line, text;

            for (var i = 0; i <= (yRange * yDensity); i++) {

                styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';

                DOMinate(
                    [bars,
                        ['line', {
                            'class':styleClass,
                            'x1':'-5',
                            'y1':-(coSysHeight / yRange) * (i / yDensity),
                            'x2':coSysWidth,
                            'y2':-(coSysHeight / yRange) * (i / yDensity) }
                        ],
                        ['text', i / yDensity + c.min.val, {
                            'class':'vectual_coordinate_labels_y',
                            'x':-coSysWidth * 0.05,
                            'y':-(coSysHeight / yRange) * (i / yDensity)}
                        ]
                    ]
                    , svgNS);

            }
        }
    }

    function Line() {

        var yDensity = 0.1,
            yRange = (c.max.val - c.min.val),
            g,
            graph,
            text,
            graphHeight,
            graphWidth,
            coSysHeight,
            coSysWidth;

        graphWidth = c.width * 0.95;
        graphHeight = c.height * 0.8;

        coSysWidth = c.width * 0.85;
        coSysHeight = c.height * 0.6;

        graph = DOMinate(
            ['g', {'transform':'translate(' + (graphWidth * 0.1) + ', ' + (graphHeight) + ')'}]
            , svgNS);

        DOMinate([svg, [graph]]);

        horizontalLoop();
        verticalLoop();
        buildLine();
        setDots();


        function buildLine() {

            var points = '',
                pointsTo = '',
                line,
                a;

            for (var i = 0; i < c.size; i++) {
                points += (i * (coSysWidth / c.size)) + ',0 ';
            }

            for (var j = 0; j < c.size; j++) {
                pointsTo += (j * (coSysWidth / c.size)) + ',' + ((-c.values[j] + c.min.val) * (coSysHeight / yRange)) + ' ';
            }

            line = graph.appendChild(document.createElementNS(svgNS, 'polyline'));
            line.setAttribute('class', 'vectual_line_line');
            line.setAttribute('points', pointsTo);


            if (c.animations) {

                DOMinate(
                    [line,
                        ['animate', {
                            'attributeName':'points',
                            'from':points,
                            'to':pointsTo,
                            'begin':'0s',
                            'dur':'1s',
                            'fill':'freeze'}
                        ],
                        ['animate', {
                            'attributeName':'opacity',
                            'begin':'0s',
                            'from':'0',
                            'to':'1',
                            'dur':'1s',
                            'additive':'replace',
                            'fill':'freeze'}
                        ]
                    ]
                    , svgNS);

            }
        }

        function setDots() {

            var circle,
                a;

            for (var i = 0; i < c.size; i++) {

                circle = DOMinate(
                    ['circle', {
                        'class':'vectual_line_dot',
                        'r':'4',
                        'cx':i * (coSysWidth / c.size),
                        'cy':(-c.values[i] + c.min.val) * (coSysHeight / yRange)}

                        , ['title', c.keys[i] + ':  ' + c.values[i]]
                    ]
                    , svgNS);


                graph.appendChild(circle);


                if (c.animations) {

                    DOMinate(
                        [circle,
                            ['animate', {
                                'attributeName':'opacity',
                                'begin':'0s',
                                'values':'0;0;1',
                                'keyTimes':'0;0.8;1',
                                'dur':'1.5s',
                                'additive':'replace',
                                'fill':'freeze'
                            }],
                            ['animate', {
                                'attributeName':'r',
                                'to':'8',
                                'dur':'0.1s',
                                'begin':'mouseover',
                                'additive':'replace',
                                'fill':'freeze'
                            }],
                            ['animate', {
                                'attributeName':'r',
                                'to':'4',
                                'dur':'0.2s',
                                'begin':'mouseout',
                                'additive':'replace',
                                'fill':'freeze'}
                            ]
                        ]
                        , svgNS);

                }
            }

        }

        function horizontalLoop() {

            var cssClass, line;

            for (var i = 0; i < c.size; i++) {

                cssClass = (i == 0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y';

                DOMinate(
                    [graph,
                        ['line', {
                            'class':cssClass,
                            'x1':(coSysWidth / c.size) * i,
                            'y1':5,
                            'x2':(coSysWidth / c.size) * i,
                            'y2':-coSysHeight}
                        ],
                        ['text', c.keys[i], {
                            'class':'vectual_coordinate_labels_x',
                            'transform':'rotate(40 ' + ((coSysWidth / c.size) * i) + ', 10)',
                            'x':((coSysWidth / c.size) * i),
                            'y':'10'}
                        ]
                    ]
                    , svgNS);

            }
        }

        function verticalLoop() {

            var styleClass, line, text;

            for (var i = 0; i <= (yRange * yDensity); i++) {

                styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';

                DOMinate(
                    [graph,
                        ['line', {
                            'class':styleClass,
                            'x1':-5,
                            'y1':-(coSysHeight / yRange) * (i / yDensity),
                            'x2':coSysWidth,
                            'y2':-(coSysHeight / yRange) * (i / yDensity)
                        }],
                        ['text', i / yDensity + c.min.val, {
                            'class':'vectual_coordinate_labels_y',
                            'x':-coSysWidth * 0.05,
                            'y':-(coSysHeight / yRange) * (i / yDensity)
                        }]
                    ]
                    , svgNS);

            }
        }
    }

    function Tagcloud() {

        var cloud = DOMinate(
            ['g', {
                transform:'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')'}

            ]
            , svgNS);

        DOMinate([svg, [cloud]]);

        compileTagcloud();

        function compileTagcloud() {

            var until = 300, // size of spiral
                factor = 4, // resolution improvement
                density = 0.2, // density of spiral
                xySkew = 0.6, // elliptical shape of spiral (0 < xySkew < 1)
                a = 0, // Word counter
                points = '',
                i,
                b,
                u,
                x,
                y,
                pos_x = [],
                pos_y = [],
                area_x = [],
                area_y = [];


            //Positioning along an archimedic spiral
            for (i = 0; i < (until * factor * density); i++) { //Testing each point of the spiral


                var fontSize = getFontSize(c.values[a]);  // Calculate font-size for each word

                var length = (c.keys[a] * fontSize).length;

                //x and y values of the position to test
                b = i * (1 / factor);

                x = -(1 / density) * xySkew * b * Math.cos(b);
                y = -(1 / density) * (1 - xySkew) * b * Math.sin(b);

                pos_x[a] = x;
                pos_y[a] = y;
                area_x[a] = length;
                area_y[a] = fontSize;

                //Test if word covers one of the already printed
                for (u = 0; u <= a; u++) {

                    if (a == 0) {

                        setWord(c.keys[a], fontSize);
                        a++;

                    } else {

                        //x-value
                        if (pos_x[a] < (pos_x[u] - area_x[a]) || pos_x[a] > (pos_x[u] + area_x[u])) {

                            //y-value
                            if (pos_y[a] < (pos_y[u] - area_y[a]) || pos_y[a] > (pos_y[u] + area_y[u])) {

                                setWord(c.keys[a], fontSize);
                                a++;

                            }
                        }
                    }
                }
            }

            function setWord(content, fontSize) {
                DOMinate(
                    [cloud,
                        ['text', content, {
                            'class':'vectual_tagcloud_text',
                            style:'font-size' + fontSize,
                            x:x,
                            y:y}
                        ]
                    ]
                    , svgNS);
            }

            function getFontSize(number) {
                var a = 10;		// Minimum font-size

                return a + ((c.height * 0.1) * (number - c.min.val)) / (c.max.val - c.min.val);
            }

            for (var j = 0; j < (until * factor * density); j++) {
                b = j * (1 / factor);

                x = -(1 / density) * xySkew * b * Math.cos(b);
                y = -(1 / density) * (1 - xySkew) * b * Math.sin(b);

                points += x + ',' + y + ' ';
            }

            DOMinate(
                [cloud,
                    ['polyline', {
                        points:points,
                        style:'fill: none; stroke:red; stroke-width:1'
                    }]

                ]
                , svgNS);
        }
    }

    vectual = v;

})(window, document);