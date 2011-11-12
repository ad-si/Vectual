<?php

class Line extends VectualGraph{

	private $line;
	private $group;
	
	private $yGridSpacing = 2; //px
	private $xGridSpacing = 0.2; //px

	function __construct($data, $config, $svg){
		parent::__construct($data, $config, $svg);
		
		$this->line = $svg->addChild('g');	
	}
	
	public function setLinegraph(){
			
		!empty($this->toolbar) ? $yTranslate = ($this->height - 40) : $yTranslate = ($this->height - 40);
		
		$this->line->addAttribute('transform','translate('.($this->graphWidth * 0.08).', '.$yTranslate.')');
		
		$this->setCoordinatesystem();	
		
		$this->group = $this->line->addChild('g');	
		$this->buildLine();
		$this->setDots();		
	}
	
	private function buildLine(){
			
		$points = '';
		for($i=0; $i < $this->numValues; $i++){
				 $points .= ($i * ($this->graphWidth/$this->numValues)).',0 ';
		}
		
		$pointsto = '';
		for($i=0; $i < $this->numValues; $i++){
			$pointsto .= 
			($i * ($this->graphWidth/$this->numValues)).','. //x
			((-$this->values[$i]+$this->minValue) * ($this->graphHeight/$this->yRange)).' '; //y
		}	
	
			$this->group->addAttribute('filter', 'url(#dropshadow)');
			
			$line = $this->group->addChild('polyline');
				$line->addAttribute('class', 'vectual_line_line');
				$line->addAttribute('points', $pointsto);
				
				if($this->animations){
					$a = $line->addChild('animate');
						$a->addAttribute('attributeName','points');
						$a->addAttribute('from', $points);
						$a->addAttribute('to', $pointsto);
						$a->addAttribute('begin','0s');
						$a->addAttribute('dur','0.8s');
						$a->addAttribute('fill','freeze');
						
					$b = $line->addChild('animate');
						$b->addAttribute('attributeName','opacity');
						$b->addAttribute('begin', '0s');
						$b->addAttribute('from','0');
						$b->addAttribute('to','1');
						$b->addAttribute('dur','0.8s');
						$b->addAttribute('additive','replace');
						$b->addAttribute('fill','freeze');
				}
	}
	
	private function setDots(){
		
		for($i=0; $i < $this->numValues; $i++){
		
			$circle = $this->group->addChild('circle');
				$circle->addAttribute('class','vectual_line_dot');
				$circle->addAttribute('r','4');
				$circle->addAttribute('cx', $i * ($this->graphWidth/$this->numValues));
				$circle->addAttribute('cy', (-$this->values[$i]+$this->minValue) * ($this->graphHeight/$this->yRange));
				
				$title = $circle->addChild('title', $this->keys[$i].':  '.$this->values[$i]);
				
				
				if($this->animations){
					$a = $circle->addChild('animate');
						$a->addAttribute('attributeName','opacity');
						$a->addAttribute('begin','0s');
						$a->addAttribute('values','0;0;1');
						$a->addAttribute('keyTimes','0.0;0.8;1');
						$a->addAttribute('dur','1s');
						$a->addAttribute('additive','replace');
						$a->addAttribute('fill','freeze');
						
					$b = $circle->addChild('animate');
						$b->addAttribute('attributeName','r');
						$b->addAttribute('to','8');
						$b->addAttribute('dur','0.1s');
						$b->addAttribute('begin','mouseover');
						$b->addAttribute('additive','replace');
						$b->addAttribute('fill','freeze');	
						
					$c = $circle->addChild('animate');
						$c->addAttribute('attributeName','r');
						$c->addAttribute('to','4');
						$c->addAttribute('dur','0.2s');
						$c->addAttribute('begin','mouseout');
						$c->addAttribute('additive','replace');
						$c->addAttribute('fill','freeze');
				}
		}
	}
	
	public function setCoordinatesystem(){
		$this->horizontalLoop();
		$this->verticalLoop();
	}
	
	private function horizontalLoop(){
	
		for($i=0; $i<$this->numValues; $i++){
			
			($i==0) ? $var = 'vectual_coordinate_axis_y' : $var = 'vectual_coordinate_lines_y';
			
			$line = $this->line->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', ($this->graphWidth/$this->numValues)*$i);
				$line->addAttribute('y1','5');
				$line->addAttribute('x2', ($this->graphWidth/$this->numValues)*$i);
				$line->addAttribute('y2', -$this->graphHeight);
				
			$text = $this->line->addChild('text', $this->keys[$i]);
				$text->addAttribute('class','vectual_coordinate_labels_x');
				$text->addAttribute('transform','rotate(40 '.(($this->graphWidth/$this->numValues) * $i).', 10)');
				$text->addAttribute('x', (($this->graphWidth/$this->numValues) * $i));
				$text->addAttribute('y','10');
														
		}
	}
	
	private function verticalLoop(){
	
		for($i=0; $i<=($this->graphHeight / $this->yGridSpacing); $i++){
			
			($i==0) ? $var = 'vectual_coordinate_axis_x' : $var = 'vectual_coordinate_lines_x';
			
			$line = $this->line->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', '-5');
				$line->addAttribute('y1', -($i * $this->yGridSpacing));
				$line->addAttribute('x2', $this->graphWidth);
				$line->addAttribute('y2', -($i * $this->yGridSpacing));
				
			$text = $this->line->addChild('text', $this->minValue + ($this->yRange/$this->graphHeight) * $i * $this->yGridSpacing);
				$text->addAttribute('class','vectual_coordinate_labels_y');
				$text->addAttribute('x', -$this->graphWidth * 0.05);
				$text->addAttribute('y', -($i * $this->yGridSpacing));
														
		}
	} 
}

?>
