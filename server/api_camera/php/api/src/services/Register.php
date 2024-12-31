<?php

namespace App\Services;

use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function Register($request, $response) {
    $data = $request->getParsedBody();
    $username = $data["username"];
    $password = $data["password"];
    $repeated_password = $data["repeated_password"];

    if($password != $repeated_password){
        $response->getBody()->write(json_encode("false"));
        return $response
                ->withHeader('content-type', 'application/json')
                ->withStatus(200);
    }

    try {
        $db = new Db();
        $conn = $db->connect();

        // begin the transaction 
        $conn->beginTransaction();

        // our SQL statements 
        $sql = "INSERT INTO users (username, password) 
                VALUES ('$username', '$password')";
        $conn->exec($sql);

        // commit the transaction 
        $result = $conn->commit(); 

        // Close connection 
        $conn = null; 
        $db = null;

        $response->getBody()->write(json_encode("true"));
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
