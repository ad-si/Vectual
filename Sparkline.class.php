<?php

class Sparkline extends VectualGraph {

	private $sparkline;

	function __construct($data, $config, $svg){	
		parent::__construct($data, $config, $svg);
		
		$this->width = 3 * $config['lineHeight'];
		$this->height = $config['lineHeight'];
		
		$this->sparkline = $svg->addChild('g');
	}
	
	public function setSparkline(){
	
		$this->sparkline->addAttribute('transform', 'translate(0, '.($this->height - 2).')');
	
		$line = $this->sparkline->addChild('line');
			$line->addAttribute('x1', '0');
			$line->addAttribute('y1', (0 + $this->minValue) * (($this->height - 4)/$this->yRange));
			$line->addAttribute('x2', ($this->height * 3));
			$line->addAttribute('y2', (0 + $this->minValue) * (($this->height - 4)/$this->yRange));
			$line->addAttribute('style', 'stroke:rgb(200,200,200); stroke-width: 0.5');
		
		$points = '';
		for($i=0; $i < $this->numValues; $i++){
			$points .= ($i * (($this->height * 3)/$this->numValues)).','.((-$this->values[$i] + $this->minValue) * (($this->height - 4)/$this->yRange)).' ';
		}
		
		$polyline = $this->sparkline->addChild('polyline');
			$polyline->addAttribute('class', 'vectual_inline_sparkline');
			$polyline->addAttribute('points', $points);
			
			
		$max = $this->sparkline->addChild('circle');
			$max->addAttribute('class','vectual_inline_sparkline_max');
			$max->addAttribute('r','1.5');
			$max->addAttribute('cx', ($this->maxValueIndex * (($this->height * 3)/$this->numValues)));
			$max->addAttribute('cy', (-$this->maxValue + $this->minValue) * (($this->height - 4) /$this->yRange));
		
		$max = $this->sparkline->addChild('circle');
			$max->addAttribute('class','vectual_inline_sparkline_min');
			$max->addAttribute('r','1.5');
			$max->addAttribute('cx', ($this->minValueIndex * (($this->height * 3)/$this->numValues)));
			$max->addAttribute('cy', (-$this->minValue + $this->minValue) * (($this->height - 4) /$this->yRange));
	}						
}

?>