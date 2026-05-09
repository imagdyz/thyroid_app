SET FOREIGN_KEY_CHECKS = 0;

-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: thyroid_care
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `diagnoses`
--

DROP TABLE IF EXISTS `diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `diagnoses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `patient_name` varchar(100) DEFAULT '',
  `patient_phone` varchar(20) DEFAULT '',
  `patient_age` varchar(10) DEFAULT '',
  `symptoms_json` text NOT NULL,
  `diagnosis_result` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `diagnoses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoses`
--

LOCK TABLES `diagnoses` WRITE;
/*!40000 ALTER TABLE `diagnoses` DISABLE KEYS */;
INSERT INTO `diagnoses` VALUES (3,1,'Ahmed','01234','25','[\"weight_gain\",\"depression\"]','test','2026-05-08 13:33:07'),(4,1,'ahmed','0123456789','40','[\"dry_skin\",\"depression\",\"extreme_fatigue\",\"facial_swelling\"]','يوجد اشتباه في خمول الغدة الدرقية (Hypothyroidism).','2026-05-08 13:35:41'),(5,1,'777777','7777777','7','[\"dry_skin\",\"facial_swelling\",\"extreme_fatigue\",\"depression\"]','يوجد اشتباه في خمول الغدة الدرقية (Hypothyroidism).','2026-05-08 16:47:08'),(6,1,'785','55','55','[\"8\",\"9\",\"6\"]','يوجد اشتباه في خمول الغدة الدرقية.','2026-05-08 17:17:03'),(7,1,',,,,',',,,,,',',,,,','[\"16\",\"13\",\"10\",\"19\"]','يوجد اشتباه في خمول الغدة الدرقية.','2026-05-08 18:03:04');
/*!40000 ALTER TABLE `diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `symptoms`
--

DROP TABLE IF EXISTS `symptoms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `symptoms` (
  `id` varchar(50) NOT NULL,
  `title` varchar(150) NOT NULL,
  `icon_name` varchar(50) NOT NULL,
  `type` enum('hypo','hyper','both') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `symptoms`
--

LOCK TABLES `symptoms` WRITE;
/*!40000 ALTER TABLE `symptoms` DISABLE KEYS */;
INSERT INTO `symptoms` VALUES ('1','زيادة الوزن','trending_down','hypo'),('10','تورم الوجه','face','hypo'),('11','انتفاخ حول العين','remove_red_eye','hypo'),('12','بحة الصوت','record_voice_over','hypo'),('13','برودة الأطراف','back_hand','hypo'),('14','غزارة الدورة الشهرية','wc','hypo'),('15','ضعف العضلات','fitness_center','hypo'),('16','بطء الحركة','directions_walk','hypo'),('17','فقدان الوزن رغم زيادة الشهية','trending_down','hyper'),('18','تسارع ضربات القلب','monitor_heart','hyper'),('19','خفقان القلب','monitor_heart','hyper'),('2','الإرهاق الشديد','battery_alert','hypo'),('20','التعرق الزائد','water_drop','hyper'),('21','رعشة اليد','pan_tool','hyper'),('22','توتر وقلق','psychology','hyper'),('23','تقلبات مزاجية','mood_bad','hyper'),('24','الأرق','bedtime','hyper'),('25','الإسهال المتكرر','airline_seat_legroom_reduced','hyper'),('26','عدم تحمل الحرارة','thermostat','hyper'),('27','جحوظ العينين','remove_red_eye','hyper'),('28','نشاط زائد / فرط حركة','directions_run','hyper'),('29','ضعف العضلات','fitness_center','hyper'),('3','بطء ضربات القلب','monitor_heart','hypo'),('30','اضطراب الدورة الشهرية','wc','hyper'),('31','تساقط الشعر','content_cut','hyper'),('32','تضخم الغدة (تورم بالرقبة)','person_pin','hyper'),('4','الاكتئاب','sentiment_dissatisfied','hypo'),('5','بطء التفكير وضعف التركيز','psychology_alt','hypo'),('6','جفاف الجلد','dry_cleaning','hypo'),('7','تساقط الشعر','content_cut','hypo'),('8','الحساسية للبرد','ac_unit','hypo'),('9','الإمساك','airline_seat_legroom_reduced','hypo');
/*!40000 ALTER TABLE `symptoms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Test User','test@test.com','$2y$10$9iveIqxUNQWhPjnFgprhNOwrKGxk0TliPYqDhDf1VtRJmZCf.SNSW','2026-05-08 13:32:27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-08 21:10:49


SET FOREIGN_KEY_CHECKS = 1;
