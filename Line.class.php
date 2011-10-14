<?php

class Line extends CoordinateSystem{
	
	
		//Line----------------------
		$line =
		'<g>';
		
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
		

		$line .=
		'<g filter="url(#dropshadow)">'.
		'<polyline class="vectual_line_line" points="';								
				
			for($i=0; $i < $num; $i++){ $line .=''.($i * ($width/$num)).',0 '; }					
				
			$line .='" >'.
				
			'<animate attributeName="points" to="';			
				for($i=0; $i < $num; $i++)
					{ $line .=''.($i * ($width/$num)).','.((-$v["data"][1]["value"][$i]+$min_value) * ($height/$range_y)).' ';}		
			$line .=
			'" begin="0" dur="0.8s" fill="freeze" />
					
			<animate attributeName="opacity" begin="0s" to="1" dur="0.8s" additive="replace" fill="freeze"/>'.
			
		'</polyline>';
		
		//Dots
		for($i=0; $i < $num; $i++){
			
				$line .=
				'<circle class="vectual_line_dot"
				cx="'.($i * ($width/$num)).'"
				cy="'.((-$v["data"][1]["value"][$i]+$min_value) * ($height/$range_y)).'"
				r="4" >'.
					'<animate attributeName="opacity" begin="0.8s" to="1" dur="0.5s" additive="replace" fill="freeze"/>'.
						
					'<animate attributeName="r" to="8" dur="0.1s" begin="mouseover" additive="replace" fill="freeze" />'.
					'<animate attributeName="r" to="4" dur="0.2s" begin="mouseout" additive="replace" fill="freeze" />'.
					
					'<title>'.$v["data"][1]["time"][$i].':  '.$v["data"][1]["value"][$i].'</title>'.
					
				'</circle>';			
		}
			
		$line .=
		'</g>
		</g>';
		
}

?>
