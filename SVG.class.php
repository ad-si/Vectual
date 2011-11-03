<?php

class SVG{

	protected $svg;

	/*
	function __construct($width = 100, $height = 100, $standalone = false){

		// $args = func_get_args();

		if($standalone){
			$this->svg = new SimpleXMLElement(
				'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" />');
		}else{
			$this->svg = new SimpleXMLElement('<svg/>');
		}

		$this->svg->addAttribute('width', $width);
		$this->svg->addAttribute('height', $height);
		
		return $this->svg;
	}
	*/
	
	public static function addAttributes($sxmle,$attributes){
		foreach($attributes as $attribute=>$value){
			$sxmle->addAttribute($attribute, $value);
		}
	}
	
}

?>