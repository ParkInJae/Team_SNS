-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: sns
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alarm`
--

DROP TABLE IF EXISTS `alarm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alram` (
  `alno` int NOT NULL AUTO_INCREMENT,
  `uno` int NOT NULL,
  `rdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` varchar(1) NOT NULL DEFAULT 'N' COMMENT '조회안함 - N\n조회함    - Y',
  `type` varchar(1) NOT NULL DEFAULT 'M' COMMENT 'M - 메시지\nF - 알람 -> 팔로우\nL - 알람 -> 좋아요\nC - 알람 -> 신고\nR - 알람 -> 댓글\n',
  `no` int NOT NULL,
  PRIMARY KEY (`alno`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alarm`
--

LOCK TABLES `alarm` WRITE;
/*!40000 ALTER TABLE `alarm` DISABLE KEYS */;
INSERT INTO `alarm` VALUES (1,6,'2024-11-06 06:20:39','N','F',11),(2,7,'2024-11-06 06:20:39','N','L',11),(3,8,'2024-11-06 06:20:39','N','F',4),(4,5,'2024-11-06 06:20:39','N','L',13),(5,6,'2024-11-06 06:20:39','N','L',14),(6,10,'2024-11-06 06:20:39','N','F',11),(7,8,'2024-11-08 06:12:40','N','R',1),(8,8,'2024-11-08 06:22:59','N','L',7),(9,8,'2024-11-08 06:32:31','N','C',1);
/*!40000 ALTER TABLE `alarm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attach`
--

DROP TABLE IF EXISTS `attach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attach` (
  `ano` int NOT NULL AUTO_INCREMENT,
  `pname` varchar(50) NOT NULL,
  `fname` varchar(200) DEFAULT NULL,
  `bno` int NOT NULL,
  PRIMARY KEY (`ano`),
  KEY `bno` (`bno`),
  CONSTRAINT `attach_ibfk_1` FOREIGN KEY (`bno`) REFERENCES `board` (`bno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attach`
--

LOCK TABLES `attach` WRITE;
/*!40000 ALTER TABLE `attach` DISABLE KEYS */;
INSERT INTO `attach` VALUES (1,'c6167aeb-daf8-4c69-bde0-f3bc96fc4551','강아지.png',1),(2,'4dca7ed3-a216-4061-a0d9-d2c07edb3519','날씨.jpg',2),(3,'74d3f35a-40d8-4f81-8072-3d08a114682e','네오3.jpg',11),(4,'2b3efe40-2cef-4f52-8742-34d5524203a3','양식.jpg',12),(5,'a377e0da-3b64-4abf-8491-05dfff8ed972','베리발.jpg',13),(6,'c51b9a6c-0ead-4975-b61f-732eef3538a2','판다.jfif',14);
/*!40000 ALTER TABLE `attach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `bno` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `hit` int NOT NULL DEFAULT '0',
  `state` char(1) NOT NULL DEFAULT 'E' COMMENT 'E-활성화\nD-비활성화',
  `rdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text NOT NULL,
  `uno` int NOT NULL,
  PRIMARY KEY (`bno`),
  KEY `uno` (`uno`),
  CONSTRAINT `board_ibfk_1` FOREIGN KEY (`uno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (1,'뛰는 강아지',13,'D','2024-11-06 00:37:18','활발한 강아지',100),(2,'날이 좋아요',4,'D','2024-11-06 00:55:02','굳',1),(3,'안녕하세요',0,'E','2024-11-06 02:58:53','강민준의 첫 번째 게시글입니다. 안녕하세요!',5),(4,'반갑습니다',0,'E','2024-11-06 02:58:53','박서연의 첫 번째 게시글입니다. 반갑습니다.',6),(5,'나눠요',0,'E','2024-11-06 02:58:53','김지후의 생각을 나눠봅니다.',7),(6,'최신입니다',0,'E','2024-11-06 02:58:53','이하은의 최신 게시글입니다.',8),(7,'환영합니다',0,'E','2024-11-06 02:58:53','정우진의 첫 게시글입니다. 환영합니다!',9),(8,'확인하세요',0,'E','2024-11-06 02:58:53','홍길동의 멋진 인사이트를 확인하세요.',10),(9,'좋은 하루 되세요',0,'E','2024-11-06 02:58:53','강민준의 두 번째 게시글입니다. 좋은 하루 되세요!',5),(10,'공유합니다',0,'E','2024-11-06 02:58:53','박서연의 여행 기록을 공유합니다.',6),(11,'네오임다',2,'D','2024-11-06 05:51:44','네오네오',5),(12,'맛있어보입니다',5,'E','2024-11-06 06:16:32','냠냠',6),(13,'존잘 축구선수',7,'E','2024-11-06 06:18:45','ㄷㄷ',8),(14,'판다들',6,'E','2024-11-06 06:20:22','판다',9);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `cno` int NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `rdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` char(1) NOT NULL DEFAULT 'E' COMMENT 'E-활성화\nD-비활성화',
  `bno` int NOT NULL,
  `uno` int NOT NULL,
  PRIMARY KEY (`cno`),
  KEY `bno` (`bno`),
  KEY `uno` (`uno`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`bno`) REFERENCES `board` (`bno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`uno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'강아지 귀엽네요.','2024-11-06 00:37:32','E',6,100),(2,'좋구만.','2024-11-06 00:55:11','E',2,1),(3,'귀엽네요.','2024-11-06 06:39:38','E',14,10),(4,'ㅗㅗ','2024-11-06 06:39:55','E',13,10),(5,'ㄴㄴㄴㄴ','2024-11-06 06:40:04','E',12,10);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaint_board`
--

DROP TABLE IF EXISTS `complaint_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaint_board` (
  `cpno` int NOT NULL AUTO_INCREMENT,
  `bno` int NOT NULL,
  `uno` int NOT NULL,
  PRIMARY KEY (`cpno`),
  KEY `bno` (`bno`),
  KEY `uno` (`uno`),
  CONSTRAINT `complaint_board_ibfk_1` FOREIGN KEY (`bno`) REFERENCES `board` (`bno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `complaint_board_ibfk_2` FOREIGN KEY (`uno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaint_board`
--

LOCK TABLES `complaint_board` WRITE;
/*!40000 ALTER TABLE `complaint_board` DISABLE KEYS */;
INSERT INTO `complaint_board` VALUES (1,13,6);
/*!40000 ALTER TABLE `complaint_board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow`
--

DROP TABLE IF EXISTS `follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow` (
  `fno` int NOT NULL AUTO_INCREMENT,
  `uno` int NOT NULL,
  `tuno` int NOT NULL,
  PRIMARY KEY (`fno`),
  KEY `tuno` (`tuno`),
  KEY `uno` (`uno`),
  CONSTRAINT `follow_ibfk_1` FOREIGN KEY (`tuno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `follow_ibfk_2` FOREIGN KEY (`uno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow`
--

LOCK TABLES `follow` WRITE;
/*!40000 ALTER TABLE `follow` DISABLE KEYS */;
INSERT INTO `follow` VALUES (1,5,6),(2,5,7),(3,6,5),(4,7,8),(5,8,9),(6,9,10),(7,10,5),(8,7,5),(9,8,6);
/*!40000 ALTER TABLE `follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `love`
--

DROP TABLE IF EXISTS `love`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `love` (
  `lno` int NOT NULL AUTO_INCREMENT,
  `bno` int NOT NULL,
  `uno` int NOT NULL,
  PRIMARY KEY (`lno`),
  KEY `bno` (`bno`),
  KEY `uno` (`uno`),
  CONSTRAINT `love_ibfk_1` FOREIGN KEY (`bno`) REFERENCES `board` (`bno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `love_ibfk_2` FOREIGN KEY (`uno`) REFERENCES `user` (`uno`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `love`
--

LOCK TABLES `love` WRITE;
/*!40000 ALTER TABLE `love` DISABLE KEYS */;
INSERT INTO `love` VALUES (1,3,6),(2,4,7),(3,5,5),(4,7,8),(5,8,9),(6,3,10),(7,6,100),(8,7,6);
/*!40000 ALTER TABLE `love` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `uno` int NOT NULL AUTO_INCREMENT,
  `uid` varchar(12) NOT NULL,
  `upw` varchar(200) NOT NULL,
  `unick` varchar(20) NOT NULL,
  `uemail` varchar(100) NOT NULL,
  `urdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uauthor` char(1) NOT NULL DEFAULT 'U' COMMENT 'U-유저\nA-관리자',
  `pname` varchar(50) DEFAULT NULL,
  `fname` varchar(200) DEFAULT NULL,
  `ustate` char(1) NOT NULL DEFAULT 'E' COMMENT '활성화-E\n비활성화-D',
  PRIMARY KEY (`uno`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `unick` (`unick`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','3ee6dfaa6cdff2423535288db75eea4c','관리자','ezen@ezen.com','2024-11-05 08:21:37','A','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(2,'ezen','81dc9bdb52d04dc20036dbd8313ed055','이젠','ezen@ezne.com','2024-11-05 08:22:16','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(3,'hong','81dc9bdb52d04dc20036dbd8313ed055','길동','gildong@ezen.com','2024-11-05 08:46:23','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(4,'honggildong','ed2b1f468c5f915f3f1cf75d7068baae','홍홍','honggildong@ezen.com','2024-11-05 08:46:23','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(5,'kangminjoon','81dc9bdb52d04dc20036dbd8313ed055','강민준','kangmj@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(6,'parkseoyeon','81dc9bdb52d04dc20036dbd8313ed055','박서연','parkse@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(7,'kimjihoo','81dc9bdb52d04dc20036dbd8313ed055','김지후','kimjh@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(8,'leehaeun','81dc9bdb52d04dc20036dbd8313ed055','이하은','leeh@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(9,'jungwoojin','81dc9bdb52d04dc20036dbd8313ed055','정우진','jungwj@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(10,'honggildong1','81dc9bdb52d04dc20036dbd8313ed055','홍길동','honggd@example.com','2024-11-06 02:53:13','U','824b86d0-ee27-45ce-9e69-c8dac327861a',NULL,'E'),(100,'dong','81dc9bdb52d04dc20036dbd8313ed055','dong','tank102124@naver.com','2024-11-06 00:35:23','U','824b86d0-ee27-45ce-9e69-c8dac327861a','라이언1.jpg','E');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-09 11:18:28
