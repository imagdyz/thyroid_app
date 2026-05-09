<?php
include_once 'config.php';

$query = "SELECT id, title, icon_name, type FROM symptoms";
$stmt = $conn->prepare($query);
$stmt->execute();

$symptoms = array();

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $symptoms[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $symptoms
]);
?>
