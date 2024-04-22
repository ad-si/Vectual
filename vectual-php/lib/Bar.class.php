<?php

class Bar extends VectualGraph {
	
	private $bar;
	
	private $yDensity = 0.1; 
	private $xDensity = 0.2;

	function __construct($data, $config, $svg){
		parent::__construct($data, $config, $svg);
		
		$this->bar = $svg->addChild('g');		
	}
	
	public function setBargraph(){
			
		!empty($this->toolbar) ? $translate_y = $this->height : $translate_y = ($this->height - 40);
		
		$this->bar->addAttribute('transform','translate('.($this->graphWidth * 0.08).', '.$translate_y.')');
		
		$this->setCoordinatesystem();		
		$this->setBar();	
	}
		
	public function setBar(){
		
		for($i=0; $i<$this->numValues; $i++){	
			$this->buildBar($i);			
		}	
	}
		
	public function setCoordinatesystem(){
		$this->horizontalLoop();
		$this->verticalLoop();
	}
	
	private function buildBar($i){
	
		$bar = $this->bar->addChild('rect');
			$bar->addAttribute('filter','url(#dropshadow)');
			$bar->addAttribute('class','vectual_bar_bar');
			$bar->addAttribute('x', ($i * ($this->graphWidth/$this->numValues)));
			$bar->addAttribute('y', -($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange));
			$bar->addAttribute('height', ($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange));
			$bar->addAttribute('width', (0.7 * ($this->graphWidth/$this->numValues)));
			
			
			$title = $bar->addChild('title', $this->keys[$i].':  '.$this->values[$i]);
			
			if($this->animations == true){
				$a = $bar->addChild('animate');
					$a->addAttribute('attributeName','height');
					$a->addAttribute('from','0');
					$a->addAttribute('to', ($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange));
					$a->addAttribute('begin','0s');
					$a->addAttribute('dur','0.8s');
					$a->addAttribute('fill','freeze');
					
				$b = $bar->addChild('animate');
					$b->addAttribute('attributeName','y');
					$b->addAttribute('from','0');
					$b->addAttribute('to',- ($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange));
					$b->addAttribute('begin','0s');
					$b->addAttribute('dur','0.8s');
					$b->addAttribute('fill','freeze');
				
				$c = $bar->addChild('animate');
					$c->addAttribute('attributeName','opacity');
					$c->addAttribute('from', '0');
					$c->addAttribute('to', '0.8');
					$c->addAttribute('begin','0s');
					$c->addAttribute('dur','0.8s');
					$c->addAttribute('fill','freeze');
					$c->addAttribute('additive','replace');
					
				$d = $bar->addChild('animate');
					$d->addAttribute('attributeName','fill');
					$d->addAttribute('to', 'rgb(100,210,255)');
					$d->addAttribute('begin','mouseover');
					$d->addAttribute('dur','0.1s');
					$d->addAttribute('fill','freeze');
					$d->addAttribute('additive','replace');
					
				$e = $bar->addChild('animate');
					$e->addAttribute('attributeName','fill');
					$e->addAttribute('to', 'rgb(0,150,250)');
					$e->addAttribute('begin','mouseout');
					$e->addAttribute('dur','0.2s');
					$e->addAttribute('fill','freeze');
					$e->addAttribute('additive','replace');
			}
			
		/*
			$var =
			'<rect filter="url(#dropshadow)" class="vectual_bar_bar" style="opacity:0;"
				x="'.($i * ($this->graphWidth/$this->numValues)).'" y="0"
				height="0" width="'.(0.7 * ($this->graphWidth/$this->numValues)).'" >'.
				
				'<title>'.$this->keys[$i].':  '.$this->values[$i].'</title>'.
				
					'<animate attributeName="height" to="'.(($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange)).'"		
						begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="y" to="-'.(($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange)).'"		
						begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="opacity" begin="0s" to="0.8" dur="0.8s" additive="replace" fill="freeze"/>'.
					
					'<animate attributeName="fill" to="rgb(100,210,255)" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="fill" to="rgb(0,150,250)" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.
			'</rect>';
			
			return $var;
		*/
	}
	
	
	private function horizontalLoop(){
	
		for($i=0; $i<$this->numValues; $i++){
			
			($i==0) ? $var = 'vectual_coordinate_axis_y' : $var = 'vectual_coordinate_lines_y';
			
			$line = $this->bar->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', ($this->graphWidth/$this->numValues)*$i);
				$line->addAttribute('y1','5');
				$line->addAttribute('x2', ($this->graphWidth/$this->numValues)*$i);
				$line->addAttribute('y2', -$this->graphHeight);
				
			$text = $this->bar->addChild('text', $this->keys[$i]);
				$text->addAttribute('class','vectual_coordinate_labels_x');
				$text->addAttribute('transform','rotate(40 '.(($this->graphWidth/$this->numValues) * $i).', 10)');
				$text->addAttribute('x', (($this->graphWidth/$this->numValues) * $i));
				$text->addAttribute('y','10');
														
		}
	}
	
	private function verticalLoop(){
	
		for($i=0; $i<=($this->yRange * $this->yDensity); $i++){
			
			($i==0) ? $var = 'vectual_coordinate_axis_x' : $var = 'vectual_coordinate_lines_x';
			
			$line = $this->bar->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', '-5');
				$line->addAttribute('y1', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));
				$line->addAttribute('x2', $this->graphWidth);
				$line->addAttribute('y2', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));
				
			$text = $this->bar->addChild('text', ($i/$this->yDensity) + $this->minValue);
				$text->addAttribute('class','vectual_coordinate_labels_y');
				$text->addAttribute('x', -$this->graphWidth * 0.05);
				$text->addAttribute('y', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));
														
		}
	} 
}

?>