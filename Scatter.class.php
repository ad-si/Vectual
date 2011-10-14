	if($this->type] == 'scatter'){ //horizontal loop scatter
			for($i=0; $i<=$range_x*$density_x; $i++) 
			{ 		
			
				$this->coordinate .= '<line class="'; 
				
				if($i==0) $this->coordinate .= 'vectual_coordinate_axis_y';
				else $this->coordinate .= 'vectual_coordinate_lines_y';
				
				$this->coordinate .='
				" x1="'.(($width/$range_x)*($i/$density_x)).'" y1="'.-$height.'"
				x2="'.(($width/$range_x)*($i/$density_x)).'" y2="5" />';

				$this->coordinate .=
				'<text class="vectual_coordinate_labels_x" transform="rotate(40 '.(($width/$range_x)*($i/$density_x)).', 10)" 
					x="'.(($width/$range_x)*($i/$density_x)).'" y="10">
					'.(($i/$density_x) + $min_key).'
				</text>';
			}
			
			
<?php

class scatter extends CoordinateSystem{


	$scatter ='<g filter="url(#dropshadow)">';
		
		for($i=0; $i < $num; $i++){			

				$scatter .=
				'<circle filter="url(#dropshadow)" class="vectual_scatter_dot" r="50"
					cx="'.(($v["data"][1]["key"][$i] - $min_key) * ($width/$range_x)).'"
					cy="'.(-($v["data"][1]["value"][$i] - $min_value) * ($height/$range_y)).'">'.
					
					'<animate attributeName="r" to="5" begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="opacity" attributeType="CSS" begin="0s" to="0.5" dur="0.8s" additive="replace" fill="freeze"/>'.
					
					'<animate attributeName="r" to="10" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="r" to="5" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.				
					
					'<title>'.$v["data"][1]["key"][$i].'  |  '.$v["data"][1]["value"][$i].'</title>'.
								
				'</circle>';				
		}
	
	$scatter .='</g>';	


}