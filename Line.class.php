<?php

class Line extends VectualGraph{

	protected $density_y = 0.1; 
	protected $density_x = 0.2;
	
	protected $xRange;
	protected $yRange;

	function __construct($data, $config){
		parent::__construct($data, $config);	
	}
	
	public function getLinegraph(){
		
		((!empty($this->toolbar)) ? ($translate_y = $this->height) : ($translate_y = $this->height-40));
		
		$var =
		'<g transform="translate('.($this->graphWidth * 0.08).', '.$translate_y.')">';
		
		$var .= $this->getCoordinatesystem();		
		$var .= $this->getLine();	
		
		$var .= '</g>';
		
		return $var;	
	}
	
	public function getLine(){
		$var = '';
		
			$var .= $this->buildLine();
			$var .= $this->getDots();			
			
		return $var;
	}
	
	public function getCoordinatesystem(){
		$var = $this->horizontalLoop();
		$var .= $this->verticalLoop();

		return $var;
	}
	
	
	private function buildLine(){
		
		/*dropshadow for safari
		$line =
			'<polyline transform="translate(2,2)" points="';					
					for($i=0; $i < $num; $i++){$line .=''.($i * ($width/$num)).',0 ';}					
				$line .=
				'" style="opacity: 0; fill: none; stroke:black; stroke-width:3; stroke-linejoin: round;" >'.
				
				'<animate attributeName="points" to="';			
					for($i=0; $i < $num; $i++){			
							$line .=''.($i * ($width/$num)).','.((-$v["data"][1]["value"][$i]+$min_value) * ($height/$range_y)).' ';}		
				$line .=
				'" '.
				'begin="0" dur="0.8s" fill="freeze" />
				<animate attributeName="opacity" begin="0s" to="0.4" dur="0.8s" additive="replace" fill="freeze"/>'.
				
			'</polyline>';*/
		

		$line =
		'<g filter="url(#dropshadow)">'.
		'<polyline class="vectual_line_line" points="';								
				
			for($i=0; $i < $this->numValues; $i++){
				 $line .=''.($i * ($this->graphWidth/$this->numValues)).',0 ';
			}					
				
			$line .='" >'.
				
			'<animate attributeName="points" to="';			
			
				for($i=0; $i < $this->numValues; $i++){
					$line .=''.($i * ($this->graphWidth/$this->numValues)).','.((-$this->values[$i]+$this->minValue) * ($this->graphHeight/$this->yRange)).' ';
				}		
				
			$line .='" begin="0" dur="0.8s" fill="freeze" />
					
			<animate attributeName="opacity" begin="0s" to="1" dur="0.8s" additive="replace" fill="freeze"/>'.
			
		'</polyline>';
		
		return $line;
	}
	
	private function getDots(){
		$dots = '';
		
		for($i=0; $i < $this->numValues; $i++){
			
				$dots .=
				'<circle class="vectual_line_dot" r="4" 
					cx="'.($i * ($this->graphWidth/$this->numValues)).'"
					cy="'.((-$this->values[$i]+$this->minValue) * ($this->graphHeight/$this->yRange)).'" >'.
					
					'<animate attributeName="opacity" begin="0.8s" to="1" dur="0.5s" additive="replace" fill="freeze"/>'.
						
					'<animate attributeName="r" to="8" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="r" to="4" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.
					
					'<title>'.$this->keys[$i].':  '.$this->values[$i].'</title>'.
					
				'</circle>';			
		}
		
		return $dots;
	}
	
	private function horizontalLoop(){	
	
		$var = '';
						
		for($i=0; $i<$this->numValues; $i++){
			
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

			$var .= 
			'<line class="'; 
			
			(($i==0) ? $var .= 'vectual_coordinate_axis_x' : $var .= 'vectual_coordinate_lines_x');
			
			$var .=
			'" x1="-5" y1="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'"
			x2="'.$this->graphWidth .'" y2="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" 
			/>';
			
			$var .=
			'<text class="vectual_coordinate_labels_y" x="'.(-$this->graphWidth * 0.05).'" y="'.(-($this->graphHeight/$this->yRange)*($i/$this->density_y)).'" >
				'.(($i/$this->density_y) + $this->minValue).'
			</text>';
		}
		
		return $var;	
	} 
}

?>
