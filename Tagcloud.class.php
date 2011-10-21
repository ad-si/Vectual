<?php

class Tagcloud extends VectualGraph{


	function __construct($data, $config){
		parent::__construct($data, $config);
	}

	public function getTagcloud(){
	
		$cloud = '<g transform="translate('.(0.5 * $this->width).', '.(0.5 * $this->height).')">';
		$cloud .= $this->getSpiral();
		$cloud .= $this->compileTagcloud();
		$cloud .= '</g>';
		
		return $cloud;
	}
	
	public function compileTagcloud(){
	
		$until = 300; //size of spiral
		$faktor = 4; //resolution improvement
		$density = 0.05; //density of spiral
		$x_y_skew = 0.6; //elliptical shape of spiral (0 < $x_y_skew < 1)

		$a = 0; //Word counter
		$cloud = '';
		
		
		//Positioning along an archimedic spiral
		for($i=0; $i < ($until * $faktor * $density); $i++){
		
			$font_size = 10 + (($this->height * 0.1) * ($this->data[1]["value"][$a] - $this->minValue)) / ($this->maxValue - $this->minValue);
			
			$length = count($this->data[1]["key"][$a]) * $font_size;	
					
			//x and y values of the position to test
			$b = $i * (1/$faktor); 						
									
			$x = -(1/$density) * $x_y_skew * $b * cos($b);
			$y = -(1/$density) * (1-$x_y_skew) * $b * sin($b);
			
			$pos_x[$a] = $x;
			$pos_y[$a] = $y;
			$area_x[$a] = $length;
			$area_y[$a] = $font_size;	

			//Test if word covers one of the already printed
			for($u=0; $u<=$a; $u++){
		
				if($a == 0){
				
						$var =
						'<text class="vectual_tagcloud_text" style="font-size: '.$font_size.';" x="'.$x.'" y="'.$y.'" >'.	
							$this->data[1]["key"][$a].
						'</text>';
						
						$a++;
				}else{
					
					//x-value						
					if($pos_x[$a] < ($pos_x[$u] - $area_x[$a]) || $pos_x[$a] > ($pos_x[$u] + $area_x[$u])){ 
						
						//y-value
						if($pos_y[$a] < ($pos_y[$u] - $area_y[$a]) || $pos_y[$a] > ($pos_y[$u] + $area_y[$u])){ 
						
							$var =
							'<text class="vectual_tagcloud_text" style="font-size: '.$font_size.';" x="'.$x.'" y="'.$y.'" >'. 	
									$this->data[1]["key"][$a].
							'</text>';
							
							$a++;
							
						}
					}
				}
				
				if(isset($var)){
					$cloud .= $var;
					break;
				}
			}
		}
	}
		
	public function getSpiral(){
	
		$until = 300; //size of spiral
		$faktor = 4; //resolution improvement
		$density = 0.05; //density of spiral
		$x_y_skew = 0.6; //elliptical shape of spiral (0 < $x_y_skew < 1)

		$a = 0; //Word counter
		
		$spiral =
		'<polyline points="';
						
			for($j=0; $j < ($until * $faktor * $density); $j++){	
					$b = $j * (1/$faktor); 			
					
					$x = -(1/$density) * $x_y_skew * $b  * cos($b);
					$y = -(1/$density) * (1 - $x_y_skew) * $b  * sin($b);
					
					$spiral .=''.$x.','.$y.' ';  	
			}
			
			$spiral .='" style="fill: none; stroke:red; stroke-width:1" >
		</polyline>';
	
			
		$spiral .='</g>';
	
		return $spiral;
		
	}
}

?>