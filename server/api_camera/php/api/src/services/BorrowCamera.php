<?php

namespace App\Services;

use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function BorrowCamera($request, $response, $args) {
    $user_id = -1;
    if (isset($_SESSION["user_id"])) {
        $user_id = $_SESSION["user_id"];
    } else {
        $response->getBody()->write("false");
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    }

    $camera_id = $request->getAttribute('camera_id');
    $data = $request->getParsedBody();
    $borrowed_by = $user_id;

    try {
        $db = new Db();
        $conn = $db->connect();

        // 開始交易
        $conn->beginTransaction();

        // SQL 語句
        $sql = "UPDATE cameras SET
                status = '-1'
                WHERE camera_id = '$camera_id'";
        $conn->exec($sql);

        // 插入租借記錄
        $sql = "INSERT INTO rentals (user_id, camera_id, rental_date) 
                VALUES ('$borrowed_by', '$camera_id', CURDATE())";
        $conn->exec($sql);

        // 提交交易
        $conn->commit();

        // 關閉連接
        $conn = null;
        $db = null;

        $response->getBody()->write("true");
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    } catch (PDOException $e) {
        $conn->rollBack();
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
