(function (window, document, undefined) {
    var svg,
        c,
        xhtmlNS = "http://www.w3.org/1999/xhtml",
        svgNS = "http://www.w3.org/2000/svg",
        xlinkNS = "http://www.w3.org/1999/xlink";

    function attr(obj, attributes) {
        for (var prop in attributes) {
            if (attributes.hasOwnProperty(prop)) {
                obj.setAttribute(prop, attributes[prop]);
            }
        }
    }

    function toRad(degrees) {
        return degrees * (Math.PI / 180);
    }

    function v(config) {

        var defs, bg, title, size, text;

        c = config;

        c.colors = ['yellow', 'green', 'blue', 'brown', 'grey', 'yellow', 'green', 'blue', 'brown', 'yellow', 'green', 'blue', 'brown'];
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

        function el(type) {
            return document.createElementNS(svgNS, type)
        }

        svg = document.createElementNS(svgNS, 'svg');
        attr(svg, {
            'xmlns':"http://www.w3.org/2000/svg",
            'version':"1.1",
            'class':(c.inline) ? 'vectual_inline' : 'vectual',
            'width':c.width,
            'height':c.height,
            'viewBox':"0 0 " + c.width + " " + c.height
        });
        document.getElementById(obj.id).appendChild(svg);

        defs = document.createElementNS(svgNS, 'defs');
        defs.innerHTML = '<linearGradient id="rect_background" x1="0%" y1="0%" x2="0%" y2="100%">\n\t\t<stop offset="0%" style="stop-color:rgb(80,80,80); stop-opacity:1"/>\n\t\t<stop offset="100%" style="stop-color:rgb(40,40,40); stop-opacity:1"/>\n\t</linearGradient>\n\t<filter id="dropshadow">\n\t\t<feGaussianBlur in="SourceAlpha" stdDeviation="0.5" result="blur"/>\n\t\t<feOffset in="blur" dx="2" dy="2" result="offsetBlur"/>\n\t\t<feComposite in="SourceGraphic" in2="offsetBlur" result="origin"/>\n\t</filter>';
        svg.appendChild(defs);

        bg = document.createElementNS(svgNS, 'rect');
        attr(bg, {
            'class':'vectual_background',
            'x':0,
            'y':0,
            'width':c.width,
            'height':c.height,
            'rx':c.inline ? '' : 10,
            'ry':c.inline ? '' : 10
        });
        svg.appendChild(bg);

        title = document.createElementNS(svgNS, 'text');
        attr(title, {
            'class':'vectual_title',
            'x':20,
            'y':(10 + c.height * 0.05),
            'style':'font-size:' + (c.height * 0.05) + 'px'
        });
        title.appendChild(document.createTextNode(c.title));
        svg.appendChild(title);

        return {
            pieChart:function () {
                return new Pie();
            },
            barChart:function () {
                return new Bar();
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

        pie = document.createElementNS(svgNS, 'g');
        pie.setAttribute('transform', 'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')');

        svg.appendChild(pie);


        if (c.totalValue == c.max.val) { //only one value

            circle = document.createElementNS(svgNS, 'circle');
            attr(circle, {
                'class':'vectual_pie_sector',
                'cx':'0',
                'cy':'0',
                'r':radius,
                'fill':c.colors[1]
            });

            pie.appendChild(circle);

            text = document.createElementNS(svgNS, 'text');
            attr(text, {
                'class':'vectual_pie_text_single, vectual_pie_text',
                'x':'0',
                'y':'0',
                'style':'font-size:' + (radius * 0.3) + 'px',
                'text-anchor':'middle',
                'stroke-width':(radius * 0.006)
            });
            text.appendChild(document.createTextNode('test'));
            pie.appendChild(text);

        }

        else {
            for (var i = 0; i < c.size; i++) { //Pie sectors
                drawSector(i);
            }
        }

        function drawSector(i) {
            var position, angle_all_rad, angle_all_last, angle_this, angle_translate, angle_add,
                trans_deg, tx, ty, sector, size, at, atra, path, ani,
                aniTransform, text, animate, title, nextx, nexty;

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


            sector = pie.appendChild(document.createElementNS(svgNS, 'g'));
            sector.setAttribute('class', 'vectual_pie_sector');

            if (c.animations) {
                at = sector.appendChild(document.createElementNS(svgNS, 'animateTransform'));
                at.setAttribute('attributeName', 'transform');
                at.setAttribute('begin', 'mouseover');
                at.setAttribute('type', 'translate');
                at.setAttribute('to', (tx * 0.2) + ', ' + (ty * 0.2));
                at.setAttribute('dur', '0.3s');
                at.setAttribute('additive', 'replace');
                at.setAttribute('fill', 'freeze');

                atra = sector.appendChild(document.createElementNS(svgNS, 'animateTransform'));
                atra.setAttribute('attributeName', 'transform');
                atra.setAttribute('begin', 'mouseout');
                atra.setAttribute('type', 'translate');
                atra.setAttribute('to', '0,0');
                atra.setAttribute('dur', '0.3s');
                atra.setAttribute('additive', 'replace');
                atra.setAttribute('fill', 'freeze');
            }

            path = sector.appendChild(document.createElementNS(svgNS, 'path'));
            path.setAttribute('class', 'vectual_pie_sector_path');
            path.setAttribute('style', 'stroke-width:' + (radius * 0.015) + ';fill:' + c.colors[i]);
            path.setAttribute('d', 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z');
            path.setAttribute('transform', '');


            if (c.animations) {
                ani = path.appendChild(document.createElementNS(svgNS, 'animate'));
                ani.setAttribute('attributeName', 'opacity');
                ani.setAttribute('from', '0');
                ani.setAttribute('to', '1');
                ani.setAttribute('dur', '0.6s');
                ani.setAttribute('fill', 'freeze');

                aniTransform = path.appendChild(document.createElementNS(svgNS, 'animateTransform'));
                aniTransform.setAttribute('attributeName', 'transform');
                aniTransform.setAttribute('type', 'rotate');
                aniTransform.setAttribute('dur', '1s');
                //aniTransform.setAttribute('calcMode','spline');
                //aniTransform.setAttribute('keySplines','0 0 0 1');
                aniTransform.setAttribute('values', angle_all_last + ',0,0; 0,0,0');
                aniTransform.setAttribute('additive', 'replace');
                aniTransform.setAttribute('fill', 'freeze');

                /*
                 fanOut = path.appendChild(document.createElementNS(svgNS, 'animate');
                 fanOut.setAttribute('attributeName', 'd');
                 fanOut.setAttribute('from','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+lastx+','+lasty+' z');
                 fanOut.setAttribute('to','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+nextx+','+nexty+' z');
                 fanOut.setAttribute('values', 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + lastx + ',' + lasty + ' z; ' +
                 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + xValues + ',' + yValues + ' z; ' +
                 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z; ');
                 fanOut.setAttribute('dur', '0.8s');
                 */
            }


            text = sector.appendChild(document.createElementNS(svgNS, 'text'));
            text.appendChild(document.createTextNode(c.sorted.key[i]));
            text.setAttribute('class', 'vectual_pie_text');
            text.setAttribute('x', (tx * 1.2));
            text.setAttribute('y', (ty * 1.2));
            text.setAttribute('text-anchor', position);
            text.setAttribute('style', 'font-size:' + (angle_this * radius * 0.002 + 8) + 'px');
            text.setAttribute('fill', c.colors[i]);
            text.setAttribute('transform', 'translate(0, 5)');


            if (c.animations) {
                animate = text.appendChild(document.createElementNS(svgNS, 'animate'));
                animate.setAttribute('attributeName', 'opacity');
                animate.setAttribute('begin', '0s');
                animate.setAttribute('values', '0;0;1');
                animate.setAttribute('dur', '1s');
                animate.setAttribute('fill', 'freeze');
            }

            title = sector.appendChild(document.createElementNS(svgNS, 'title'));
            title.appendChild(document.createTextNode(c.sorted.key[i] + ' | ' + c.sorted.val[i] + ' | ' + (Math.round(c.sorted.val[i] / c.totalValue * 100, 2) ) + '%'));

            lastx = nextx;
            lasty = nexty;
        }
    }

    function Bar() {

        var bars,
            yDensity = 0.1,
            xDensity = 0.2,
            yRange = (c.max.val - c.min.val),
            a,
            b,
            d,
            g,
            e,
            line,
            text,
            graphHeight,
            graphWidth,
            coorSysHeight,
            coorSysWidth;

        graphWidth = c.width * 0.95;
        graphHeight = c.height * 0.8;

        coorSysWidth = c.width * 0.85;
        coorSysHeight = c.height * 0.6;

        bars = svg.appendChild(document.createElementNS(svgNS, 'g'));
        bars.setAttribute('transform', 'translate(' + (graphWidth * 0.1) + ', ' + (graphHeight * 1.0) + ')');

        horizontalLoop();
        verticalLoop();

        for (var i = 0; i < c.size; i++) {
            buildBar(i);
        }


        function buildBar(i) {
            var bar = bars.appendChild(document.createElementNS(svgNS, 'rect'));
            //bar.setAttribute('filter', 'url(#dropshadow)');
            bar.setAttribute('class', 'vectual_bar_bar');
            bar.setAttribute('x', (i * (coorSysWidth / c.size)));
            bar.setAttribute('y', -(c.values[i] - c.min.val) * (graphHeight / yRange));
            bar.setAttribute('height', (c.values[i] - c.min.val) * (coorSysHeight / yRange));
            bar.setAttribute('width', (0.7 * (coorSysWidth / c.size)));

            //title = bar.appendChild(document.createElementNS(svgNS, 'title', c.keys[i] + ':  ' + c.values[i]));

            if (c.animations) {
                a = bar.appendChild(document.createElementNS(svgNS, 'animate'));
                a.setAttribute('attributeName', 'height');
                a.setAttribute('from', '0');
                a.setAttribute('to', (c.values[i] - c.min.val) * (coorSysHeight / yRange));
                a.setAttribute('begin', '0s');
                a.setAttribute('dur', '1s');
                a.setAttribute('fill', 'freeze');

                b = bar.appendChild(document.createElementNS(svgNS, 'animate'));
                b.setAttribute('attributeName', 'y');
                b.setAttribute('from', '0');
                b.setAttribute('to', -(c.values[i] - c.min.val) * (coorSysHeight / yRange));
                b.setAttribute('begin', '0s');
                b.setAttribute('dur', '1s');
                b.setAttribute('fill', 'freeze');

                g = bar.appendChild(document.createElementNS(svgNS, 'animate'));
                g.setAttribute('attributeName', 'opacity');
                g.setAttribute('from', '0');
                g.setAttribute('to', '0.8');
                g.setAttribute('begin', '0s');
                g.setAttribute('dur', '1s');
                g.setAttribute('fill', 'freeze');
                g.setAttribute('additive', 'replace');

                d = bar.appendChild(document.createElementNS(svgNS, 'animate'));
                d.setAttribute('attributeName', 'fill');
                d.setAttribute('to', 'rgb(100,210,255)');
                d.setAttribute('begin', 'mouseover');
                d.setAttribute('dur', '0.1s');
                d.setAttribute('fill', 'freeze');
                d.setAttribute('additive', 'replace');

                e = bar.appendChild(document.createElementNS(svgNS, 'animate'));
                e.setAttribute('attributeName', 'fill');
                e.setAttribute('to', 'rgb(0,150,250)');
                e.setAttribute('begin', 'mouseout');
                e.setAttribute('dur', '0.2s');
                e.setAttribute('fill', 'freeze');
                e.setAttribute('additive', 'replace');
            }
        }

        function horizontalLoop() {

            var cssClass, textEl;

            for (var i = 0; i < c.size; i++) {

                (i == 0) ? cssClass = 'vectual_coordinate_axis_y' : cssClass = 'vectual_coordinate_lines_y';

                line = bars.appendChild(document.createElementNS(svgNS, 'line'));
                line.setAttribute('class', cssClass);
                line.setAttribute('x1', (coorSysWidth / c.size) * i);
                line.setAttribute('y1', '5');
                line.setAttribute('x2', (coorSysWidth / c.size) * i);
                line.setAttribute('y2', -coorSysHeight);

                textEl = document.createElementNS(svgNS, 'text');
                textEl.appendChild(document.createTextNode(c.keys[i]));
                text = bars.appendChild(textEl);
                text.setAttribute('class', 'vectual_coordinate_labels_x');
                text.setAttribute('transform', 'rotate(40 ' + ((coorSysWidth / c.size) * i) + ', 10)');
                text.setAttribute('x', ((coorSysWidth / c.size) * i));
                text.setAttribute('y', '10');

            }
        }

        function verticalLoop() {

            var styleClass, line, text, textEl;

            for (var i = 0; i <= (yRange * yDensity); i++) {

                styleClass = (i == 0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';

                line = bars.appendChild(document.createElementNS(svgNS, 'line'));
                line.setAttribute('class', styleClass);
                line.setAttribute('x1', '-5');
                line.setAttribute('y1', -(coorSysHeight / yRange) * (i / yDensity));
                line.setAttribute('x2', coorSysWidth);
                line.setAttribute('y2', -(coorSysHeight / yRange) * (i / yDensity));

                textEl = document.createElementNS(svgNS, 'text');
                textEl.appendChild(document.createTextNode(i / yDensity + c.min.val));
                text = bars.appendChild(textEl);
                text.setAttribute('class', 'vectual_coordinate_labels_y');
                text.setAttribute('x', -coorSysWidth * 0.05);
                text.setAttribute('y', -(coorSysHeight / yRange) * (i / yDensity));

            }
        }
    }

    vectual = v;

})(window, document);
