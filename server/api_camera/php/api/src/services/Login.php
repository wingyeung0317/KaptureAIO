<?php

namespace App\Services;

use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function Login($request, $response) {
    $data = $request->getParsedBody();
    $username = $data["username"];
    $password = $data["password"];

    try {
        $db = new Db();
        $conn = $db->connect();

        $sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
        $stmt = $conn->query($sql);
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if(count($result) == 1){ //the user record exist
            $_SESSION['user_id'] = $result[0]["user_id"]; // Save session
            $_SESSION['is_admin'] = $result[0]["is_admin"]; // Save session
            $json = array(
                'user_id' => $result[0]["user_id"], 
                'is_admin' => $result[0]["is_admin"]
            );
            $response->getBody()->write(json_encode($json));
        }
        else{
            $response->getBody()->write("false");
        }

        // Close connection 
        $conn = null; 
        $db = null; 

        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    } catch (PDOException $e) {
        $error = array(
        "message" => $e->getMessage()
        );
        
        $response->getBody()->write(json_encode($error));
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(500);
    }
}
?>
