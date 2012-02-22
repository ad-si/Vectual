(function (window, document, undefined) {
    var xhtmlNS,
        svgNS,
        xlinkNS;

    xhtmlNS = "http://www.w3.org/1999/xhtml";
    svgNS = "http://www.w3.org/2000/svg";
    xlinkNS = "http://www.w3.org/1999/xlink";

    var svg;

    function attr(obj, attributes) {
        for (var prop in attributes) {
            obj.setAttributeNS(null, prop, attributes[prop]);
        }
    }

    function v(c) {

        var defs,
            bg,
            title,
            pie,
            radius,
            startx,
            starty,
            angle,
            lastx,
            lasty,
            angle_all,
            angle_all_last,
            graphHeight,
            graphWidth,
            width,
            height,
            circle,
            totalValue,
            maxValue,
            sortedKeys,
            numKeys,
            color,
            position,
            angle_this,
            angle_rad,
            angle_translate,
            angle_add,
            angle_translate_deg,
            tx,
            ty,
            nextx,
            nexty,
            xValues,
            yValues,
            sector,
            sortedValues,
            size,
            at,
            atra,
            path,
            ani,
            aniTransform,
            text,
            animate;

        c.colors = ['yellow', 'green', 'blue', 'brown'];

        function Element(type) {
            return document.createElementNS(svgNS, type)
        }

        svg = document.createElementNS(svgNS, 'svg');
        attr(svg, {
            'xmlns':"http://www.w3.org/2000/svg",
            'version':"1.1",
            'class':(c.inline) ? 'vectual_inline' : 'vectual',
            'width':c.width,
            'height':c.height,
            'viewBox':"0 0 400 200"
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
            'style':'font-size:' + (obj.height * 0.05) + 'px'
        });
        title.appendChild(document.createTextNode(c.title));
        svg.appendChild(title);

        var funcs = {
            'pieChart': new Pie(c),
            'test':'test'
        };

        return funcs;
    }

    function Pie(c) {
        var pie,
            startx,
            starty,
            angle,
            lastx,
            lasty,
            angle_all,
            angle_all_last,
            graphHeight,
            graphWidth,
            width,
            height,
            circle,
            totalValue,
            maxValue,
            sortedKeys,
            numKeys,
            color,
            text,
            radius = Math.min(c.height, c.width * 0.2);

        pie = document.createElementNS(svgNS, 'g');
        pie.setAttribute('transform', 'translate(' + (0.5 * c.width) + ', ' + (0.5 * c.height) + ')');

        svg.appendChild(pie);


        if (totalValue == maxValue) { //only one value

            circle = document.createElementNS(svgNS, 'circle');
            attr(circle, {
                'class':'vectual_pie_sector',
                'cx':'0',
                'cy':'0',
                'r':radius,
                'fill':c.colors[1]
            });

            pie.appendChild(circle);

            text = document.createElement('text');
            text.setAttribute('class', 'vectual_pie_text_single, vectual_pie_text');
            text.setAttribute('x', '0');
            text.setAttribute('y', '0');
            text.setAttribute('style', 'font-size:' + (radius * 0.3) + 'px');
            text.setAttribute('text-anchor', 'middle');
            text.setAttribute('stroke-width', (radius * 0.006));


            text.appendChild(document.createTextNode('test'));
            pie.appendChild(text);

        } else {
            for (i = 0; i < numKeys; i++) { //Pie sectors
                drawSector(i);
            }
        }

        function drawSector(i) {

            var radius,
                position,
                angle_all_last,
                angle_all,
                angle_this,
                angle_rad,
                angle_translate,
                angle_add,
                angle_translate_deg,
                tx,
                ty,
                nextx,
                nexty,
                xValues,
                yValues,
                sector,
                sortedValues,
                totalValue,
                size,
                at,
                atra,
                path,
                ani,
                aniTransform,
                text,
                animate,
                lastx,
                lasty,
                title;

            startx = (0.5 * width);
            starty = (0.5 * height);
            angle = 0;
            lastx = -c.radius;
            lasty = 0;

            angle_all_last = angle_all;

            if (((sortedValues[i] / totalValue) * 360) > 180) size = '0 1,0';
            else size = '0 0,0';

            //Angle
            angle_all_last = angle_all;
            angle_this = ((sortedValues[i] / totalValue) * 360);
            angle_all = angle_this + angle_all;
            angle_rad = deg2rad(angle_all);

            //Shift direction: add previous angle to half of the current
            angle_add = angle_this / 2;
            angle_translate_deg = angle_all_last + angle_add;
            angle_translate = deg2rad(angle_translate_deg);

            tx = -(cos(angle_translate)) * radius;
            ty = (sin(angle_translate)) * radius;

            nextx = -(cos(angle_rad) * radius);
            nexty = (sin(angle_rad) * radius);

            if (angle_translate_deg > 0 && angle_translate_deg <= 75) position = 'end';
            if (angle_translate_deg > 75 && angle_translate_deg <= 105) position = 'middle';
            if (angle_translate_deg > 105 && angle_translate_deg <= 255) position = 'start';
            if (angle_translate_deg > 255 && angle_translate_deg <= 285) position = 'middle';
            if (angle_translate_deg > 285 && angle_translate_deg <= 360) position = 'end';

            xValues = -(cos(angle_translate) * radius);
            yValues = (sin(angle_translate) * radius);


            sector = pie.addChild('g');
            sector.setAttribute('class', 'vectual_pie_sector');

            if (animations) {
                at = sector.addChild('animateTransform');
                at.setAttribute('attributeName', 'transform');
                at.setAttribute('begin', 'mouseover');
                at.setAttribute('type', 'translate');
                at.setAttribute('to', (tx * 0.2) + ', ' + (ty * 0.2));

                at.setAttribute('dur', '0.3s');
                at.setAttribute('additive', 'replace');
                at.setAttribute('fill', 'freeze');

                atra = sector.addChild('animateTransform');
                atra.setAttribute('attributeName', 'transform');
                atra.setAttribute('begin', 'mouseout');
                atra.setAttribute('type', 'translate');
                atra.setAttribute('to', '0,0');
                atra.setAttribute('dur', '0.3s');
                atra.setAttribute('additive', 'replace');
                atra.setAttribute('fill', 'freeze');
            }

            path = sector.addChild('path');
            path.setAttribute('class', 'vectual_pie_sector_path');
            path.setAttribute('style', 'stroke-width:' + (radius * 0.015) + ';fill:' + color[i]);
            path.setAttribute('d', 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z');
            path.setAttribute('transform', '');


            if (animations) {
                ani = path.addChild('animate');
                ani.setAttribute('attributeName', 'opacity');
                ani.setAttribute('from', '0');
                ani.setAttribute('to', '1');
                ani.setAttribute('dur', '0.6s');
                ani.setAttribute('fill', 'freeze');

                aniTransform = path.addChild('animateTransform');
                aniTransform.setAttribute('attributeName', 'transform');
                aniTransform.setAttribute('type', 'rotate');
                aniTransform.setAttribute('dur', '0.8s');
                //aniTransform.setAttribute('calcMode','spline');
                //aniTransform.setAttribute('keySplines','0 0 0 1');
                aniTransform.setAttribute('values', angle_all_last + ',0,0; 0,0,0');
                aniTransform.setAttribute('additive', 'replace');
                aniTransform.setAttribute('fill', 'freeze');


                fanOut = path.addChild('animate');
                fanOut.setAttribute('attributeName', 'd');
                //fanOut.setAttribute('from','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+lastx+','+lasty+' z');
                //fanOut.setAttribute('to','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+nextx+','+nexty+' z');
                fanOut.setAttribute('values', 'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + lastx + ',' + lasty + ' z; ' +
                    'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + xValues + ',' + yValues + ' z; ' +
                    'M 0,0 L ' + lastx + ',' + lasty + ' A ' + radius + ',' + radius + ' ' + size + ' ' + nextx + ',' + nexty + ' z; ');
                fanOut.setAttribute('dur', '0.8s');

            }


            text = sector.addChild('text', sortedKeys[i]);
            text.setAttribute('class', 'vectual_pie_text');
            text.setAttribute('x', (tx * 1.2));
            text.setAttribute('y', (ty * 1.2));
            text.setAttribute('text-anchor', position);
            text.setAttribute('style', 'font-size:' + (angle_this * radius * 0.002 + 8) + 'px');
            text.setAttribute('fill', color[i]);
            text.setAttribute('transform', 'translate(0, 5)');


            if (animations) {
                animate = text.addChild('animate');
                animate.setAttribute('attributeName', 'opacity');
                animate.setAttribute('begin', '0s');
                animate.setAttribute('values', '0;0;1');
                animate.setAttribute('dur', '0.9s');
                animate.setAttribute('additive', 'replace');
                animate.setAttribute('fill', 'freeze');
            }

            title = sector.addChild('title', sortedKeys[i] + ' | ' + sortedValues[i] + ' | ' + (round(sortedValues[i] / totalValue * 100, 2) ) + '%');

            lastx = nextx;
            lasty = nexty;
        }
    }

    /*
     function Bar() {

     var bar,
     yDensity = 0.1,
     xDensity = 0.2,
     toolbar,
     bar = svg.addChild('g'),
     toolbar,
     height,
     width,
     graphWidth,
     numValues,
     a,
     b,
     title,
     c,
     d,
     e,
     line,
     text;

     function setBargraph() {

     !empty(toolbar) ? translate_y = height : translate_y = (height - 40);

     bar.setAttribute('transform', 'translate(' + (graphWidth * 0.08) + ', ' + translate_y + ')');

     setCoordinatesystem();
     setBar();
     }

     function setBar() {

     for (var i = 0; i < numValues; i++) {
     buildBar(i);
     }
     }

     function setCoordinatesystem() {
     horizontalLoop();
     verticalLoop();
     }

     function buildBar(i) {

     bar = bar.addChild('rect');
     bar.setAttribute('filter', 'url(#dropshadow)');
     bar.setAttribute('class', 'vectual_bar_bar');
     bar.setAttribute('x', (i * (graphWidth / numValues)));
     bar.setAttribute('y', -(values[i] - minValue) * (graphHeight / yRange));
     bar.setAttribute('height', (values[i] - minValue) * (graphHeight / yRange));
     bar.setAttribute('width', (0.7 * (graphWidth / numValues)));


     title = bar.addChild('title', keys[i] + ':  ' + values[i]);

     if (animations) {
     a = bar.addChild('animate');
     a.setAttribute('attributeName', 'height');
     a.setAttribute('from', '0');
     a.setAttribute('to', (values[i] - minValue) * (graphHeight / yRange));
     a.setAttribute('begin', '0s');
     a.setAttribute('dur', '0.8s');
     a.setAttribute('fill', 'freeze');

     b = bar.addChild('animate');
     b.setAttribute('attributeName', 'y');
     b.setAttribute('from', '0');
     b.setAttribute('to', -(values[i] - minValue) * (graphHeight / yRange));
     b.setAttribute('begin', '0s');
     b.setAttribute('dur', '0.8s');
     b.setAttribute('fill', 'freeze');

     c = bar.addChild('animate');
     c.setAttribute('attributeName', 'opacity');
     c.setAttribute('from', '0');
     c.setAttribute('to', '0.8');
     c.setAttribute('begin', '0s');
     c.setAttribute('dur', '0.8s');
     c.setAttribute('fill', 'freeze');
     c.setAttribute('additive', 'replace');

     d = bar.addChild('animate');
     d.setAttribute('attributeName', 'fill');
     d.setAttribute('to', 'rgb(100,210,255)');
     d.setAttribute('begin', 'mouseover');
     d.setAttribute('dur', '0.1s');
     d.setAttribute('fill', 'freeze');
     d.setAttribute('additive', 'replace');

     e = bar.addChild('animate');
     e.setAttribute('attributeName', 'fill');
     e.setAttribute('to', 'rgb(0,150,250)');
     e.setAttribute('begin', 'mouseout');
     e.setAttribute('dur', '0.2s');
     e.setAttribute('fill', 'freeze');
     e.setAttribute('additive', 'replace');
     }


     var =
     '<rect filter="url(#dropshadow)" class="vectual_bar_bar" style="opacity:0;"
     x="'+(i * (graphWidth/numValues))+'" y="0"
     height="0" width="'+(0.7 * (graphWidth/numValues))+'" >'+

     '<title>'+keys[i]+':  '+values[i]+'</title>'+

     '<animate attributeName="height" to="'+((values[i] - minValue) * (graphHeight/yRange))+'"
     begin="0" dur="0.8s" fill="freeze" />'+
     '<animate attributeName="y" to="-'+((values[i] - minValue) * (graphHeight/yRange))+'"
     begin="0" dur="0.8s" fill="freeze" />'+
     '<animate attributeName="opacity" begin="0s" to="0.8" dur="0.8s" additive="replace" fill="freeze"/>'+

     '<animate attributeName="fill" to="rgb(100,210,255)" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'+
     '<animate attributeName="fill" to="rgb(0,150,250)" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'+
     '</rect>';

     return var;

     }


     function horizontalLoop() {

     var cssClass;

     for (var i = 0; i < numValues; i++) {

     (i == 0) ? cssClass = 'vectual_coordinate_axis_y' : cssClass = 'vectual_coordinate_lines_y';

     line = bar.addChild('line');
     line.setAttribute('class', cssClass);
     line.setAttribute('x1', (graphWidth / numValues) * i);
     line.setAttribute('y1', '5');
     line.setAttribute('x2', (graphWidth / numValues) * i);
     line.setAttribute('y2', -graphHeight);

     text = bar.addChild('text', keys[i]);
     text.setAttribute('class', 'vectual_coordinate_labels_x');
     text.setAttribute('transform', 'rotate(40 ' + ((graphWidth / numValues) * i) + ', 10)');
     text.setAttribute('x', ((graphWidth / numValues) * i));
     text.setAttribute('y', '10');

     }
     }

     function verticalLoop() {

     var class;

     for (var i = 0; i <= (yRange * yDensity); i++) {

     (i == 0) ? class = 'vectual_coordinate_axis_x' : class = 'vectual_coordinate_lines_x';

     line = bar.addChild('line');
     line.setAttribute('class', class);
     line.setAttribute('x1', '-5');
     line.setAttribute('y1', -(graphHeight / yRange) * (i / yDensity));
     line.setAttribute('x2', graphWidth);
     line.setAttribute('y2', -(graphHeight / yRange) * (i / yDensity));

     text = bar.addChild('text', (i / yDensity) + minValue);
     text.setAttribute('class', 'vectual_coordinate_labels_y');
     text.setAttribute('x', -graphWidth * 0.05);
     text.setAttribute('y', -(graphHeight / yRange) * (i / yDensity));

     }
     }
     }
     */


    vectual = v;

})
    (window, document);
