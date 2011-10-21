<?php

class inlineBar extends Inline{		
		
		$range = $max_value - $min_value;
				
		$coordinate .= '<g transform="translate('.($width *0.1).', '.(($height/$range) * $max_value * 1.1).')" >';
	
		for($i=$min_value; $i <= $max_value; $i++){ //vertical loop	 
				$coordinate .= '<line x1="0" y1="'.(-($height/$range)*$i).'" x2="'.($width + 0).'" y2="'.(-($height/$range)*$i).'" 
				style="stroke:grey;';
				if($i == 0){$coordinate .= 'stroke-width:2;"/>';} else{$coordinate .= 'stroke-width:1;"/>';}
				
				$coordinate .='<text style="fill:white; font-size: 12px; color:white;" x="-30" y="'.(-($height/$range)* $i * 1).'">
					'.$i.'
				</text>';
		}
				
			
		for($i=0; $i <= $num; $i++){ //horizontal loop

				$coordinate .= '<line x1="'.(($width/$num)*$i).'" y1="'.(-($height/$range)*$min_value).'" x2="'.(($width/$num)*$i).'" y2="'.(-($height/$range)*$max_value).'" style="stroke:grey; stroke-width: 1"/>';
		
				$coordinate .='
				<text fill="white" style="font-size: 12px; color: white;" 
					transform="rotate(40 '.(($width/$num)*$i).', '.(-($height/$range) * $min_value + 10).')" 
					x="'.(($width/$num)*$i).'" y="'.(-($height/$range) * $min_value + 10).'">
							'.$v["data"][1]["key"][$i].'
				</text>';
		}
			
		$coordinate .= $bar;
		$coordinate .= '</g>';
		$cont .= $coordinate;	
}

?>