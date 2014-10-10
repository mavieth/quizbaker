-- * This Source Code Form is subject to the terms of the Mozilla Public
-- * License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- * You can obtain one at http://mozilla.org/MPL/2.0/. */

-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 10, 2014 at 07:06 PM
-- Server version: 5.1.36
-- PHP Version: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `quizmaker`
--
CREATE DATABASE `quizmaker` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `quizmaker`;

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE IF NOT EXISTS `quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`id`, `name`) VALUES
(1, 'Quiz1');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_detail`
--

CREATE TABLE IF NOT EXISTS `quiz_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `summary_id` int(11) NOT NULL,
  `lastmodified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date` datetime DEFAULT NULL,
  `score` varchar(50) DEFAULT NULL,
  `interaction_id` varchar(50) DEFAULT NULL,
  `objective_id` varchar(50) DEFAULT NULL,
  `interaction_type` varchar(50) DEFAULT NULL,
  `student_response` text,
  `result` varchar(50) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `latency` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Results for 1 participant' AUTO_INCREMENT=1 ;

--
-- Dumping data for table `quiz_detail`
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Summary of the quiz results for 1 participant' AUTO_INCREMENT=5 ;

--
-- Dumping data for table `quiz_summary`
--

INSERT INTO `quiz_summary` (`id`, `quiz_id`, `lastmodified`, `network_id`, `status`, `raw_score`, `passing_score`, `max_score`, `min_score`, `time`) VALUES
(4, 1, '2011-12-04 19:00:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
