<?php
    $servername = "mysql";
    $username = "root"; 
    $password = "netlab123"; 
    $dbname = "camera_sql"; 
    try { 
        $conn = new PDO("mysql:host=$servername", $username, $password); 
        // set the PDO error mode to exception 
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
        $sql = "CREATE DATABASE $dbname"; 
        // use exec() because no results are returned 
        $conn->exec($sql); 
        echo "Database has been created successfully<br>"; 
        // Close connection 
        $conn = null; 
    } catch(PDOException $e) { 
        echo $sql . "<br><br>" . $e->getMessage(); 
        // Close connection 
        $conn = null; 
    }
    try { 
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password); 
        // set the PDO error mode to exception 
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
        // sql to create table 
        $sql = "
    CREATE TABLE `users` (
        `user_id` INT UNSIGNED AUTO_INCREMENT NOT NULL,
        `username` VARCHAR(16) NOT NULL,
        `password` VARCHAR(32) NOT NULL,
        `is_admin` INT(2) NOT NULL DEFAULT 0,
        PRIMARY KEY (`user_id`),
        CONSTRAINT `uc_users_username` UNIQUE (`username`)
    );

    CREATE TABLE `status` (
        `id` INT(2) NOT NULL,
        `value` VARCHAR(64) NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `cameras` (
        `camera_id` INT UNSIGNED AUTO_INCREMENT NOT NULL,
        `brand` VARCHAR(16) NULL,
        `model` VARCHAR(32) NULL,
        `description` TEXT NULL,
        `status` INT(2) NOT NULL DEFAULT 1,
        `last_updated` TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`camera_id`),
        CONSTRAINT `fk_cameras_status` FOREIGN KEY (`status`) REFERENCES `status` (`id`)
    );

    CREATE TABLE `rentals` (
        `rental_id` INT UNSIGNED AUTO_INCREMENT NOT NULL,
        `user_id` INT UNSIGNED NOT NULL,
        `camera_id` INT UNSIGNED NOT NULL,
        `rental_date` DATE NOT NULL,
        `return_date` DATE NULL,
        `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (`rental_id`),
        CONSTRAINT `fk_rentals_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
        CONSTRAINT `fk_rentals_camera_id` FOREIGN KEY (`camera_id`) REFERENCES `cameras` (`camera_id`)
    );

    INSERT INTO `status` (`id`, `value`) VALUES
    (-1, 'borrowed'),
    (0, 'unavailable'),
    (1, 'available');
    "; 
        // use exec() because no results are returned 
        $conn->exec($sql); 
        echo "Multiple tables have been created successfully"; 
        
        // Close connection 
        $conn = null; 
    } catch(PDOException $e) { 
        echo $sql . "<br><br>" . $e->getMessage();
        // Close connection 
        $conn = null; 
    }
    $conn = null; 
?>