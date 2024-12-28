<?php

namespace App\Services;

use \PDO;
use App\Db;
require_once __DIR__ . '/../Db.php';

function ReturnCamera($request, $response, $args){
    $user_id = -1;
    if (isset($_SESSION["user_id"])){
        $user_id = $_SESSION["user_id"];
    }
    else{
        $response->getBody()->write("false");
        return $response
            ->withHeader('content-type', 'application/json')
            ->withStatus(200);
    }

    $camera_id = $request->getAttribute('camera_id');
    $data = $request->getParsedBody();
    $returned_by = $user_id;

    try {
        $db = new Db();
        $conn = $db->connect();

        $stmt = $conn->query("SELECT status FROM cameras WHERE camera_id = '$camera_id'");
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC); 

        //lets do some checking
        if(count($result) > 0){ //the camera exists
            if($result[0]['status'] == -1){ 
                // begin the transaction 
                $conn->beginTransaction();

                // update camera status
                $sql = "UPDATE cameras SET status = 1 WHERE camera_id = '$camera_id'";
                $conn->exec($sql);

                // update rental record
                $sql = "UPDATE rentals SET return_date = CURDATE() 
                        WHERE camera_id = '$camera_id' AND user_id = '$returned_by' AND return_date IS NULL";
                $conn->exec($sql);

                // commit the transaction
                $conn->commit();

                $response->getBody()->write("true");
                return $response
                    ->withHeader('content-type', 'application/json')
                    ->withStatus(200);
            }
        }

        $response->getBody()->write("false");
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