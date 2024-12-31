<?php

require_once __DIR__ . '/../vendor/autoload.php';

$app = Slim\Factory\AppFactory::create();

// add simple authentication
require_once __DIR__ . '/../src/auth.php';
$app->add($checkLoggedInMiddleware);

//handle json format
$app->addBodyParsingMiddleware();

// Add Slim routing middleware
$app->addRoutingMiddleware();

// Set the base path to run the app in a subdirectory.
// This path is used in urlFor().
$app->add(new Selective\BasePath\BasePathMiddleware($app));

$app->addErrorMiddleware(true, true, true);

// Define app routes here
$app->get('/', function ($request, $response) {
    $response->getBody()->write('Hello, World!');
    return $response;
})->setName('root'); //<<<set root

//require all php files in /../src/services
foreach (glob(__DIR__ . '/../src/services/*.php') as $filename) {
// var_dump($filename); // for debug only
require_once($filename); 
}

$app->get('/cameras/all', 'App\Services\GetAllCameras');
$app->post('/cameras/add', 'App\Services\AddCamera');
$app->put('/cameras/update/{camera_id}', 'App\Services\UpdateCamera');
$app->delete('/cameras/delete/{camera_id}', 'App\Services\DeleteCamera');
$app->post('/users/login', 'App\Services\Login')->setName('login');
$app->post('/users/register', 'App\Services\Register')->setName('register');
$app->get('/users/logout', 'App\Services\Logout');
$app->get('/users/myrecords', 'App\Services\MyRecords');
$app->get('/cameras/borrow/{camera_id}','App\Services\BorrowCamera');
$app->get('/cameras/return/{camera_id}', 'App\Services\ReturnCamera');

// Run app
$app->run();
?>