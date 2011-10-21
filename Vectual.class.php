<?php
//namespace Vectual;

class Vectual {

	protected $header = '';
	protected $toolbarObjects = array();
	
	protected $width;
	protected $height;
	protected $type;
	protected $title;
	protected $class;
	protected $xhtml;
	protected $standalone;
	protected $inline;
	protected $data;
	protected $config;	
	
	static $color = array();
	
	
	function __construct($data, $config) {
	
		$this->toolbarObjects = $config['toolbar'];
		
		$this->inline = $config['inline'];
		if($this->inline){
			$this->width = 3 * $config['lineHeight'];
			$this->height = $config['lineHeight'];
		}else{
			$this->width = $config['width'];
			$this->height = $config['height'];
		}
		
		$this->title = $config['title'];
		$this->xhtml = $config['xhtml'];
		$this->standalone = $config['standalone'];
		$this->data = $data;
		$this->config = $config;
		
		$this->class = (($this->inline) ? 'vectual_inline' : 'vectual');	
	}
	
	public function getPiechart(){
		$this->type = 'pie';
		return $this->draw();
	}
	
	public function getBarchart(){
		$this->type = 'bar';
		return $this->draw();
	}
	
	public function getLinechart(){
		$this->type = 'line';
		return $this->draw();
	}
	
	public function getScatterchart(){
		$this->type = 'scatter';
		return $this->draw();
	}
	
	public function getTagcloud(){
		$this->type = 'tagcloud';
		return $this->draw();
	}
	
	public function getMap(){
		$this->type = 'map';
		return $this->draw();
	}
	
	public function getTable(){
		$this->type = 'table';
		return $this->draw();
	}
	
	public function getSparkline(){
		$this->type = 'sparkline';
		return $this->draw();
	}
	
	

	
	private function draw(){
		$svg = '';
	
		if($this->standalone){		
			$svg .= 
			'<?xml version="1.0" standalone="no"?>
			<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';
		}
	
		$svg .=
		'<svg '.$this->getHeader().' class="'.$this->class.'" width="'.$this->width.'" height="'.$this->height.'" >'.
			$this->getDefs().
			$this->getStyle(). 
			$this->getBackground(). 
			$this->getToolbar(). 
			$this->getGraph(). 
		'</svg>'; 
		
		return $svg;
	}
	
	
	private function getHeader(){
		if($this->xhtml || $this->standalone){
			$header = 'xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"';
		}else{
			$header = '';
		}
		
		return $header;
	}

	private function getGraph() {
	
		switch($this->type){
			case 'pie':
				$new = new Pie($this->data, $this->config);
				return $new->getPie();
				break;
			case 'map':
				$new = new Map($this->data, $this->config);
				return $new->getMap();
				break;
			case 'bar':
				$new = new Bar($this->data, $this->config);
				return $new->getBargraph();
				break;
			case 'line':
				$new = new Line($this->data, $this->config);
				return $new->getLinegraph();
				break;
			case 'table':
				$new = new Table($this->data, $this->config);
				return $new->getTable();
				break;
			case 'sparkline':
				$new = new Sparkline($this->data, $this->config);
				return $new->getSparkline();
				break;
			case 'scatter':
				$new = new Scatter($this->data, $this->config);
				return $new->getScatter();
				break;
			case 'tagcloud':
				$new = new Tagcloud($this->data, $this->config);
				return $new->getTagcloud();
				break;
		}
	
		/*		
		$new = new Pie($this->data, $this->config);
			
		return $new->getPie();
		
		return VectualGraph::newGraph($this->type,$this->data)
			->methode()
			->methode()
		
		newGraph($type,$data) {
			return new $type($data);
		}
		*/
	}	
	

	private function getDefs(){
		
		$var =
		'<defs>
			<linearGradient id="rect_background" x1="0%" y1="0%" x2="0%" y2="100%">
				<stop offset="0%" style="stop-color:rgb(80,80,80); stop-opacity:1"/>
				<stop offset="100%" style="stop-color:rgb(40,40,40); stop-opacity:1"/>
			</linearGradient>
			
			<filter id="dropshadow" >
			 <feGaussianBlur in="SourceAlpha" stdDeviation="0.5" result="blur"/>
			 <feOffset in="blur" dx="2" dy="2" result="offsetBlur"/>
			 <feComposite in="SourceGraphic" result="origin"/>
			</filter>	
		</defs>';
		
		return $var;
	}
	
