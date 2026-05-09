CREATE DATABASE IF NOT EXISTS thyroid_care;
USE thyroid_care;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS symptoms (
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    icon_name VARCHAR(50) NOT NULL,
    type ENUM('hypo', 'hyper', 'both') NOT NULL
);

CREATE TABLE IF NOT EXISTS diagnoses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    patient_name VARCHAR(100) DEFAULT '',
    patient_phone VARCHAR(20) DEFAULT '',
    patient_age VARCHAR(10) DEFAULT '',
    symptoms_json TEXT NOT NULL,
    diagnosis_result TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert static symptoms
INSERT IGNORE INTO symptoms (id, title, icon_name, type) VALUES
('weight_gain', 'زيادة الوزن', 'add_chart', 'hypo'),
('extreme_fatigue', 'الإرهاق الشديد', 'battery_alert', 'hypo'),
('slow_heartbeat', 'بطء ضربات القلب', 'favorite_border', 'hypo'),
('depression', 'الاكتئاب', 'sentiment_dissatisfied', 'hypo'),
('slow_thinking', 'بطء التفكير وضعف التركيز', 'psychology_alt', 'hypo'),
('dry_skin', 'جفاف الجلد', 'dry_cleaning', 'hypo'),
('sensitivity_to_cold', 'الحساسية للبرد', 'ac_unit', 'hypo'),
('constipation', 'الإمساك', 'airline_seat_legroom_reduced', 'hypo'),
('facial_swelling', 'تورم الوجه', 'face', 'hypo'),
('puffy_eyes', 'انتفاخ حول العين', 'remove_red_eye', 'hypo'),
('hoarseness', 'بحة الصوت', 'record_voice_over', 'hypo'),
('cold_extremities', 'برودة الأطراف', 'pan_tool', 'hypo'),
('heavy_periods', 'غزارة الدورة الشهرية', 'water_drop', 'hypo'),
('slow_movement', 'بطء الحركة', 'directions_walk', 'hypo'),
('weight_loss', 'فقدان الوزن رغم زيادة الشهية', 'trending_down', 'hyper'),
('fast_heartbeat', 'تسارع ضربات القلب', 'monitor_heart', 'hyper'),
('palpitations', 'خفقان القلب', 'monitor_heart', 'hyper'),
('excessive_sweating', 'التعرق الزائد', 'water_drop', 'hyper'),
('hand_tremors', 'رعشة اليد', 'back_hand', 'hyper'),
('stress_and_anxiety', 'توتر وقلق', 'psychology', 'hyper'),
('mood_swings', 'تقلبات مزاجية', 'mood_bad', 'hyper'),
('insomnia', 'الأرق', 'bedtime', 'hyper'),
('frequent_diarrhea', 'الإسهال المتكرر', 'wc', 'hyper'),
('heat_intolerance', 'عدم تحمل الحرارة', 'thermostat', 'hyper'),
('bulging_eyes', 'جحوظ العينين', 'remove_red_eye', 'hyper'),
('hyperactivity', 'نشاط زائد / فرط حركة', 'directions_run', 'hyper'),
('menstrual_irregularities', 'اضطراب الدورة الشهرية', 'water_drop', 'hyper'),
('goiter', 'تضخم الغدة (تورم بالرقبة)', 'person_pin', 'both'),
('hair_loss', 'تساقط الشعر', 'content_cut', 'both'),
('muscle_weakness', 'ضعف العضلات', 'fitness_center', 'both');
