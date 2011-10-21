<?php

class Sparkline extends Inline{

	function __construct($data, $config){
		parent::__construct($data, $config);		
	}

	public function getSparkline(){
		return $this->compileSparkline();
	}
	
	private function compileSparkline(){
	
		$sparkline = 
		'<g transform="translate(0, '.($this->height - 2).')" >'.
					
		'<rect class="vectual_background" x="0" y="'.-($this->height - 2).'" height="'.($this->height).'" width="'.($this->height * 3).'" />';
		
		$sparkline .= 
		//'<line x1="0" y1="5" x2="0" y2="-'.$this->height.'" style="stroke:rgb(200,200,200); stroke-width: 0.5"/>'. //y-axis
		'<line x1="0" y1="'.((0 + $this->minValue) * (($this->height - 4)/$this->yRange)).'" x2="'.($this->height * 3).'"
		y2="'.((0 + $this->minValue) * (($this->height - 4)/$this->yRange)).'" style="stroke:rgb(200,200,200); stroke-width: 0.5"/>'. //x-axis
		'';
		
		
		$sparkline .='
		<polyline class="vectual_inline_sparkline" points="';	
		
			for($i=0; $i < $this->numValues; $i++){
				$sparkline .=''.($i * (($this->height * 3)/$this->numValues)).','.((-$this->values[$i] + $this->minValue) * (($this->height - 4)/$this->yRange)).' ';
			}
					
			$sparkline .='" >
		</polyline>';
		
		
		$sparkline .= 
		'<circle class="vectual_inline_sparkline_max" r="1.5" cx="'.($this->maxValueIndex * (($this->height * 3)/$this->numValues)).'" 
			cy="'.((-$this->maxValue + $this->minValue) * (($this->height - 4) /$this->yRange)).'" />'. //Max value
		
		'<circle class="vectual_inline_sparkline_min" r="1.5" cx="'.($this->minValueIndex * (($this->height * 3)/$this->numValues)).'" 
			cy="'.((-$this->minValue + $this->minValue) * (($this->height- 4) /$this->yRange)).'" />'; //Max value
		
		$sparkline .= 
		'</g>';
		
		return $sparkline;
	
	}						
}

?>