<?php
namespace App\Services;
use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function AddCamera($request, $response, $args) {
    $data = $request->getParsedBody();
    $brand = $data["brand"];
    $model = $data["model"];
    $description = $data["description"];
    $status = $data["status"];

    try {
        $db = new Db();
        $conn = $db->connect();
        // 開始交易
        $conn->beginTransaction();
        // SQL 語句
        $sql = "INSERT INTO cameras (brand, model, description, status) 
                VALUES ('$brand', '$model', '$description', '$status')";
        $conn->exec($sql);
        // 提交交易
        $result = $conn->commit(); 
        // 關閉連接
        $conn = null; 
        $db = null;
        $response->getBody()->write(json_encode($result));
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