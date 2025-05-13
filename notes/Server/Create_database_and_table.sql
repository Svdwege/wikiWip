/******************************************************************
 * @file    Create_database_and_table.sql
 * 
 * @brief   This script is used to create the Hydromotive database,
 *          and the table.
 *
 *          This script could be used as a template to create new
 *          tables.
 *
 * @version  2.1.0
 *
 * @author  Julian Janssen
 * @date    6-4-2025
 *
 * @copyright Copyright (c) 2025 Julian Janssen. All rights reserved.
 ******************************************************************/

# Create a test database if it does not exist
CREATE DATABASE IF NOT EXISTS hydromotive_2025;

# Select the test database
USE hydromotive_2025;

CREATE TABLE IF NOT EXISTS `test_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seq_num` int DEFAULT NULL,
  `timestamp` datetime(3) DEFAULT NULL COMMENT 'Example format: "2025-04-13 10:29:30.100"',
 
  `acc_x` smallint DEFAULT NULL COMMENT 'From JSON vehicle, 16 bit signed integer',
  `acc_y` smallint DEFAULT NULL COMMENT 'From JSON vehicle, 16 bit signed integer',
  `acc_z` smallint DEFAULT NULL COMMENT 'From JSON vehicle, 16 bit signed integer',
  `thr_paddle` tinyint unsigned DEFAULT NULL COMMENT 'From JSON vehicle, Range 0 to 100 [%]',
  
  `mot_power` smallint DEFAULT NULL COMMENT 'From JSON motor, Range -1000 to 1000 [w]',
  `mot_rpm` smallint DEFAULT NULL COMMENT 'From JSON motor, Range -10000 to +10000 [rpm]',
  `mot_torque` smallint DEFAULT NULL COMMENT 'From JSON motor, Range -100 to +100 [nm]',

  `supcap_volt` decimal(5, 1) DEFAULT NULL COMMENT 'From JSON spectronik, Range 0,0 to 100,0 [v], 1 decimal',
  `tank_press` decimal(6, 2) DEFAULT NULL COMMENT 'From JSON spectronik, Range 0,00 to 500,00 [bar], 2 decimals',
  `fan` tinyint unsigned DEFAULT NULL COMMENT 'From JSON spectronik, Range 0 to 100 [%]',
  `h2_sens_p1` decimal(3, 2) DEFAULT NULL COMMENT 'From JSON spectronik, Range 0,00 to 1,00 [bar], typical 0.5 bar, 2 decimals',
  `h2_sens_p2` decimal(3, 2) DEFAULT NULL COMMENT 'From JSON spectronik, Range 0,00 to 1,00 [bar], typical 0.5 bar, 2 decimals',

  PRIMARY KEY (`id`),
  KEY `seq_num` (`seq_num`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT= 'This is an testtable for testing the telemetry unit';
