<?php
include_once 'config.php';

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : null;

if ($user_id) {
    try {
        $query = "SELECT * FROM diagnoses WHERE user_id = :user_id ORDER BY created_at DESC";
        if ($limit) {
            $query .= " LIMIT $limit";
        }
        
        $stmt = $conn->prepare($query);
        $stmt->bindParam(":user_id", $user_id);
        $stmt->execute();
        
        $diagnoses = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode(["status" => "success", "data" => $diagnoses]);
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Database error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User ID is required."]);
}
?>
