<?php

class inlinePie extends Inline{

	
if($v["type"] == 'inlinePie'){

	$pie =
	'<svg '; 
	
	if($this->doctype == "xhtml"){
		$pie .='xmlns="http://www.w3.org/2000/svg" ';
	}
	
	$pie .=
	'class="vectual_inline" width="'.($v["line-height"]).'" height="'.($v["line-height"]).'" >	
		
		<rect class="vectual_background" x="0" y="0" height="'.$v["line-height"].'" width="'.$v["line-height"].'" />';

	
		$radius = $v["line-height"]/2;
		$total = array_sum($v["data"][1]["value"]);
		$startx = 0.5 * $v["line-height"];
		$starty = 0.5 * $v["line-height"];
		$angle = 0;
		$lastx = -$radius;
		$lasty = 0;
		$angle_all = '';
		
		$pie .= '<g transform="translate('.$startx.', '.$starty.')" >';

		
		if ($total == $v["data"][1]["value"][0]) // Only one value
		{
					$pie .= '	<circle cx="0" cy="0" r="'.$radius.'" stroke="none" fill="'.$color[0].'" />';
		}
		else
		{							
			for($i=0; $i < $num; $i++)
			{	
				$angle_all_last = $angle_all;
				
				if((($v["data"][1]["value"][$i]/$total) * 360) > 180) $size = '0 1,0';
				else $size = '0 0,0';
				
	
			    $angle_add = (($v["data"][1]["value"][$i]/$total) * 360)/2;
			    $angle_translate_deg = $angle_all_last + $angle_add;
			    $angle_translate = deg2rad($angle_translate_deg);
			    
			    $tx = -(cos($angle_translate)) * $radius;
				$ty = (sin($angle_translate)) * $radius;
				
			    // Angle
			    $angle_all_last = $angle_all;
			    $angle_this = (($v["data"][1]["value"][$i]/$total) * 360);
				$angle_all = $angle_this + $angle_all;
				$angle_rad = deg2rad($angle_all);
				
				$nextx = -(cos($angle_rad) * $radius);
				$nexty = (sin($angle_rad) * $radius);
				$pie .= '
								
					<g>
						<path fill="'.$color[$i].'"
						d="M 0,0 L '.$lastx.','.$lasty.' 
						A '.$radius.','.$radius.' '.$size.' '.$nextx.','.$nexty.' z"
						transform="rotate('.$angle_all_last.',0,0)" >
		                                        
		                    <animateTransform attributeName="transform"
		                    type="rotate" to="0,0,0" dur="0.8s" 
		                    additive="replace" fill="freeze" />
						
	       				</path>	
	  						  			
							<animateTransform attributeName="transform"
		                    type="translate" to="'.($tx * 0.2).', '.($ty * 0.2).'"
		                    dur="0.3s" begin="mouseover"
		                    additive="replace" fill="freeze" />
		                    
		                    <animateTransform attributeName="transform"
		                    type="translate" to="0,0" dur="0.3s" begin="mouseout"
		                    additive="replace" fill="freeze" />
	  				</g>
						';		 		
				
				$lastx = $nextx;	
				$lasty = $nexty; 			
			}	
			
			
	   		
		}
		$pie .= '</g>';
	$cont .= $pie;
}


}

?>