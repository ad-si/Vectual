<?php
			
class Scatter extends VectualGraph{

	private $scatter;
	private $group;
	
	private $yDensity; 
	private $xDensity;

	function __construct($data, $config, $svg){
		parent::__construct($data, $config, $svg);
		
		
		$this->yDensity = 0.1; 
		$this->xDensity = 0.2 / $this->xRange;

		$this->scatter = $svg->addChild('g');
	}

	public function setScatter(){
		
		!empty($this->toolbar) ? $yTranslate = ($this->height - 40) : $yTranslate = ($this->height - 40);
		
		$this->scatter->addAttribute('transform','translate('.($this->graphWidth * 0.08).', '.$yTranslate.')');
		
		$this->horizontalLoop();
		$this->verticalLoop();
			
		$this->group = $this->scatter->addChild('g');				
		$this->setDots();	
	}


private function setDots(){
		
		for($i=0; $i < $this->numValues; $i++){
		
			$circle = $this->group->addChild('circle');
				$circle->addAttribute('class','vectual_scatter_dot');
				$circle->addAttribute('filter','url(#dropshadow)');
				$circle->addAttribute('r','50');
				$circle->addAttribute('cx', ($this->keys[$i] - $this->minKey) * ($this->graphWidth/$this->xRange));
				$circle->addAttribute('cy', -($this->values[$i] - $this->minValue) * ($this->graphHeight/$this->yRange));
				
				$title = $circle->addChild('title', $this->keys[$i].' | '.$this->values[$i]);
				
				
				if($this->animations){
					$a = $circle->addChild('animate');
						$a->addAttribute('attributeName','opacity');
						$a->addAttribute('begin', '0s');
						$a->addAttribute('values', '0;0.8');
						$a->addAttribute('dur', 0.8);
						$a->addAttribute('additive','replace');
						$a->addAttribute('fill','freeze');
						
					$d = $circle->addChild('animate');
						$d->addAttribute('attributeName','r');
						$d->addAttribute('to','5');
						$d->addAttribute('dur','0.8s');
						$d->addAttribute('fill','freeze');
						
					$b = $circle->addChild('animate');
						$b->addAttribute('attributeName','r');
						$b->addAttribute('to','10');
						$b->addAttribute('dur','0.1s');
						$b->addAttribute('begin','mouseover');
						$b->addAttribute('additive','replace');
						$b->addAttribute('fill','freeze');	
						 
					$c = $circle->addChild('animate');
						$c->addAttribute('attributeName','r');
						$c->addAttribute('to','5');
						$c->addAttribute('dur','0.2s');
						$c->addAttribute('begin','mouseout');
						$c->addAttribute('additive','replace');
						$c->addAttribute('fill','freeze');
				}
		}
	}
	
	private function verticalLoop(){
		for($i=0; $i<=($this->yRange * $this->yDensity); $i++){
			
			 $var = ($i==0) ? 'vectual_coordinate_axis_x' : 'vectual_coordinate_lines_x';
			
			$line = $this->scatter->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', '-5');
				$line->addAttribute('y1', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));
				$line->addAttribute('x2', $this->graphWidth);
				$line->addAttribute('y2', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));
				
			$text = $this->scatter->addChild('text', ($i/$this->yDensity) + $this->minValue);
				$text->addAttribute('class','vectual_coordinate_labels_y');
				$text->addAttribute('x', -$this->graphWidth * 0.05);
				$text->addAttribute('y', -($this->graphHeight/$this->yRange)*($i/$this->yDensity));												
		}
	} 
	
	private function horizontalLoop(){
		for($i=0; $i<=($this->xRange * $this->xDensity); $i++){
			
			$var = ($i==0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y';
			
			$line = $this->scatter->addChild('line');
				$line->addAttribute('class', $var);
				$line->addAttribute('x1', ($this->graphWidth/$this->xRange) * ($i/$this->xDensity));
				$line->addAttribute('y1', -$this->graphHeight);
				$line->addAttribute('x2', ($this->graphWidth/$this->xRange) * ($i/$this->xDensity));
				$line->addAttribute('y2', 5);
				
			$text = $this->scatter->addChild('text', ($i/$this->xDensity) + $this->minKey);
				$text->addAttribute('class','vectual_coordinate_labels_x');
				$text->addAttribute('transform', 'rotate(40 '.(($this->graphWidth/$this->xRange) * ($i/$this->xDensity)).', 10)');
				$text->addAttribute('x', ($this->graphWidth/$this->xRange)*($i/$this->xDensity));
				$text->addAttribute('y', 10);												
		}
	}
}