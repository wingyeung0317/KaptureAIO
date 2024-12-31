<?php
namespace App;
use \PDO;

class Db
{
    private $host;
    private $user;
    private $pass;
    private $dbname;

    public function __construct()
    {
        $this->host = getenv('DB_HOST') ?: 'localhost';
        $this->user = getenv('DB_USER') ?: 'root';
        $this->pass = getenv('DB_PASS') ?: 'netlab123';
        $this->dbname = getenv('DB_NAME') ?: 'camera_sql';
    }

    public function connect()
    {
        $conn_str = "mysql:host=$this->host;dbname=$this->dbname";
        $conn = new PDO($conn_str, $this->user, $this->pass);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conn;
    }
}
?>