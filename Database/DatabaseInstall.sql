-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 06, 2018 at 10:57 PM
-- Server version: 5.7.19
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `fireaid_personnel`
--
CREATE DATABASE IF NOT EXISTS `fireaid_personnel` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `fireaid_personnel`;

-- --------------------------------------------------------

--
-- Table structure for table `contractor`
--

DROP TABLE IF EXISTS `contractor`;
CREATE TABLE IF NOT EXISTS `contractor` (
  `idContractor` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(45) NOT NULL,
  `GivenNames` varchar(45) NOT NULL,
  `Surname` varchar(45) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `Gender` varchar(45) NOT NULL,
  `DateOfBirth` datetime NOT NULL,
  PRIMARY KEY (`idContractor`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_contact`
--

DROP TABLE IF EXISTS `emergency_contact`;
CREATE TABLE IF NOT EXISTS `emergency_contact` (
  `idEmergencyContact` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Relationship` varchar(45) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `fkContractor` int(11) NOT NULL,
  PRIMARY KEY (`idEmergencyContact`),
  KEY `fkPersonal_idx` (`fkContractor`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE IF NOT EXISTS `history` (
  `idHistory` int(11) NOT NULL AUTO_INCREMENT,
  `fkProject` int(11) NOT NULL,
  `fkContractor` int(11) NOT NULL,
  PRIMARY KEY (`idHistory`),
  KEY `FK__history__personal_idx` (`fkContractor`),
  KEY `FK__history__project_idx` (`fkProject`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;
CREATE TABLE IF NOT EXISTS `note` (
  `idNote` int(11) NOT NULL AUTO_INCREMENT,
  `Text` varchar(200) NOT NULL,
  `fkContractor` int(11) NOT NULL,
  `fkUser` int(11) NOT NULL,
  PRIMARY KEY (`idNote`),
  KEY `FK__notes__personal_idx` (`fkContractor`),
  KEY `FK__notes__user_idx` (`fkUser`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `passport`
--

DROP TABLE IF EXISTS `passport`;
CREATE TABLE IF NOT EXISTS `passport` (
  `idPassport` int(11) NOT NULL AUTO_INCREMENT,
  `Number` varchar(45) NOT NULL,
  `IssueDate` datetime NOT NULL,
  `ExpiryDate` datetime NOT NULL,
  `Nationality` varchar(45) NOT NULL,
  `ImageUrl` varchar(45) NOT NULL,
  `fkContractor` int(11) NOT NULL,
  PRIMARY KEY (`idPassport`),
  KEY `fkPersonal_idx` (`fkContractor`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
CREATE TABLE IF NOT EXISTS `project` (
  `idProject` int(11) NOT NULL AUTO_INCREMENT,
  `Location` varchar(45) NOT NULL,
  `Description` varchar(45) NOT NULL,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`idProject`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `idUser` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  `Login` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  PRIMARY KEY (`idUser`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `emergency_contact`
--
ALTER TABLE `emergency_contact`
  ADD CONSTRAINT `FK__emergency_contact__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `FK__history__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__history__project` FOREIGN KEY (`fkProject`) REFERENCES `project` (`idProject`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `FK__notes__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__notes__user` FOREIGN KEY (`fkUser`) REFERENCES `user` (`idUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `passport`
--
ALTER TABLE `passport`
  ADD CONSTRAINT `fk__passport__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;
