<?php
include_once 'config.php';

$symptoms = [
    // Hypo
    ['زيادة الوزن', 'trending_down', 'hypo'],
    ['الإرهاق الشديد', 'battery_alert', 'hypo'],
    ['بطء ضربات القلب', 'monitor_heart', 'hypo'],
    ['الاكتئاب', 'sentiment_dissatisfied', 'hypo'],
    ['بطء التفكير وضعف التركيز', 'psychology_alt', 'hypo'],
    ['جفاف الجلد', 'dry_cleaning', 'hypo'],
    ['تساقط الشعر', 'content_cut', 'hypo'],
    ['الحساسية للبرد', 'ac_unit', 'hypo'],
    ['الإمساك', 'airline_seat_legroom_reduced', 'hypo'],
    ['تورم الوجه', 'face', 'hypo'],
    ['انتفاخ حول العين', 'remove_red_eye', 'hypo'],
    ['بحة الصوت', 'record_voice_over', 'hypo'],
    ['برودة الأطراف', 'back_hand', 'hypo'],
    ['غزارة الدورة الشهرية', 'wc', 'hypo'],
    ['ضعف العضلات', 'fitness_center', 'hypo'],
    ['بطء الحركة', 'directions_walk', 'hypo'],
    
    // Hyper
    ['فقدان الوزن رغم زيادة الشهية', 'trending_down', 'hyper'],
    ['تسارع ضربات القلب', 'monitor_heart', 'hyper'],
    ['خفقان القلب', 'monitor_heart', 'hyper'],
    ['التعرق الزائد', 'water_drop', 'hyper'],
    ['رعشة اليد', 'pan_tool', 'hyper'],
    ['توتر وقلق', 'psychology', 'hyper'],
    ['تقلبات مزاجية', 'mood_bad', 'hyper'],
    ['الأرق', 'bedtime', 'hyper'],
    ['الإسهال المتكرر', 'airline_seat_legroom_reduced', 'hyper'],
    ['عدم تحمل الحرارة', 'thermostat', 'hyper'],
    ['جحوظ العينين', 'remove_red_eye', 'hyper'],
    ['نشاط زائد / فرط حركة', 'directions_run', 'hyper'],
    ['ضعف العضلات', 'fitness_center', 'hyper'],
    ['اضطراب الدورة الشهرية', 'wc', 'hyper'],
    ['تساقط الشعر', 'content_cut', 'hyper'],
    ['تضخم الغدة (تورم بالرقبة)', 'person_pin', 'hyper']
];

try {
    $conn->exec("TRUNCATE TABLE symptoms");
    $stmt = $conn->prepare("INSERT INTO symptoms (id, title, icon_name, type) VALUES (?, ?, ?, ?)");
    
    $id = 1;
    foreach ($symptoms as $sym) {
        $stmt->execute([$id, $sym[0], $sym[1], $sym[2]]);
        $id++;
    }
    
    echo "Done successfully.";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>
