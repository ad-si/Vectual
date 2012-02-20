(function (window, document, undefined) {

    function v(obj) {

        var defs,
            svg,
            bg,
            xhtmlNS,
            svgNS,
            xlinkNS,
            title;

        this.version = "0.1";
        this.toString = function () {
            return  "You are running vectual " + this.version;
        };

        function attr(obj, attributes) {
            for (var prop in attributes) {
                obj.setAttributeNS(null, prop, attributes[prop]);
            }
        }

        xhtmlNS = "http://www.w3.org/1999/xhtml";
        svgNS = "http://www.w3.org/2000/svg";
        xlinkNS = "http://www.w3.org/1999/xlink";

        svg = document.createElementNS(svgNS, 'svg');
        attr(svg, {
            'xmlns':"http://www.w3.org/2000/svg",
            'version':"1.1",
            'class':(obj.inline) ? 'vectual_inline' : 'vectual',
            'width':obj.width,
            'height':obj.height,
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
            'width':obj.width,
            'height':obj.height,
            'rx':obj.inline ? '' : 10,
            'ry':obj.inline ? '' : 10
        });
        svg.appendChild(bg);

        title = document.createElementNS(svgNS, 'text');
        attr(title, {
            'class':'vectual_title',
            'x':20,
            'y':(10 + obj.height * 0.05),
            'style':'font-size:' + (obj.height * 0.05) + 'px'
        });
        title.appendChild(document.createTextNode(obj.title));
        svg.appendChild(title);
    }

    vectual = v;

    function Pie() {
        var pie,
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
            color;

        radius = radius || Math.min(graphHeight, graphWidth * 0.2);

        startx = (0.5 * width);
        starty = (0.5 * height);
        angle = 0;
        lastx = -radius;
        lasty = 0;

        pie = svg.addChild('g');

        pie.setAttribute('transform', 'translate(' + startx + ', ' + starty + ')');


        if (totalValue == maxValue) { //only one value

            circle = pie.addChild('circle');
            circle.setAttribute('class', 'vectual_pie_sector');
            circle.setAttribute('cx', '0');
            circle.setAttribute('cy', '0');
            circle.setAttribute('r', radius);
            circle.setAttribute('fill', color[index_max]);

            circle = pie.addChild('text', sortedKeys[index_max]);
            circle.setAttribute('class', 'vectual_pie_text_single, vectual_pie_text');
            circle.setAttribute('x', '0');
            circle.setAttribute('y', '0');
            circle.setAttribute('style', 'font-size:' + (radius * 0.3) + 'px');
            circle.setAttribute('text-anchor', 'middle');
            circle.setAttribute('stroke-width', (radius * 0.006));

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


                /*fanOut = path.addChild('animate');
                 fanOut.setAttribute('attributeName','d');
                 //fanOut.setAttribute('from','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+lastx+','+lasty+' z');
                 //fanOut.setAttribute('to','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+nextx+','+nexty+' z');
                 fanOut.setAttribute('values','M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+lastx+','+lasty+' z; '+
                 'M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+xValues+','+yValues+' z; '+
                 'M 0,0 L '+lastx+','+lasty+' A '+radius+','+radius+' '+size+' '+nextx+','+nexty+' z; ');
                 fanOut.setAttribute('dur','0.8s');

                 }
                 */


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
    }

})(window, document);
