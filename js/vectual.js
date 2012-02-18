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

})(window, document);