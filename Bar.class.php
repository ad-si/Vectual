<?php

class Bar extends CoordinateSystem {

	// Bar-----------------
		$bar = '';
		
		for($i=0; $i<$num; $i++){
				
			/*dropshadow for safari
			$bar .=
			'<rect transform="translate(3,3), scale(1,-1)" style="opacity:0; fill:black;"
				x="'.($i * ($width/$num)).'" y="0"
				height="0" width="'.(0.7 *($width/$num)).'" >'.
				
					'<animate attributeName="height" to="'.(($v["data"][1]["value"][$i]-$min_value) * ($height/$range_y)).'"		
						begin="0" dur="0.8s" fill="freeze" />
					<animate attributeName="opacity" begin="0s" to="0.4" dur="0.8s" additive="replace" fill="freeze"/>'.
						
			'</rect>';*/
			
			$bar .=
			'<rect filter="url(#dropshadow)" class="vectual_bar_bar" style="opacity:0;"
				x="'.($i * ($width/$num)).'" y="0"
				height="0" width="'.(0.7 *($width/$num)).'" >'.
				
				'<title>'.$v["data"][1]["time"][$i].':  '.$v["data"][1]["value"][$i].'</title>'.
				
					'<animate attributeName="height" to="'.(($v["data"][1]["value"][$i]-$min_value) * ($height/$range_y)).'"		
						begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="y" to="-'.(($v["data"][1]["value"][$i]-$min_value) * ($height/$range_y)).'"		
						begin="0" dur="0.8s" fill="freeze" />'.
					'<animate attributeName="opacity" begin="0s" to="0.8" dur="0.8s" additive="replace" fill="freeze"/>'.
					
					'<animate attributeName="fill" to="rgb(100,210,255)" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="fill" to="rgb(0,150,250)" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.
			'</rect>';	
		}	

}

?>