<?php

abstract class VectualGraph extends SVG{
	protected $data;
	
	protected $width;
	protected $height;
	
	protected $toolbar;
	protected $animations;

	protected $graphWidth;
	protected $graphHeight;
	
	protected $totalValue;
	protected $numKeys;
	protected $maxValue;
	protected $maxValueIndex;
	protected $maxKey;
	protected $minValue;
	protected $minValueIndex;
	protected $minKey;
	protected $numValues;
	protected $sortedArray = array();
	protected $sortedKeys = array();
	protected $sortedValues = array();
	
	protected $xRange;
	protected $yRange;

	protected $label = array();
	
	protected $color = array();
		
	function __construct($data, $config){

		$this->data = $data;

		$this->toolbar = $config['toolbar'];
		$this->animations = $config['animations'];
		$this->width = $config['width'];
		$this->height = $config['height'];
		
		$this->graphWidth = ($this->width  - 50);
		$this->graphHeight = ($this->height - 100);
		
		$this->totalValue = array_sum($data);
		$this->values = array_values($data);
		$this->numValues = count($data);
		$this->minValue = min(array_values($data));
		$this->minValueIndex = array_search($this->minValue, array_values($data));
		$this->maxValue = max(array_values($data));
		$this->maxValueIndex = array_search($this->maxValue, array_values($data));
		$this->keys = array_keys($data);
		$this->numKeys = count($data);
		$this->minKey = min(array_keys($data));;
		$this->maxKey = max(array_keys($data));
		$this->sortedArray = $data;
			asort($this->sortedArray);
		$this->sortedValues = array_values($this->sortedArray); 
		$this->sortedKeys = array_keys($this->sortedArray); 
		
		$this->xRange = $this->maxKey - $this->minKey;
		$this->yRange = $this->maxValue - $this->minValue;
		
		$this->label = $config['label'];	
		
		for($i=0; $i<=$this->numValues; $i++){
			$this->color[$i] = 'rgb(255, '.rand(1,255).', '.rand(1,255).')';
		}			
	}
}

?>