<?php
include_once 'config.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->name) && !empty($data->email) && !empty($data->password)) {
    $name = $data->name;
    $email = $data->email;
    $password = password_hash($data->password, PASSWORD_DEFAULT);

    // Check if email exists
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->rowCount() > 0) {
        echo json_encode(["status" => "error", "message" => "Email already exists"]);
        exit();
    }

    $query = "INSERT INTO users (name, email, password) VALUES (:name, :email, :password)";
    $stmt = $conn->prepare($query);

    $stmt->bindParam(":name", $name);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":password", $password);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "User was created."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Unable to create user."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data."]);
}
?>
