<?php
include_once 'config.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->user_id) && !empty($data->symptoms) && !empty($data->diagnosis_result)) {
    $user_id = $data->user_id;
    $symptoms = json_encode($data->symptoms, JSON_UNESCAPED_UNICODE);
    $diagnosis_result = $data->diagnosis_result;
    $patient_name = !empty($data->patient_name) ? $data->patient_name : '';
    $patient_phone = !empty($data->patient_phone) ? $data->patient_phone : '';
    $patient_age = !empty($data->patient_age) ? $data->patient_age : '';

    // Verify user exists
    $check = $conn->prepare("SELECT id FROM users WHERE id = ?");
    $check->execute([$user_id]);
    if ($check->rowCount() == 0) {
        echo json_encode(["status" => "error", "message" => "يرجى تسجيل الخروج وإعادة تسجيل الدخول"]);
        exit();
    }

    try {
        $query = "INSERT INTO diagnoses (user_id, symptoms_json, diagnosis_result, patient_name, patient_phone, patient_age) VALUES (:user_id, :symptoms_json, :diagnosis_result, :patient_name, :patient_phone, :patient_age)";
        $stmt = $conn->prepare($query);

        $stmt->bindParam(":user_id", $user_id);
        $stmt->bindParam(":symptoms_json", $symptoms);
        $stmt->bindParam(":diagnosis_result", $diagnosis_result);
        $stmt->bindParam(":patient_name", $patient_name);
        $stmt->bindParam(":patient_phone", $patient_phone);
        $stmt->bindParam(":patient_age", $patient_age);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Diagnosis saved."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Unable to save diagnosis."]);
        }
    } catch (PDOException $e) {
        echo json_encode(["status" => "error", "message" => "Database error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Incomplete data."]);
}
?>
