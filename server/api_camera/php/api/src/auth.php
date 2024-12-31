<?php
use Slim\Routing\RouteContext;
use Psr\Http\Message\ResponseInterface;

session_start();

// Session lifetime in seconds
$inactividad = 20;
if (isset($_SESSION["session_timeout"])){
    $sessionTTL = time() - $_SESSION["session_timeout"];
    if ($sessionTTL > $inactividad) {
        // session_destroy();
        unset($_SESSION['user_id']);
    }
}
// Start timeout for later check
$_SESSION["session_timeout"] = time();

$checkLoggedInMiddleware = function($request, $handler): ResponseInterface {
    $routeContext = RouteContext::fromRequest($request);
    $route = $routeContext->getRoute();

    if (empty($route)) { throw new HttpNotFoundException($request, $response); }

    $routeName = $route->getName();

    // Define routes that user does not have to be logged in with. 
    // All other routes, the user needs to be logged in with.
    // Names for routes must be defined in routes.php with ->setName() for each one.
    $publicRoutesArray = array('root', 'login', 'register');

    if (empty($_SESSION['user_id']) && (!in_array($routeName, $publicRoutesArray))) {
        // Redirect to the root url
        $routeParser = $routeContext->getRouteParser();
        $url = $routeParser->urlFor('root');

        $response = new \Slim\Psr7\Response();
        
        return $response->withHeader('Location', $url)->withStatus(302);
    } else {
        $response = $handler->handle($request);

        return $response;
    }
};
?>