	private function getStyle(){
		$style = '';
		
		if($this->standalone){
			$style .= '<style>';
			$style .= file_get_contents('vectual.css', true);
			$style .= '</style>';
		}
		
		return $style;
	}
	
	
	private function getBackground(){
	
		$background =
		'<rect class="vectual_background" x="0" y="0" rx="14" ry="14" height="'.$this->height.'" width="'.$this->width.'" />';
		
		$background .=
		'<text class="vectual_title" x="'.(20).'" y="'.(10 + $this->height * 0.05).'" 
			style="font-size:'.($this->height * 0.05).'px" >
				'.$this->title.'
		</text>';
		
		return $background;
	}
	
	
	private function getToolbar(){
			
		$toolbar =
		'<g class="toolbar_container" transform="translate('.($this->width - 120).', '.($this->width * 0.02).') scale(0.7)">';
		  
			if(in_array('save', $this->toolbarObjects)){
				$toolbar .=
				'<g id="tb_save" class="tb_icon" >'.
					//'<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="136" y="0" />'.					
					
						'<rect width="19" height="20" rx="2" ry="2" x="142.7316" y="5.9011221" style="fill:#454545;stroke:#ffffff;stroke-width:0.5;stroke-linecap:square;stroke-linejoin:round;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />
						<path d="m 159.0588,16.476599 h -13.65441 c -0.0634,0 -0.11448,-0.04035 -0.11448,-0.09007 V 7.896831 c 0,-0.049721 0.0511,-0.090074 0.11448,-0.090074 h 13.65441 c 0.0632,0 0.11448,0.040353 0.11448,0.090074 v 8.489694 c 0,0.0499 -0.0513,0.09007 -0.11448,0.09007 z" style="fill:#e9e9e9;" />
						<path d="m 156.68324,24.37299 h -8.90329 c -0.063,0 -0.11448,-0.0456 -0.11448,-0.101771 v -5.518061 c 0,-0.05617 0.0515,-0.101772 0.11448,-0.101772 h 8.90329 c 0.0632,0 0.11448,0.0456 0.11448,0.101772 v 5.518061 c 0,0.05618 -0.0513,0.101771 -0.11448,0.101771 z" style="fill:#e9e9e9;" />
						<rect width="2.2575331" height="4.4934235" x="-150.88783" y="-23.713919" transform="scale(-1,-1)" id="rect35" style="fill:#454545;" />
				 
					<title>Save as</title>				
				</g>';
			}
		 
			if(in_array('tagcloud', $this->toolbarObjects)){	
			 	$toolbar .='
				<g id="tb_tagcloud" class="tb_icon" transform="translate(34,0)">'.
					//'<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="34" y="0" />'.
					
					'<path d="m 44.484333,11.830359 c -0.83981,-5.1873037 7.79278,-6.6798578 9.29084,-1.763225 2.10842,-3.0856981 7.12759,-0.5548055 5.28968,2.644839 8.266717,-0.869341 3.76928,13.849527 -4.5437,7.866696 -0.98881,4.935602 -8.33223,5.230588 -9.69774,0.339083 -9.09882,3.732464 -11.43494,-11.698971 -0.33908,-9.087393 z" style="fill:#00b3ff;fill-opacity:1;stroke:#ffffff;stroke-width:0.5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />
					
					<title>Tagcloud</title>		
				</g>';
			}
		 
			if(in_array('bar', $this->toolbarObjects)){		
				$toolbar .=
				'<g id="tb_bar" class="tb_icon" transform="translate(0,0)">'.
					//'<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="0" y="0" />'.
					
					'<g transform="translate(-34,-0)">
						<rect width="5" height="10" x="40" y="16" style="fill:#00ff00;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />
						<rect width="5" height="20" x="47" y="6" style="fill:#00b3ff;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />
						<rect width="5" height="15" x="54" y="11" style="fill:#ff5100;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none" />
					</g>
					 
					<title>Bar Chart</title> 			 
				</g>';
			}
		 
			if(in_array('table', $this->toolbarObjects)){		
				$toolbar .=
				'<g id="tb_table" class="tb_icon" transform="translate(0,0)">'.
					//'<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="102" y="0" />'.
					
					'<g style="fill:#969696;" >
						<rect width="21" height="20" x="107.5" y="6" style="fill:#ffffff;" /> 
						<rect width="6.1537666" height="3.8361776" x="108" y="12.456996" />
						<rect width="6.1537666" height="3.8361776" x="114.9233" y="12.456996" />
						<rect width="6.1537666" height="3.8361776" x="121.84623" y="12.456996" />
						<rect width="6.1537666" height="3.8361776" x="121.84623" y="17.06041" />
						<rect width="6.1537666" height="3.8361776" x="114.9233" y="17.06041" />
						<rect width="6.1537666" height="3.8361776" x="108" y="17.06041" /> 
						<rect width="6.1537666" height="3.8361776" x="108" y="21.663818" />
						<rect width="6.1537666" height="3.8361776" x="114.9233" y="21.663818" />
						<rect width="6.1537666" height="3.8361776" x="121.84623" y="21.663818" />
						<rect width="19.999752" height="5.0300002" x="108" y="6.5999999" style="fill:#00ff00;" />
				 	</g>
					 
					<title>Table</title> 
				</g>';
			}
		 
			if(in_array('map', $this->toolbarObjects)){		
				$toolbar .=
				'<g id="tb_map" class="tb_icon" transform="translate(-34,0)">'.
					//'<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="68" y="0" />'.		
					
					'<g transform="translate(1.6642137,2.4196318)">
						<path d="m 85.5,-33.625 a 10.75,9.125 0 1 1 -21.5,0 10.75,9.125 0 1 1 21.5,0 z" transform="matrix(0.56611967,0,0,0.6669355,40.268341,32.511492)" style="fill:#ff0000;" />
						<path d="m 85.5,-33.625 a 10.75,9.125 0 1 1 -21.5,0 10.75,9.125 0 1 1 21.5,0 z" transform="matrix(0.18870656,0,0,0.22231183,68.479971,17.561021)" style="fill:#454545;" />
						<path d="M 75.861678,2.8120878 70.622292,11.886971 65.382905,2.8120878 z" transform="matrix(1.0292432,0,0,1.0745625,9.898273,9.8874433)" style="fill:#ff0000;" />
					 </g>
					 
					 <title>Map</title> 
				</g>';
			}
		 
			if(in_array('pie', $this->toolbarObjects)){		
				$toolbar .=
				'<g id="tb_pie" class="tb_icon" transform="translate(0,0)">'.
				 //'.<rect class="toolbar_box" width="32" height="32" rx="4" ry="4" x="-34" y="0" />'.
				 
					'<g transform="translate(-33.75,-0.25)" id="g4232">
						<path d="M 16,16 5.267152,16 a 10.732848,10.732848 0 0 0 2.049792,6.30861 z" style="fill:#00ff00;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-dasharray:none" />
						<path d="m 16,16 -8.683056,6.30861 a 10.732848,10.732848 0 0 0 11.999688,3.898935 z" style="fill:#ffff00;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-dasharray:none" />
						<path d="m 16,16 3.316632,10.207545 A 10.732848,10.732848 0 0 0 24.683056,9.6913903 z" style="fill:#ff5100;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-dasharray:none" />
						<path d="M 16,16 24.683056,9.6913903 A 10.732848,10.732848 0 0 0 5.267152,16 z" style="fill:#ff0000;stroke:#ffffff;stroke-width:0.5;stroke-miterlimit:4;stroke-dasharray:none" />
					</g>
					 
					<title>Pie Chart</title>	 
				</g>';
			}
			
			$toolbar .= '</g>';
			
			return $toolbar;
		}
		
}


?>