-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: opd_db
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
-- Table structure for table `appointed_relatives`
--

DROP TABLE IF EXISTS `appointed_relatives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointed_relatives` (
  `relationship_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_user_id` int(11) NOT NULL,
  `relative_user_id` int(11) NOT NULL,
  `relationship_type` varchar(50) NOT NULL COMMENT 'e.g., Guardian, Spouse, Child',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`relationship_id`),
  UNIQUE KEY `unique_relationship` (`patient_user_id`,`relative_user_id`),
  KEY `relative_user_id` (`relative_user_id`),
  CONSTRAINT `appointed_relatives_ibfk_1` FOREIGN KEY (`patient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `appointed_relatives_ibfk_2` FOREIGN KEY (`relative_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointed_relatives`
--

LOCK TABLES `appointed_relatives` WRITE;
/*!40000 ALTER TABLE `appointed_relatives` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointed_relatives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL AUTO_INCREMENT,
  `booked_by_user_id` int(11) DEFAULT NULL,
  `relative_id` int(11) DEFAULT NULL,
  `patient_type` varchar(10) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `given_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `birthday` date NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `civil_status` enum('Single','Married','Widowed','Divorced','Separated') DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) NOT NULL,
  `address` text DEFAULT NULL,
  `opd_no` varchar(50) DEFAULT NULL,
  `last_checkup_date` date DEFAULT NULL,
  `reason_for_visit` text NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `attachment_path` varchar(255) DEFAULT NULL,
  `preferred_date` date NOT NULL,
  `preferred_time` time DEFAULT NULL,
  `status` enum('Pending','Assigned','Accepted','Rejected','Completed') NOT NULL DEFAULT 'Pending',
  `assigned_doctor_id` int(11) DEFAULT NULL,
  `assigned_room_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`appointment_id`),
  KEY `booked_by_user_id` (`booked_by_user_id`),
  KEY `relative_id` (`relative_id`),
  KEY `assigned_doctor_id` (`assigned_doctor_id`),
  KEY `assigned_room_id` (`assigned_room_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`booked_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`relative_id`) REFERENCES `patient_relatives` (`relative_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`assigned_doctor_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_4` FOREIGN KEY (`assigned_room_id`) REFERENCES `rooms` (`room_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (10,4,NULL,'New','mendoza','anthony','orande','2003-10-30','Male',NULL,NULL,'+639641622778','049, sitio pulo Barangay Zarah san luis Aurora',NULL,NULL,'kjh','Family Medicine','uploads/attachments/mendoza.anthony.o_1764639623682_mendoza.anthony.o_1764316749703_Screenshot_26-11-2025_202139_localhost.jpeg','2025-12-03',NULL,'Accepted',10,1,'2025-12-02 01:40:23');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `action` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'admin','Super Admin','User logged in','2025-11-26 22:47:20'),(2,1,'admin','Super Admin','Created new admin account: orande.sam.p','2025-11-26 22:47:42'),(3,2,'orande.sam.p','Admin','User logged in','2025-11-26 22:48:31'),(4,2,'orande.sam.p','Admin','Created new staff account: orande.pavio.t','2025-11-26 22:49:29'),(5,3,'orande.pavio.t','Staff','User logged in','2025-11-26 22:53:12'),(6,4,'mendoza.anthony.o','Patient','User logged in','2025-11-26 23:00:17'),(7,4,'mendoza.anthony.o','Patient','User logged in','2025-11-26 23:07:56'),(8,3,'orande.pavio.t','Staff','User logged in','2025-11-26 23:13:11'),(9,4,'mendoza.anthony.o','Patient','User logged in','2025-11-26 23:19:12'),(10,3,'orande.pavio.t','Staff','User logged in','2025-11-26 23:19:47'),(11,3,'orande.pavio.t','Staff','User logged in','2025-11-26 23:35:14'),(12,3,'orande.pavio.t','Staff','User logged in','2025-11-26 23:38:52'),(13,3,'orande.pavio.t','Staff','User logged in','2025-11-26 23:47:59'),(14,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 00:33:58'),(15,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 00:53:37'),(16,3,'orande.pavio.t','Staff','User logged in','2025-11-27 00:54:54'),(17,3,'orande.pavio.t','Staff','User logged in','2025-11-27 01:28:40'),(18,3,'orande.pavio.t','Staff','User logged in','2025-11-27 01:38:47'),(19,3,'orande.pavio.t','Staff','User logged in','2025-11-27 01:42:44'),(20,3,'orande.pavio.t','Staff','User logged in','2025-11-27 01:48:20'),(21,3,'orande.pavio.t','Staff','User logged in','2025-11-27 01:59:13'),(22,3,'orande.pavio.t','Staff','User logged in','2025-11-27 02:08:22'),(23,3,'orande.pavio.t','Staff','User logged in','2025-11-27 02:11:15'),(24,3,'orande.pavio.t','Staff','User logged in','2025-11-27 02:40:07'),(25,3,'orande.pavio.t','Staff','User logged in','2025-11-27 02:54:16'),(26,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 03:27:13'),(27,3,'orande.pavio.t','Staff','User logged in','2025-11-27 03:29:03'),(28,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 03:56:02'),(29,3,'orande.pavio.t','Staff','User logged in','2025-11-27 03:57:03'),(30,3,'orande.pavio.t','Staff','User logged in','2025-11-27 04:02:14'),(31,3,'orande.pavio.t','Staff','User logged in','2025-11-27 04:34:09'),(32,3,'orande.pavio.t','Staff','User logged in','2025-11-27 04:37:38'),(33,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 04:39:21'),(34,3,'orande.pavio.t','Staff','User logged in','2025-11-27 04:40:02'),(35,2,'orande.sam.p','Admin','User logged in','2025-11-27 05:16:49'),(36,2,'orande.sam.p','Admin','User logged in','2025-11-27 05:24:24'),(37,2,'orande.sam.p','Admin','User logged in','2025-11-27 05:32:09'),(38,2,'orande.sam.p','Admin','User logged in','2025-11-27 05:43:04'),(39,2,'orande.sam.p','Admin','User logged in','2025-11-27 05:52:44'),(40,2,'orande.sam.p','Admin','User logged in','2025-11-27 06:22:07'),(41,2,'orande.sam.p','Admin','User logged in','2025-11-27 06:53:16'),(42,2,'orande.sam.p','Admin','User logged in','2025-11-27 07:01:23'),(43,2,'orande.sam.p','Admin','User logged in','2025-11-27 07:09:58'),(44,2,'orande.sam.p','Admin','Created new doctor account: buencamino.siimmonn','2025-11-27 07:11:06'),(45,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 07:16:24'),(46,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 07:19:06'),(47,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 07:21:10'),(48,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 07:29:55'),(49,3,'orande.pavio.t','Staff','User logged in','2025-11-27 07:32:33'),(50,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 07:50:14'),(51,2,'orande.sam.p','Admin','User logged in','2025-11-27 07:50:49'),(52,2,'orande.sam.p','Admin','User logged in','2025-11-27 08:07:02'),(53,2,'orande.sam.p','Admin','Updated own profile information','2025-11-27 08:07:37'),(54,2,'orande.sam.p','Admin','User logged in','2025-11-27 08:12:16'),(55,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 08:18:09'),(56,3,'orande.pavio.t','Staff','User logged in','2025-11-27 08:20:24'),(57,2,'orande.sam.p','Admin','User logged in','2025-11-27 08:52:57'),(58,3,'orande.pavio.t','Staff','User logged in','2025-11-27 08:56:59'),(59,3,'orande.pavio.t','Staff','Updated own profile information','2025-11-27 09:05:16'),(60,3,'orande.pavio.t','Staff','Updated own profile information','2025-11-27 09:09:28'),(61,3,'orande.pavio.t','Staff','User logged in','2025-11-27 09:13:06'),(62,3,'orande.pavio.t','Staff','User logged in','2025-11-27 09:19:24'),(63,3,'orande.pavio.t','Staff','User logged in','2025-11-27 09:23:05'),(64,3,'orande.pavio.t','Staff','User logged in','2025-11-27 09:25:22'),(65,3,'orande.pavio.t','Staff','User logged in','2025-11-27 09:30:33'),(66,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 09:33:22'),(67,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 09:55:42'),(68,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 09:59:35'),(69,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 10:02:36'),(70,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 10:17:17'),(71,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:17:56'),(72,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:21:43'),(73,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:28:18'),(74,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:38:21'),(75,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:41:55'),(76,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 10:42:43'),(77,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 10:46:36'),(78,3,'orande.pavio.t','Staff','User logged in','2025-11-27 10:47:18'),(79,3,'orande.pavio.t','Staff','User logged in','2025-11-27 11:23:57'),(80,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 11:24:46'),(81,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 11:33:19'),(82,3,'orande.pavio.t','Staff','User logged in','2025-11-27 11:36:22'),(83,3,'orande.pavio.t','Staff','User logged in','2025-11-27 12:09:50'),(84,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 12:15:22'),(85,3,'orande.pavio.t','Staff','User logged in','2025-11-27 12:31:03'),(86,3,'orande.pavio.t','Staff','User logged in','2025-11-27 12:46:17'),(87,3,'orande.pavio.t','Staff','User logged in','2025-11-27 12:56:12'),(88,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 13:12:33'),(89,3,'orande.pavio.t','Staff','User logged in','2025-11-27 13:13:17'),(90,3,'orande.pavio.t','Staff','User logged in','2025-11-27 13:23:23'),(91,3,'orande.pavio.t','Staff','User logged in','2025-11-27 13:27:03'),(92,3,'orande.pavio.t','Staff','User logged in','2025-11-27 13:30:45'),(93,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 13:41:16'),(94,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 13:46:04'),(95,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 13:57:04'),(96,3,'orande.pavio.t','Staff','User logged in','2025-11-27 21:30:37'),(97,3,'orande.pavio.t','Staff','User logged in','2025-11-27 21:51:42'),(98,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:02:09'),(99,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:15:20'),(100,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:19:29'),(101,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:23:27'),(102,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:27:23'),(103,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:33:27'),(104,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:42:26'),(105,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:49:29'),(106,3,'orande.pavio.t','Staff','User logged in','2025-11-27 22:51:44'),(107,3,'orande.pavio.t','Staff','User logged in','2025-11-27 23:18:07'),(108,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 23:24:10'),(109,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 23:29:45'),(110,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 23:32:47'),(111,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-27 23:38:25'),(112,4,'mendoza.anthony.o','Patient','User logged in','2025-11-27 23:45:59'),(113,3,'orande.pavio.t','Staff','User logged in','2025-11-27 23:49:09'),(114,3,'orande.pavio.t','Staff','User logged in','2025-11-28 00:03:00'),(115,3,'orande.pavio.t','Staff','User logged in','2025-11-28 00:12:47'),(116,3,'orande.pavio.t','Staff','User logged in','2025-11-28 00:46:34'),(117,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:04:16'),(118,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:16:48'),(119,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:24:14'),(120,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:34:03'),(121,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:38:27'),(122,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:48:23'),(123,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:50:24'),(124,3,'orande.pavio.t','Staff','User logged in','2025-11-28 01:55:27'),(125,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:03:14'),(126,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:07:17'),(127,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:13:31'),(128,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:22:29'),(129,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:25:09'),(130,3,'orande.pavio.t','Staff','User logged in','2025-11-28 02:33:22'),(131,4,'mendoza.anthony.o','Patient','User logged in','2025-11-28 02:36:41'),(132,1,'admin','Super Admin','User logged in','2025-11-28 02:42:34'),(133,2,'orande.sam.p','Admin','User logged in','2025-11-28 02:43:15'),(134,2,'orande.sam.p','Admin','User logged in','2025-11-28 02:54:55'),(135,2,'orande.sam.p','Admin','User logged in','2025-11-28 02:57:52'),(136,2,'orande.sam.p','Admin','User logged in','2025-11-28 05:30:20'),(137,2,'orande.sam.p','Admin','Created new staff account: buencamino.sarie.o','2025-11-28 05:35:48'),(138,1,'admin','Super Admin','User logged in','2025-11-28 05:36:47'),(139,1,'admin','Super Admin','User logged in','2025-11-28 05:51:06'),(140,1,'admin','Super Admin','User logged in','2025-11-28 05:56:13'),(141,1,'admin','Super Admin','User logged in','2025-11-28 06:07:22'),(142,2,'orande.sam.p','Admin','User logged in','2025-11-28 06:15:45'),(143,1,'admin','Super Admin','User logged in','2025-11-28 06:24:45'),(144,2,'orande.sam.p','Admin','User logged in','2025-11-28 06:25:21'),(145,3,'orande.pavio.t','Staff','User logged in','2025-11-28 06:26:22'),(146,3,'orande.pavio.t','Staff','Updated own profile information','2025-11-28 06:28:22'),(147,1,'admin','Super Admin','User logged in','2025-11-28 07:05:34'),(148,1,'admin','Super Admin','User logged in','2025-11-28 07:10:13'),(149,2,'orande.sam.p','Admin','User logged in','2025-11-28 07:10:41'),(150,4,'mendoza.anthony.o','Patient','User logged in','2025-11-28 07:11:55'),(151,3,'orande.pavio.t','Staff','User logged in','2025-11-28 07:35:25'),(152,4,'mendoza.anthony.o','Patient','User logged in','2025-11-28 07:56:32'),(153,3,'orande.pavio.t','Staff','User logged in','2025-11-28 08:03:42'),(154,3,'orande.pavio.t','Staff','Updated own profile information','2025-11-28 08:07:15'),(155,10,'buencamino.siimmonn','Doctor','User logged in','2025-11-28 08:08:07'),(156,2,'orande.sam.p','Admin','User logged in','2025-11-28 08:09:40'),(157,2,'orande.sam.p','Admin','Archived user account with ID: 3','2025-11-28 08:12:55'),(158,2,'orande.sam.p','Admin','User logged in','2025-11-28 08:13:45'),(159,1,'admin','Super Admin','User logged in','2025-11-28 08:14:24'),(160,1,'admin','Super Admin','Restored user with ID: 3','2025-11-28 08:15:02'),(161,1,'admin','Super Admin','Restored database from file: opd_db_backup_2025-11-28_16-15-15.sql','2025-11-28 08:15:53'),(162,2,'orande.sam.p','Admin','User logged in','2025-11-28 13:43:28'),(163,2,'orande.sam.p','Admin','Updated own profile information','2025-11-28 13:46:25'),(164,1,'admin','Super Admin','User logged in','2025-11-28 13:48:40'),(165,1,'admin','Super Admin','User logged in','2025-11-28 13:59:24'),(166,1,'admin','Super Admin','User logged in','2025-11-28 14:06:39'),(167,1,'admin','Super Admin','User logged in','2025-11-28 14:11:26'),(168,1,'admin','Super Admin','User logged in','2025-11-28 14:13:52'),(169,1,'admin','Super Admin','User logged in','2025-11-28 15:37:04'),(170,1,'admin','Super Admin','User logged in','2025-11-28 15:47:10'),(171,1,'admin','Super Admin','User logged in','2025-11-28 16:06:14'),(172,1,'admin','Super Admin','User logged in','2025-11-28 16:12:28'),(173,1,'admin','Super Admin','User logged in','2025-11-28 16:21:58'),(174,1,'admin','Super Admin','User logged in','2025-11-28 16:25:08'),(175,1,'admin','Super Admin','User logged in','2025-11-28 16:31:00'),(176,1,'admin','Super Admin','User logged in','2025-11-28 16:37:11'),(177,1,'admin','Super Admin','User logged in','2025-11-28 16:54:21'),(178,1,'admin','Super Admin','User logged in','2025-11-28 16:57:49'),(179,1,'admin','Super Admin','User logged in','2025-11-28 17:12:32'),(180,1,'admin','Super Admin','User logged in','2025-11-28 17:20:06'),(181,1,'admin','Super Admin','User logged in','2025-11-28 17:22:31'),(182,1,'admin','Super Admin','Updated own profile information','2025-11-28 17:22:37'),(183,1,'admin','Super Admin','Updated own profile with new contact number/password','2025-11-28 17:24:18'),(184,3,'orande.pavio.t','Staff','User logged in','2025-11-28 18:08:31'),(185,3,'orande.pavio.t','Staff','User logged in','2025-11-28 18:31:02'),(186,1,'admin','Super Admin','User logged in','2025-11-30 07:39:01'),(187,3,'orande.pavio.t','Staff','User logged in','2025-11-30 07:47:31'),(188,1,'admin','Super Admin','User logged in','2025-11-30 09:37:07'),(189,3,'orande.pavio.t','Staff','User logged in','2025-11-30 09:41:47'),(190,1,'admin','Super Admin','User logged in','2025-11-30 13:43:55'),(191,4,'mendoza.anthony.o','Patient','User logged in','2025-11-30 14:05:31'),(192,1,'admin','Super Admin','User logged in','2025-11-30 22:22:04'),(193,1,'admin','Super Admin','User logged in','2025-11-30 22:34:10'),(194,2,'orande.sam.p','Admin','User logged in','2025-12-01 16:12:18'),(195,2,'orande.sam.p','Admin','Updated own profile information','2025-12-01 16:12:51'),(196,1,'admin','Super Admin','User logged in','2025-12-01 17:38:28'),(197,2,'orande.sam.p','Admin','User logged in','2025-12-01 17:52:27'),(198,2,'orande.sam.p','Admin','Updated own profile information','2025-12-01 18:01:18'),(199,2,'orande.sam.p','Admin','User logged in','2025-12-01 18:02:40'),(200,3,'orande.pavio.t','Staff','User logged in','2025-12-02 00:37:43'),(201,4,'mendoza.anthony.o','Patient','User logged in','2025-12-02 01:22:48'),(202,4,'mendoza.anthony.o','Patient','User logged in','2025-12-02 01:36:08'),(203,3,'orande.pavio.t','Staff','User logged in','2025-12-02 01:40:50'),(204,4,'mendoza.anthony.o','Patient','User logged in','2025-12-02 01:42:59'),(205,10,'buencamino.siimmonn','Doctor','User logged in','2025-12-02 01:44:41'),(206,4,'mendoza.anthony.o','Patient','User logged in','2025-12-02 04:29:17'),(207,2,'orande.sam.p','Admin','User logged in','2025-12-02 06:50:47'),(208,1,'admin','Super Admin','User logged in','2025-12-02 06:52:54'),(209,1,'admin','Super Admin','User logged in','2025-12-02 07:05:08'),(210,1,'admin','Super Admin','Archived Admin user with ID: 2','2025-12-02 07:06:30'),(211,1,'admin','Super Admin','Restored database from file: opd_db_backup_2025-12-02_15-08-02.sql','2025-12-02 07:09:28');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_reports`
--

DROP TABLE IF EXISTS `daily_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `daily_reports` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `report_date` (`report_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_reports`
--

LOCK TABLES `daily_reports` WRITE;
/*!40000 ALTER TABLE `daily_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `designations`
--

DROP TABLE IF EXISTS `designations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `designations` (
  `designation_id` int(11) NOT NULL AUTO_INCREMENT,
  `designation_name` varchar(255) NOT NULL,
  PRIMARY KEY (`designation_id`),
  UNIQUE KEY `designation_name` (`designation_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `designations`
--

LOCK TABLES `designations` WRITE;
/*!40000 ALTER TABLE `designations` DISABLE KEYS */;
INSERT INTO `designations` VALUES (5,'Billing Staff'),(2,'Medical Technologist'),(1,'Nurse'),(3,'Pharmacist'),(4,'Receptionist'),(6,'Utility');
/*!40000 ALTER TABLE `designations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `months`
--

DROP TABLE IF EXISTS `months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `months` (
  `month_num` int(11) NOT NULL,
  `month_name` varchar(20) NOT NULL,
  PRIMARY KEY (`month_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `months`
--

LOCK TABLES `months` WRITE;
/*!40000 ALTER TABLE `months` DISABLE KEYS */;
INSERT INTO `months` VALUES (1,'January'),(2,'February'),(3,'March'),(4,'April'),(5,'May'),(6,'June'),(7,'July'),(8,'August'),(9,'September'),(10,'October'),(11,'November'),(12,'December');
/*!40000 ALTER TABLE `months` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_type_target` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `link` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_relatives`
--

DROP TABLE IF EXISTS `patient_relatives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_relatives` (
  `relative_id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_user_id` int(11) NOT NULL,
  `relationship` varchar(50) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `given_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `current_address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`relative_id`),
  KEY `patient_user_id` (`patient_user_id`),
  CONSTRAINT `patient_relatives_ibfk_1` FOREIGN KEY (`patient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_relatives`
--

LOCK TABLES `patient_relatives` WRITE;
/*!40000 ALTER TABLE `patient_relatives` DISABLE KEYS */;
INSERT INTO `patient_relatives` VALUES (1,4,'Guardian','buencamino','Sarie','Orande','09158076933','2015-10-30','Female','Roman Catholic','049, sitio pulo Barangay Zarah san luis Aurora','049, sitio pulo Barangay Zarah san luis Aurora','San Luis','3201','2025-11-27 11:25:56');
/*!40000 ALTER TABLE `patient_relatives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_number` varchar(50) NOT NULL,
  `room_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_number` (`room_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'3','fghbn'),(2,'1','appointment desk');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) NOT NULL,
  `schedule_type` enum('Weekly','Monthly','Daily') NOT NULL,
  `schedule_details` varchar(255) NOT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Public Health Unit','Daily','Monday to Friday - 8am to 5pm','Ariel A. Bitong Jr. , RN, MD, MPA, MPH (Chief of Hospital)\nJomarie Aquino, RM (Health Educator)\nJudy Ann Julio, RPM, CHRA (Health Education & Promotion Officer)\nMarcelo Jr C. Alalag, RN (Unit Head)\nApril Tacianne Lucindo, RN (HESU Coordinator Unit Coordinator)'),(2,'Animal Bite Treatment Center','Weekly','Monday to Friday - 8am to 5pm','Pamela Aurora Erog-Erog, RN (Program Coordinator)'),(3,'Cough Center','Weekly','Monday to Friday - 8am to 5pm',NULL),(4,'Mental Health Clinic','Weekly','Monday to Friday - 8am to 5pm','Roberto Delarna Jr. , RN (Program Coordinator)'),(5,'Physical Therapy and Rehabilitation Unit','Weekly','Monday to Friday - 8am to 5pm',NULL),(6,'Adolescent Health Clinic','Weekly','Monday to Friday - 8am to 3pm','Jasmin Gutierrez, RN (Program Coordinator)'),(7,'Nutrition Clinic','Weekly','Monday to Friday - 8am to 3pm','Lorelie Shane Aragon, RN (Program Coordinator)'),(8,'General Surgery','Weekly','Monday to Friday - 8am to 3pm',NULL),(9,'Internal Medicine','Weekly','Monday to Friday - 8am to 3pm',NULL),(10,'General Medicine','Weekly','Monday to Friday - 8am to 3pm',NULL),(11,'Pediatric Medicine','Weekly','Monday to Friday - 8am to 3pm',NULL),(12,'ENT','Weekly','Monday to Friday - 8am to 3pm',NULL),(13,'Women\'s Health Clinic','Weekly','Every 2nd and 4th Wednesday of the month','Leiann Magsino, RN (Program Coordinator)'),(14,'Family Medicine','Weekly','Wednesday and Thursday - 8am to 3pm',NULL),(15,'Nephrology','Monthly','Once a month by schedule',NULL),(16,'Rheumatology','Monthly','Once a month by schedule',NULL),(17,'Neurology','Monthly','Once a month by schedule',NULL),(18,'Psychiatry','Monthly','Once a month by schedule',NULL),(19,'Rehabilitation Medicine','Monthly','Twice a month by appointment',NULL),(20,'Occupational Therapy','Monthly','Twice a month by appointment',NULL),(21,'Psychologist','Monthly','Once a month by schedule',NULL),(22,'Emergency Rooms','Daily','Open daily 24-hours','1. Immediate care for emergency cases\n2. Wound care (treatment for cuts, lacerations, and burns)\n3. Stabilization of patients\n4. Treatment of injuries (fractures, sprains, and dislocation)\n5. Pediatric emergency care\n6. OB cases emergency care\n7. Referrals from other health care facilities'),(23,'Dangerous Drug Assesment & Screening Clinic','Weekly','Monday to Friday - 8am to 5pm','Katherine Kris Apilado, RN (Program Coordinator)'),(24,'TB, DOTS Clinic','Weekly','Monday to Friday - 8am to 5pm','Yna Perfiñan, RN (Program Coordinator)');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specializations`
--

DROP TABLE IF EXISTS `specializations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `specializations` (
  `specialization_id` int(11) NOT NULL AUTO_INCREMENT,
  `specialization_name` varchar(255) NOT NULL,
  PRIMARY KEY (`specialization_id`),
  UNIQUE KEY `specialization_name` (`specialization_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specializations`
--

LOCK TABLES `specializations` WRITE;
/*!40000 ALTER TABLE `specializations` DISABLE KEYS */;
INSERT INTO `specializations` VALUES (1,'Cardiology'),(2,'Dermatology'),(7,'ENT'),(5,'General Surgery'),(6,'Internal Medicine'),(3,'Neurology'),(4,'Pediatrics'),(8,'vghbb');
/*!40000 ALTER TABLE `specializations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_profiles` (
  `profile_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `given_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `permanent_address` text NOT NULL,
  `current_address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `secondary_specialization` varchar(255) DEFAULT NULL,
  `license_number` varchar(100) DEFAULT NULL,
  `license_expiry_date` date DEFAULT NULL,
  `employee_id` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL COMMENT 'For Staff: e.g., Nurse, Receptionist',
  `profile_picture_path` varchar(255) DEFAULT 'uploads/profile_pictures/default_avatar.png',
  PRIMARY KEY (`profile_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employee_id` (`employee_id`),
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (1,1,'Admin','Super','A','1990-01-01','Male',NULL,NULL,'Hospital Main Office',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'uploads/profile_pictures/default_avatar.png'),(2,2,'orande','sam','padilla','2000-10-30','Male',NULL,NULL,'pulo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,3,'orande','pavio','tamara','2000-08-30','Male',NULL,NULL,'049, sitio pulo Barangay Zarah san luis Aurora',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'876535675879','Receptionist',NULL),(4,4,'mendoza','anthony','orande','2003-10-30','Male',22,'Roman Catholic','049, sitio pulo Barangay Zarah san luis Aurora','049, sitio pulo Barangay Zarah san luis Aurora ','San Luis','3201',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,10,'buencamino','siimmonn','orande','2000-10-20','Male',25,NULL,'049, sitio pulo Barangay Zarah san luis Aurora',NULL,NULL,NULL,'General Surgery','Cardiology','897937','2028-10-28',NULL,NULL,NULL),(6,11,'buencamino','sarie','orande','1979-12-12','Female',45,NULL,'zarah pulo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'087655467687','Medical Technologist',NULL);
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `status` enum('active','inactive','pending') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `session_id` varchar(100) DEFAULT NULL,
  `failed_login_attempts` int(11) NOT NULL DEFAULT 0,
  `account_locked_until` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `contact_number` (`contact_number`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','AN86oAzCCmDBPADz5bXKQjhujfYy+JPQ+zzawZ611Qw=','+639770972025','Super Admin','active','2025-11-26 22:41:02','2025-12-02 07:05:08',NULL,0,NULL),(2,'orande.sam.p','2Nn+IuH/igBnUCSg0wj51grKV0Bct3vr38pjl5KAxVI=','+639926791507','Admin','inactive','2025-11-26 22:47:41','2025-12-02 07:06:30',NULL,0,NULL),(3,'orande.pavio.t','vLypk5PeoKL00yahbDtvUFKt1fs7y4HlCg9EfoECxvc=','+639126074720','Staff','active','2025-11-26 22:49:29','2025-12-02 01:42:08',NULL,0,NULL),(4,'mendoza.anthony.o','2Nn+IuH/igBnUCSg0wj51grKV0Bct3vr38pjl5KAxVI=','+639998786213','Patient','active','2025-11-26 22:59:51','2025-12-02 04:45:09',NULL,0,NULL),(10,'buencamino.siimmonn','9mEThE9EHCG2x/BnO1eIhBT7wQBjY+DUHQIH5243Jl8=','+639318478074','Doctor','active','2025-11-27 07:11:05','2025-12-02 01:52:08',NULL,0,NULL),(11,'buencamino.sarie.o','BYS23pbQFXlQ/fc56awP02a3IyEUtkgGK7DnY1bD1fg=','+639158076933','Staff','active','2025-11-28 05:35:48','2025-11-28 05:35:48',NULL,0,NULL);
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

-- Dump completed on 2025-12-02 15:09:58
