<?php

class Map extends VectualGraph{
	protected $map;
	protected $svg;

	function __construct($data, $config, $svg){
		parent::__construct($data, $config, $svg);
		
		$this->svg = $svg;
		
		$this->map = new SimpleXMLElement(file_get_contents(__DIR__.'/../map.txt', true));
		
	}


	public function setMap(){	
		
		$this->setColors();
		
		$domsvg = dom_import_simplexml($this->svg);
		$domvar = dom_import_simplexml($this->map);
		
		
		$domvar  = $domsvg->ownerDocument->importNode($domvar, TRUE);

		
		$domsvg->appendChild($domvar);
		
		
		$this->svg->g[1]->addAttribute('transform','translate('.-($this->width * 0.03).','.($this->height * 0.18).') scale('.(min($this->height,$this->width) * 0.00065).')');
		
	
	}
	
	
	private function setColors(){
	
		$css = '';
		for($i=0; $i < $this->numValues; $i++){	
			$color = (255 - ($this->values[$i]/$this->maxValue * 255));
		
			$css .= '.'.$this->keys[$i].'{fill: rgb(255,'.round($color).','.round($color).');} ';	
		}
	
		$style = $this->svg->addChild('style', $css);
			$style->addAttribute('type','text/css');
		
	}
}


?>