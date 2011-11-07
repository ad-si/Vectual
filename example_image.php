<?php

// THE RECOMMENDED WAY OF INTEGRATION IS THE ONE DESCRIBED IN example_website.php

//Make sure to send the header if you use it as an standalone image
header("Content-type: image/svg+xml");


//Config array for the basic configuration of your Vectual object
$config = array(
	'width'         => '500',
	'height'        => '300',
	
	//'pie','bar','line','scatter','tagcloud','map','table','save'
	'toolbar'       => array( 'pie','bar','line','scatter','tagcloud','map','table','save'),
	
	//Automatic layout mode
	'automatic'		=> true,
	
	// Right Doctype for integration in XHTML websites and standalone images
	'xhtml'			=> true,
	
	// Set to false to increase browser-compatibility
	'animations'	=> true,
	
	// Set to true if you want to generate an image
	'standalone'	=> true,
	'lineHeight'	=> '22',
	
	'title'         => 'Fruit Consumption',
	
	//Specifies the number and type of dimensions (NO FUNCTIONALITY YET)
	'dimension' 	=> array(	1 => 'value',
								2 => 'key',
								3 => 'time',
								4 => 'location'
							),
	
	'label' 		=> array(	1 => 'Number',
								2 => 'Fruit type',
								3 => '',
								4 => ''
							),
	
);

$data = array(
	"Apple" 	=> "50",
	"Plum" 		=> "27",
	"Peach" 	=> "11",
	"Lime" 		=> "2",
	"Cherry" 	=> "123",
	"Pineapple" => "69",
	"Melon" 	=> "26",
	"Grapefruit"=> "35",
	"Strawberry"=> "56",
	"Orange" 	=> "34",
	"Kiwi" 		=> "65"
);


$lineData = array(
	"January" 	=> "50",
	"February" 	=> "27",
	"March" 	=> "11",
	"April" 	=> "2",
	"May" 		=> "123",
	"June" 		=> "69",
	"July" 		=> "26",
	"August"	=> "35",
	"September"	=> "56",
	"Oktober" 	=> "34",
	"November" 	=> "65",
	"Dezember" 	=> "34"
);

$mapData = array(
	"de" 	=> "50",
	"us" 	=> "27",
	"in" 	=> "11",
	"br" 	=> "20",
	"ru" 	=> "123",
	"au" 	=> "69",
	"jp" 	=> "26",
	"es"	=> "35",
	"cd"	=> "56",
	"ne" 	=> "34",
	"za" 	=> "65"
);

//Specify the path to the vectual class directory
function __autoload($class){
	require_once($class.'.class.php');
}

//Create an Vectual instance
$test = new Vectual($data, $config);

//Draw the whole chart
echo $test->draw('piechart');


?>