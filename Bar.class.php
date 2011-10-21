<?php

class Bar extends VectualGraph {

	protected $density_y = 0.1; 
	protected $density_x = 0.2;
	
	protected $xRange;
	protected $yRange;

	function __construct($data, $config){
		parent::__construct($data, $config);		
	}
	
	public function getBargraph(){
		
		((!empty($this->toolbar)) ? ($translate_y = $this->height) : ($translate_y = $this->height-40));
		
		$var =
		'<g transform="translate('.($this->graphWidth * 0.08).', '.$translate_y.')">';
		
		$var .= $this->getCoordinatesystem();		
		$var .= $this->getBar();	
		
		$var .= '</g>';
		
		return $var;	
	}
		
	public function getBar(){		
		$bar = '';
		
		for($i=0; $i<$this->numValues; $i++){	
			$bar .= $this->buildBar($i);			
		}
		
		return $bar;	
	}
		
	public function getCoordinatesystem(){
		$var = $this->horizontalLoop();
		$var .= $this->verticalLoop();

		return $var;
	}
	
	private function buildBar($i){
	
			/*dropshadow for safari
			$bar .=
			'<rect transform="translate(3,3), scale(1,-1)" style="opacity:0; fill:black;"
				x="'.($i * ($width/$num)).'" y="0"
				height="0" width="'.(0.7 *($width/$num)).'" >'.
				
					'<animate attributeName="height" to="'.(($v["data"][1]["value"][$i]-$min_value) * ($height/$range_y)).'"		
						begin="0" dur="0.8s" fill="freeze" />
					<animate attributeName="opacity" begin="0s" to="0.4" dur="0.8s" additive="replace" fill="freeze"/>'.
						
			'</rect>';*/
			
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
	}
	
	
	private function horizontalLoop(){	
	
		$var = '';
						
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
					$this->keys[$i].
			'</text>';
		}
		
		return $var;
	}
	
	private function verticalLoop(){
	
		$var = '';
		
		for($i=0; $i<=($this->yRange * $this->density_y); $i++){

			$var .='<line class="'; 
			
			(($i==0) ? $var .= 'vectual_coordinate_axis_x' : $var .= 'vectual_coordinate_lines_x');
			
			$var .=
			'" x1="-5" y1="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'"
			x2="'.$this->graphWidth .'" y2="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" />';
			
			$var .=
			'<text class="vectual_coordinate_labels_y" x="'.(-$this->graphWidth * 0.05).'" y="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" >
				'.(($i/$this->density_y) + $this->minValue).'
			</text>';
		}
		
		return $var;	
	} 
}

?>