<?php

class Table extends VectualGraph{

	function __construct($data, $config){	
		parent::__construct($data, $config);
	}
		
	public function getTable(){
		return $this->compileTable();
	}	
	
	private function compileTable(){
		$table = 
		'<foreignObject x="0" y="0" width="100%" height="400%" transform="translate(20,25)">	     
			<table class="vectual_table">';	
		
			 $table .= 
			 '<tr>
			    <th>'.$this->label[2].'</th>
			    <th>'.$this->label[1].'</th>
			 </tr>';
			 
		for($i=($this->numValues - 1); $i>=0; $i--){
			$table .= 
			'<tr>		 
			   	 <td>'.$this->sortedKeys[$i].'</td>
			  	 <td>'.$this->sortedValues[$i].'</td>
			</tr>';
		}
			 
			$table .= 
			'</table>
	    </foreignObject>';

		return $table;	
	}		
}

?>