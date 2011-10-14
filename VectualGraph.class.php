<?php

class VectualGraph{		

	
	protected $data;
	
	protected $width;
	protected $height;

	protected $graphWidth;
	protected $graphHeight;
	
	protected $totalValue;
	protected $numKeys;
	protected $maxValue;
	protected $maxKey;
	protected $minValue;
	protected $minKey;
	protected $numValues;
	protected $sortedKeys = array();
	protected $sortedValues = array();
	
	protected $color = array();
		
	function __construct($data, $config) {
		$this->data = $data;
		
		$this->width = $config["width"];
		$this->height = $config["height"];
		
		$this->graphWidth = ($this->width  - 50);
		$this->graphHeight = ($this->height - 100);
		
		$this->totalValue = array_sum($data[1]["value"]);
		$this->numKeys = count($data[1]["key"]);
		$this->numValues = count($data[1]["value"]);
		$this->maxValue = max($data[1]["value"]);
		$this->maxKey = array_search($this->maxValue, $data[1]["value"]);
		$this->minValue = min($data[1]["value"]);
		$this->minKey = array_search($this->minValue, $data[1]["value"]);
		$this->sortedValues = $data[1]["value"]; 
		$this->sortedKeys = $data[1]["key"];	
		array_multisort($this->sortedValues, $this->sortedKeys);
		
		
		for($i=0; $i<=$this->numValues; $i++){
			$this->color[$i] = 'rgb(255, '.rand(1,255).', '.rand(1,255).')';
		}
			
	}
}

?>