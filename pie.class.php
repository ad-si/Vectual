<?php

class pie extends VectualGraph {

	private $radius;
	private $startx = 0.5 * $this->graphWidth;
	private $starty = 0.5 * $this->graphHeight;
	private $angle = 0;
	private $lastx = -$radius;
	private $lasty = 0;
	private $pie;
	private $angle_all;
	private $angle_all_last;
	private $this
	
	
	function __construct($v){
		parent::__construct();
		$this->radius = (empty($v['radius']))?(min($this->graphHeight,$this->graphWidth * 0.33): $v['radius'];
		$this->pie = '';
		$this->angle_all;
	}
	
	public function getPie(){
		return $this->compilePie();
	}
	
	private function compilePie(){
	
		$this->pie .= 
		'<g transform="translate('.$this->startx.', '.$this->starty.')" >';

	
		if ($this->total == $this->maxValue){ //only one value
	
			$this->pie .= 	
			'<circle class="vectual_pie_sector" cx="0" cy="0" r="'.$this->radius.'" fill="'.Vectual::$color[$index_max].'" />'.
			'<text class="vectual_pie_text_single, vectual_pie_text" x="0" y="0" style="font-size:'.($this->radius * 0.3).'px;"
				text-anchor="middle" stroke-width="'.($this->radius * 0.006).'">
				'.$this->sortedKeys[$index_max]. 
			'</text>';
		
		}else{												
			for($i=0; $i < $numKeys; $i++){ //Pie sectors
				$this->drawSector($i);	
			}	
		}
		
		$this->pie .= 
		'</g>';
	}
	
	private function drawSector($i){	
	
		$this->angle_all_last = $this->angle_all;
		
		if((($this->sortedValues[$i]/$this->total) * 360) > 180) $size = '0 1,0';
		else $size = '0 0,0';
		
		//Shift direction: add previous angle to half of the current
		$angle_add = (($sorted[1]["value"][$i]/$total) * 360)/2;
		$angle_translate_deg = $angle_all_last + $angle_add;
		$angle_translate = deg2rad($angle_translate_deg);
		
		$tx = -(cos($angle_translate)) * $radius;
		$ty = (sin($angle_translate)) * $radius;
		
		//Angle
		$this->angle_all_last = $this->angle_all;
		$angle_this = (($this->sortedValues[$i]/$this->total) * 360);
		$this->angle_all = $angle_this + $this->angle_all;
		$angle_rad = deg2rad($this->angle_all);
		
		$this->nextx = -(cos($angle_rad) * $radius);
		$this->nexty = (sin($angle_rad) * $radius);
		
						
		$this->pie .=
			'<g id="vectual_pie_sector">	
				<path class="vectual_pie_sector_path" style="stroke-width:'.($radius * 0.015).';fill:'.$color[$i].';" 
					d="M 0,0 L '.$this->lastx.','.$this->lasty.' A '.$radius.','.$radius.' '.$size.' '.$this->nextx.','.$this->nexty.' z"
					transform="rotate('.$this->angle_all_last.',0,0)" >'.
	
					'<animate attributeName="opacity" to="1" dur="0.6s" fill="freeze"/>'.
										
					'<animateTransform attributeName="transform" type="rotate" dur="1s"
						calcMode="spline" keySplines="0 0 0 1" values="'.$angle_all_last.',0,0; 0,0,0" additive="replace" fill="freeze" />									
				</path>'.
			
			
				'<text class="vectual_pie_text" x="'.($tx * 1.2).'" y="'.($ty * 1.2).'" ';
					
					if($angle_translate_deg <= 75) $pie .='text-anchor="end" ';
					if($angle_translate_deg > 75 && $angle_translate_deg <= 105) $pie .='text-anchor="middle" ';
					if($angle_translate_deg > 105 && $angle_translate_deg <= 255) $pie .='text-anchor="start" ';
					if($angle_translate_deg > 255 && $angle_translate_deg <= 285) $pie .='text-anchor="middle" ';
					if($angle_translate_deg > 285 && $angle_translate_deg <= 360) $pie .='text-anchor="end" ';
	
					
					
				$pie .='style="font-size:'.($angle_this * $radius * 0.002 + 8).'px;"
					fill="'.Vectual::$color[$i].'" '.
					'transform="translate(0, 5)"'.
					' > '.						
							$sortedKeys[$i]
						.'<animate attributeName="opacity" begin="0.5s" from="0" to="1" dur="0.4s" additive="replace" fill="freeze"/>				
				</text>'.
				
				'<title>'
					.$sortedKeys[$i].'  |  '
					.$sortedValues[$i].'  |  '
					.(round($sortedValues[$i]/$this->total * 100, 2) ).'%'.						
				'</title>'.
				
						//move pie segment on mouseover
						'<animateTransform attributeName="transform" type="translate" to="'.($tx * 0.2).', '.($ty * 0.2).'"
							dur="0.3s" begin="mouseover" additive="replace" fill="freeze" />'.	
						
						//move back on mouseout
						'<animateTransform attributeName="transform" type="translate" to="0,0" dur="0.3s" begin="mouseout"
							additive="replace" fill="freeze" />'.		  				
			'</g>';
		
		$this->lastx = $this->nextx;	
		$this->lasty = $this->nexty;
	}	
}

?>