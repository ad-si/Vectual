<?php

// NOT UPDATED YET
			
class Scatter extends CoordinateSystem{

	public function getScatter(){
		
		((!empty($this->toolbar)) ? ($translate_y = $this->height) : ($translate_y = $this->height-40));
		
		$var =
		'<g transform="translate('.($this->graphWidth * 0.08).', '.$translate_y.')">';
		
		$var .= $this->getCoordinatesystem();		
		$var .= $this->getDots();	
		
		$var .= '</g>';
		
		return $var;	
	}

	public function getDots(){
	
		$scatter ='<g filter="url(#dropshadow)">';
		
		for($i=0; $i < $this->numValues; $i++){			

				$scatter .=
				'<circle filter="url(#dropshadow)" class="vectual_scatter_dot" r="50"
					cx="'.(($this->data[1]["key"][$i] - $this->minKey) * ($this->width/$this->xRange)).'"
					cy="'.(-($this->data[1]["value"][$i] - $this->minValue) * ($this->height/$this->yRange)).'">'.
					
					'<animate attributeName="r" to="5" begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="opacity" attributeType="CSS" begin="0s" to="0.5" dur="0.8s" additive="replace" fill="freeze"/>'.
					
					'<animate attributeName="r" to="10" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="r" to="5" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.				
					
					'<title>'.$this->data[1]["key"][$i].'  |  '.$this->data[1]["value"][$i].'</title>'.
								
				'</circle>';				
		}
	
		$scatter .='</g>';
		
		return $scatter;
	}
	
	
	public function getCoordinatesystem(){
		$var = $this->horizontalLoop();
		$var .= $this->verticalLoop();

		return $var;
	}
	
	private function horizontalLoop(){
		
		$var = '';
		
		for($i=0; $i<=$this->xRange * $this->density_x; $i++) 
		{ 		
		
			$var .= '<line class="'; 
			
			$var .= (($i==0) ? 'vectual_coordinate_axis_y' : 'vectual_coordinate_lines_y');
			
			$var .=
			'" x1="'.(($this->width/$this->xRange)*($i/$this->density_x)).'" y1="'.-$this->height.'"
			x2="'.(($this->width/$this->xRange)*($i/$this->density_x)).'" y2="5" />';

			$var .=
			'<text class="vectual_coordinate_labels_x" transform="rotate(40 '.(($this->width/$this->xRange) * ($i/$this->density_x)).', 10)" 
				x="'.(($this->width/$this->xRange)*($i/$this->density_x)).'" y="10">
				'.(($i/$this->density_x) + $this->minKey).'
			</text>';
		}	
		
		return $var;
	}
	
	private function verticalLoop(){
		$var = '';
		
		for($i=0; $i<=($this->yRange * $this->density_y); $i++){ //vertical loop

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