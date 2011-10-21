<?php

class CoordinateSystem extends VectualGraph{

	protected $density_y = 0.1; 
	protected $density_x = 0.2;
	
	protected $xRange;
	protected $yRange;
	
	protected $var;
	
	
	function __construct($data, $config){
		parent::__construct($data, $config);
		
		$this->xRange = $this->maxKey - $this->minKey;
		$this->yRange = $this->maxValue - $this->minValue;
			
	}
	
	protected function getCoordinatesystem(){
		return $this->compileCoordinatesystem;
	}
	
	protected function compileCoordinatesystem(){
				
		((!empty($this->toolbar)) ? ($translate_y = $this->height + 40) : ($translate_y = $this->height));
		
		$var =
		'<g transform="translate('.($this->graphWidth * 0.08).', '.$translate_y.')">';
		
		$var .= $this->horizontalLoop();
		$var .= $this->verticalLoop();
		
		$var .= 
		'</g>';

		return $var;
	}
	
	private function horizontalLoop(){	
						
		for($i=0; $i<$this->numValues; $i++){ //horizontal loop
			
			$var .= 
			'<line class="'; 
			
			(($i==0) ? $var .= 'vectual_coordinate_axis_y' : $var .= 'vectual_coordinate_lines_y');
			
			$var .=
			'" x1="'.(($this->graphWidth/$this->numValues)*$i).'" y1="5"
			x2="'.(($this->graphWidth/$this->numValues)*$i).'" y2="'.(-$this->graphHeight).'" />';
			
			$var .=
			'<text class="vectual_coordinate_labels_x" transform="rotate(40 '.(($this->graphWidth/$this->numValues) * $i).', 10)" 
				x="'.(($this->graphWidth/$this->numValues) * $i).'" y="10">'.
					$this->data[1]["time"][$i].
			'</text>';
		}
		
		return $var;
	}
	
	private function verticalLoop(){
		
		for($i=0; $i<=($this->yRange * $this->density_y); $i++){ //vertical loop

			$var .= 
			'<line class="'; 
			
			(($i==0) ? $var .= 'vectual_coordinate_axis_x' : $var .= 'vectual_coordinate_lines_x');
			
			$var .=
			'" x1="-5" y1="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'"
			x2="'.$this->graphWidth .'" y2="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" 
			/>';
			
			$var .=
			'<text class="vectual_coordinate_labels_y" x="'.(-$v['width']*0.05).'" y="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" >
				'.(($i/$this->density_y) + $this->minValue).'
			</text>';
		}
		
		return $var;	
	} 
}      	    		

?>