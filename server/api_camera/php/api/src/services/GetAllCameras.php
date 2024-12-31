<?php
namespace App\Services; // to be recognized by server
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function GetAllCameras($request, $response) {
    $sql = "SELECT * FROM cameras";
    try {
        $db = new Db();
        $conn = $db->connect();
        $stmt = $conn->query($sql);
        $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
        // Close connection 
        $conn = null; 
        $db = null;
        $response->getBody()->write(json_encode($data));
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