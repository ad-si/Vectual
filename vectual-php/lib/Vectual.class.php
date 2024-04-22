<?php
//namespace Vectual;

class Vectual {
	protected $svg;

	protected $header = '';
	protected $toolbarObjects = array();
	
	protected $width;
	protected $height;
	protected $lineHeight;
	protected $inline;
	protected $title;
	protected $class;
	protected $xhtml;
	protected $standalone;
	protected $data;
	protected $config;	
	
	static $color = array();
	
	
	function __construct($data, $config) {
	
		$this->toolbarObjects = $config['toolbar'];
		
		$this->width = $config['width'];
		$this->height = $config['height'];
		$this->lineHeight = $config['lineHeight'];
		
		$this->title = $config['title'];
		$this->xhtml = $config['xhtml'];
		$this->standalone = $config['standalone'];
		$this->data = $data;
		$this->config = $config;	
		
	}
	
	function __toString(){
		return str_replace('<?xml version="1.0"?>', '', $this->svg->saveXML());
	}
	
	public function draw($type, $inline = false){
	
		$this->inline = $inline;
	
		if($this->standalone){
			$this->svg = new SimpleXMLElement(
				'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">'.
				'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" />');
		}else{
			$this->svg = new SimpleXMLElement('<svg/>');
		}

		$this->svg->addAttribute('width', $this->inline ? $this->lineHeight * 3 : $this->width);
		$this->svg->addAttribute('height', $this->inline ? $this->lineHeight : $this->height);

		$this->svg->addChild('title', $this->title);
		
		$this->svg->addAttribute('class', ($this->inline ? 'vectual_inline' : 'vectual'));	

		$v = new VectualWrapper($this->data, $this->config, $this->svg, $this->inline);
			$v->setStyle();
			$v->setDefs();
			$v->setBackground();
			$v->setTitle();
			$v->setToolbar();
	
		$this->setGraph($type,$inline);
		
		return str_replace('<?xml version="1.0"?>','', $this->svg->saveXML());
	}
	
	public function setGraph($type, $inline = false){
	
		if($inline){
			switch($type){
				case 'linechart':
					$new = new Sparkline($this->data, $this->config, $this->svg);
					$new->setSparkline();
					break;
			}
		}else{
			switch($type){
				case 'piechart':
					$new = new Pie($this->data, $this->config, $this->svg);
					$new->setPie();
					break;
				case 'map':
					$new = new Map($this->data, $this->config, $this->svg);
					$new->setMap();
					break;
				case 'barchart':
					$new = new Bar($this->data, $this->config, $this->svg);
					$new->setBargraph();
					break;
				case 'linechart':
					$new = new Line($this->data, $this->config, $this->svg);
					$new->setLinegraph();
					break;
				case 'table':
					$new = new Table($this->data, $this->config, $this->svg);
					$new->setTable();
					break;
				case 'scatterchart':
					$new = new Scatter($this->data, $this->config, $this->svg);
					$new->setScatter();
					break;
				case 'tagcloud':
					$new = new Tagcloud($this->data, $this->config, $this->svg);
					$new->setTagcloud();
					break;
			}
		}
	
		/*
		
		return VectualGraph::newGraph($this->type,$this->data)
			->methode()
			->methode()
		
		newGraph($type,$data) {
			return new $type($data);
		}
		*/
	}	
}


?>