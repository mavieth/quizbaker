-- * This Source Code Form is subject to the terms of the Mozilla Public
-- * License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- * You can obtain one at http://mozilla.org/MPL/2.0/. */

-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 04, 2011 at 01:33 PM
-- Server version: 5.1.36
-- PHP Version: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `quizmaker`
--

-- --------------------------------------------------------

--
-- Table structure for table `quiz_summary`
--

CREATE TABLE IF NOT EXISTS `quiz_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) NOT NULL,
  `lastmodified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `network_id` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `raw_score` varchar(50) DEFAULT NULL,
  `passing_score` varchar(50) DEFAULT NULL,
  `max_score` varchar(50) DEFAULT NULL,
  `min_score` varchar(50) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Summary of the quiz results for 1 participant' AUTO_INCREMENT=1 ;

--
-- Dumping data for table `quiz_summary`
--

