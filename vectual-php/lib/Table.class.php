<?php

class Table extends VectualGraph{

	private $table;

	function __construct($data, $config, $svg){	
		parent::__construct($data, $config, $svg);
		
		$this->table = $svg->addChild('foreignObject');
	}
		
	public function setTable(){
	
		$this->table->addAttribute('x','0');
		$this->table->addAttribute('y','0');
		$this->table->addAttribute('width','100%');
		$this->table->addAttribute('height','100%');
		$this->table->addAttribute('transform','translate(20,25)');
		
		
		$html = $this->table->addChild('table');
			$html->addAttribute('class','vectual_table');
			
			$th = $html->addChild('tr');
				$th->addChild('th', $this->label[2]);
				$th->addChild('th', $this->label[1]);
				
				for($i=($this->numValues - 1); $i>=0; $i--){
					$td = $html->addChild('tr');
						$td->addChild('td', $this->sortedKeys[$i]);
						$td->addChild('td', $this->sortedValues[$i]);
				}
	}		
}

?>