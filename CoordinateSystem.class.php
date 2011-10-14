<?php

class CoordinateSystem extends VectualGraph{

	protected $density_y = 0.1; 
	protected $density_x = 0.2;
	protected $this->coordinate;
	
	function __construct($v){
		$this->coordinate = '';	
	}
	
	private function compileCoordinatesystem(){
			
		$range_y = $this->maxValue - $this->minValue;
		$range_x = $this->maxKey - $this->minKey;
				
		if(!empty($this->toolbar)) $translate_y = $this->height + 40; //space for toolbar
		else $translate_y = $this->height;
		
		$this->coordinate .=
		'<g transform="translate('.($this->graphWidth * 0.08).', '.$translate_y.')">';
		
		$this->coordinate .= '</g>';

		return $this->coordinate;
	
	}
	
	private function horizontalLoop(){	
						
		for($i=0; $i<$this->numValues; $i++){ //horizontal loop
			
			$this->coordinate .= 
			'<line class="'; 
			
			(($i==0) $this->coordinate .= 'vectual_coordinate_axis_y'; : $this->coordinate .= 'vectual_coordinate_lines_y';);
			
			$this->coordinate .=
			'" x1="'.(($this->graphWidth/$this->numValues)*$i).'" y1="5"
			x2="'.(($this->graphWidth/$this->numValues)*$i).'" y2="'.(-$this->graphHeight).'" />';
			
			$this->coordinate .=
			'<text class="vectual_coordinate_labels_x" transform="rotate(40 '.(($this->graphWidth/$this->numValues) * $i).', 10)" 
				x="'.(($this->graphWidth/$this->numValues) * $i).'" y="10">'.
					$this->data[1]["time"][$i].
			'</text>';
		}	
	}
	
	private function verticalLoop(){
		
		for($i=0; $i<=($range_y * $density_y); $i++){ //vertical loop

			$this->coordinate .= 
			'<line class="'; 
			
			(($i==0) ? $this->coordinate .= 'vectual_coordinate_axis_x'; : $this->coordinate .= 'vectual_coordinate_lines_x';);
			
			$this->coordinate .=
			'" x1="-5" y1="'.(-($this->graphHeight/$range_y)*($i/$density_y)).'"
			x2="'.$this->graphWidth .'" y2="'.(-($this->graphHeight/$range_y)*($i/$density_y)).'" 
			/>';
			
			$this->coordinate .=
			'<text class="vectual_coordinate_labels_y" x="'.(-$v['width']*0.05).'" y="'.(-($this->graphHeight/$range_y)*($i/$density_y)).'" >
				'.(($i/$density_y) + $this->minValue).'
			</text>';
		}	
		
	}       	    		

?>