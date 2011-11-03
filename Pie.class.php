<?php

class Pie extends VectualGraph {
	private $pie;
	
	private $radius;
	private $startx;
	private $starty;
	private $angle;
	private $lastx;
	private $lasty;
	private $angle_all;
	private $angle_all_last;
	
	
	function __construct($data, $config, $svg){
	
		parent::__construct($data, $config, $svg);
		
		$this->radius = ((empty($config['radius'])) ? min($this->graphHeight,$this->graphWidth * 0.2) : $config['radius']);
		
		$this->startx = (0.5 * $this->width);
		$this->starty = (0.5 * $this->height);
		$this->angle = 0;
		$this->lastx = -$this->radius;
		$this->lasty = 0;
		
		$this->pie = $svg->addChild('g');
	}
	
	public function setPie(){
	
		$this->pie->addAttribute('transform', 'translate('.$this->startx.', '.$this->starty.')');

	
		if ($this->totalValue == $this->maxValue){ //only one value
	
			$circle = $this->pie->addChild('circle');
				$circle->addAttribute('class','vectual_pie_sector');
				$circle->addAttribute('cx','0');
				$circle->addAttribute('cy','0');
				$circle->addAttribute('r', $this->radius);
				$circle->addAttribute('fill', $this->color[$index_max]);
				
			$circle = $this->pie->addChild('text', $this->sortedKeys[$index_max]);	
				$circle->addAttribute('class','vectual_pie_text_single, vectual_pie_text');
				$circle->addAttribute('x','0');
				$circle->addAttribute('y','0');
				$circle->addAttribute('style','font-size:'.($this->radius * 0.3).'px');
				$circle->addAttribute('text-anchor','middle');
				$circle->addAttribute('stroke-width',($this->radius * 0.006));
		
		}else{												
			for($i=0; $i < $this->numKeys; $i++){ //Pie sectors
				$this->drawSector($i);	
			}	
		}
	}
	
	private function drawSector($i){	
	
		$this->angle_all_last = $this->angle_all;
		
		if((($this->sortedValues[$i]/$this->totalValue) * 360) > 180) $size = '0 1,0';
		else $size = '0 0,0';
				
		//Angle
		$this->angle_all_last = $this->angle_all;
		$angle_this = (($this->sortedValues[$i]/$this->totalValue) * 360);
		$this->angle_all = $angle_this + $this->angle_all;
		$angle_rad = deg2rad($this->angle_all);
		
		//Shift direction: add previous angle to half of the current
		$angle_add = $angle_this/2;
		$angle_translate_deg = $this->angle_all_last + $angle_add;
		$angle_translate = deg2rad($angle_translate_deg);
	
		$tx = -(cos($angle_translate)) * $this->radius;
		$ty = (sin($angle_translate)) * $this->radius;
		
		$this->nextx = -(cos($angle_rad) * $this->radius);
		$this->nexty = (sin($angle_rad) * $this->radius);
		
		if($angle_translate_deg > 0   && $angle_translate_deg <= 75 ) $position = 'end';
		if($angle_translate_deg > 75  && $angle_translate_deg <= 105) $position = 'middle';
		if($angle_translate_deg > 105 && $angle_translate_deg <= 255) $position = 'start';
		if($angle_translate_deg > 255 && $angle_translate_deg <= 285) $position = 'middle';
		if($angle_translate_deg > 285 && $angle_translate_deg <= 360) $position = 'end';
		
		$xValues = -(cos($angle_translate) * $this->radius);
		$yValues = (sin($angle_translate) * $this->radius);

		
		$sector = $this->pie->addChild('g');
			$sector->addAttribute('class', 'vectual_pie_sector');
		
				if($this->animations){	
					$at = $sector->addChild('animateTransform');
						$at->addAttribute('attributeName', 'transform');
						$at->addAttribute('begin', 'mouseover');
						$at->addAttribute('type', 'translate');
						$at->addAttribute('to', ($tx * 0.2).', '.($ty * 0.2));
						$at->addAttribute('dur', '0.3s');
						$at->addAttribute('additive', 'replace');
						$at->addAttribute('fill', 'freeze');
						
					$atra = $sector->addChild('animateTransform');
						$atra->addAttribute('attributeName', 'transform');
						$atra->addAttribute('begin', 'mouseout');
						$atra->addAttribute('type', 'translate');
						$atra->addAttribute('to', '0,0');
						$atra->addAttribute('dur', '0.3s');
						$atra->addAttribute('additive', 'replace');
						$atra->addAttribute('fill', 'freeze');
				}
			
			$path = $sector->addChild('path');
				$path->addAttribute('class', 'vectual_pie_sector_path');
				$path->addAttribute('style', 'stroke-width:'.($this->radius * 0.015).';fill:'.$this->color[$i]);
				$path->addAttribute('d', 'M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$this->nextx.','.$this->nexty.' z');
				$path->addAttribute('transform', '');
				
				
				if($this->animations){
					$ani = $path->addChild('animate');
						$ani->addAttribute('attributeName','opacity');
						$ani->addAttribute('from','0');
						$ani->addAttribute('to','1');
						$ani->addAttribute('dur','0.6s');
						$ani->addAttribute('fill','freeze');
	
					$aniTransform = $path->addChild('animateTransform');
						$aniTransform->addAttribute('attributeName','transform');
						$aniTransform->addAttribute('type','rotate');
						$aniTransform->addAttribute('dur','0.8s');
						//$aniTransform->addAttribute('calcMode','spline');
						//$aniTransform->addAttribute('keySplines','0 0 0 1');
						$aniTransform->addAttribute('values', $this->angle_all_last.',0,0; 0,0,0');
						$aniTransform->addAttribute('additive','replace');
						$aniTransform->addAttribute('fill','freeze');
					
					
					/*$fanOut = $path->addChild('animate');
						$fanOut->addAttribute('attributeName','d');
						//$fanOut->addAttribute('from','M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$this->lastx.','.$this->lasty.' z');
						//$fanOut->addAttribute('to','M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$this->nextx.','.$this->nexty.' z');
						$fanOut->addAttribute('values','M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$this->lastx.','.$this->lasty.' z; '.
						'M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$xValues.','.$yValues.' z; '.
						'M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$this->radius.','.$this->radius.' '.$size.' '.$this->nextx.','.$this->nexty.' z; ');
						$fanOut->addAttribute('dur','0.8s');
					*/
				}
				
				
			$text = $sector->addChild('text', $this->sortedKeys[$i]);
				$text->addAttribute('class', 'vectual_pie_text');
				$text->addAttribute('x', ($tx * 1.2));
				$text->addAttribute('y', ($ty * 1.2));
				$text->addAttribute('text-anchor', $position);
				$text->addAttribute('style', 'font-size:'.($angle_this * $this->radius * 0.002 + 8).'px');
				$text->addAttribute('fill', $this->color[$i]);
				$text->addAttribute('transform', 'translate(0, 5)');
				
				
				if($this->animations){
					$animate = $text->addChild('animate');
						$animate->addAttribute('attributeName','opacity');
						$animate->addAttribute('begin','0s');
						$animate->addAttribute('values','0;0;1');
						$animate->addAttribute('dur','0.9s');
						$animate->addAttribute('additive','replace');
						$animate->addAttribute('fill','freeze');
				}
						
			$title = $sector->addChild('title', $this->sortedKeys[$i].' | '.$this->sortedValues[$i].' | '.(round($this->sortedValues[$i]/$this->totalValue * 100, 2) ).'%');
		
		$this->lastx = $this->nextx;	
		$this->lasty = $this->nexty;
	}	
}

?>