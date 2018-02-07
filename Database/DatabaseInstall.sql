-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 07, 2018 at 12:55 AM
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

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `create_contractor_history`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_contractor_history` (IN `idProject` INT(11), IN `idContractor` INT(11))  BEGIN
	INSERT INTO `history`
	(
		`fkProject`,
		`fkContractor`
	)
	VALUES
	(
		idProject,
		idContractor
	);

END$$

DROP PROCEDURE IF EXISTS `create_contractor_note`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_contractor_note` (IN `text` VARCHAR(200), IN `idContractor` INT(11), IN `idUser` INT(11))  BEGIN
	INSERT INTO `note`
	(
		`Text`,
		`fkContractor`,
		`fkUser`
	)
	VALUES
	(
		text,
		idContractor,
		idUser
	);
END$$

DROP PROCEDURE IF EXISTS `create_contractor_record`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_contractor_record` (IN `title` VARCHAR(45), IN `givenNames` VARCHAR(45), IN `surname` VARCHAR(45), IN `phoneNumber` VARCHAR(45), IN `gender` VARCHAR(45), IN `dateOfBirth` DATETIME, IN `issueDate` DATETIME, IN `expiryDate` DATETIME, IN `nationality` VARCHAR(45), IN `imageUrl` VARCHAR(45), IN `name` VARCHAR(45), IN `relationship` VARCHAR(45), IN `contactNumber` VARCHAR(45))  BEGIN
	DECLARE idContractor INT(11);
	DECLARE msg TEXT;
    DECLARE code CHAR(5) DEFAULT '00000';
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		ROLLBACK;
	END;
	
    START TRANSACTION;
    
    INSERT INTO contractor
    (
		`Title`,
		`GivenNames`,
		`Surname`,
		`PhoneNumber`,
		`Gender`,
		`DateOfBirth`
	)
	VALUES
	(
		title,
		givenNames,
		surname,
		phoneNumber,
		gender,
		dateOfBirth
	);


	SET idContractor = (SELECT LAST_INSERT_ID());
    
	INSERT INTO `passport`
	(
		`Number`,
		`IssueDate`,
		`ExpiryDate`,
		`Nationality`,
		`ImageUrl`,
		`fkContractor`
	)
	VALUES
	(
		number,
		issueDate,
		expiryDate,
		nationality,
		imageUrl,
		idContractor
	);

	INSERT INTO `emergency_contact`
	(
		`Name`,
		`Relationship`,
		`PhoneNumber`,
		`fkContractor`
	)
	VALUES
	(
		name,
		relationship,
		contactNumber,
		idContractor
	);

	COMMIT;
    SELECT idContractor;
END$$

DROP PROCEDURE IF EXISTS `read_contractor_history`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_contractor_history` (IN `idContractor` INT)  BEGIN
	select project.idProject, project.Location, project.Description, project.Date
    from project
    inner join history on project.idProject = history.fkProject
    where history.fkContractor = idContractor;
END$$

DROP PROCEDURE IF EXISTS `read_contractor_notes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_contractor_notes` (IN `idContractor` INT)  BEGIN
	select idNote, Text, fkUser from note
    where fkContractor = idContractor;
END$$

DROP PROCEDURE IF EXISTS `read_contractor_record`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_contractor_record` (IN `idContractor` INT)  BEGIN
	select contractor.*, passport.*, emergency_contact.*
    from contractor
    join passport on contractor.idContractor = passport.fkContractor
    join emergency_contact on contractor.idContractor = emergency_contact.fkContractor
    where contractor.idContractor = idContractor;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `contractor`
--

DROP TABLE IF EXISTS `contractor`;
CREATE TABLE `contractor` (
  `idContractor` int(11) NOT NULL,
  `Title` varchar(45) NOT NULL,
  `GivenNames` varchar(45) NOT NULL,
  `Surname` varchar(45) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `Gender` varchar(45) NOT NULL,
  `DateOfBirth` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `emergency_contact`
--

DROP TABLE IF EXISTS `emergency_contact`;
CREATE TABLE `emergency_contact` (
  `idEmergencyContact` int(11) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Relationship` varchar(45) NOT NULL,
  `PhoneNumber` varchar(45) NOT NULL,
  `fkContractor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `idHistory` int(11) NOT NULL,
  `fkProject` int(11) NOT NULL,
  `fkContractor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;
CREATE TABLE `note` (
  `idNote` int(11) NOT NULL,
  `Text` varchar(200) NOT NULL,
  `fkContractor` int(11) NOT NULL,
  `fkUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `passport`
--

DROP TABLE IF EXISTS `passport`;
CREATE TABLE `passport` (
  `idPassport` int(11) NOT NULL,
  `Number` varchar(45) NOT NULL,
  `IssueDate` datetime NOT NULL,
  `ExpiryDate` datetime NOT NULL,
  `Nationality` varchar(45) NOT NULL,
  `ImageUrl` varchar(45) NOT NULL,
  `fkContractor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `idProject` int(11) NOT NULL,
  `Location` varchar(45) NOT NULL,
  `Description` varchar(45) NOT NULL,
  `Date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `idUser` int(11) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Login` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Enabled` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contractor`
--
ALTER TABLE `contractor`
  ADD PRIMARY KEY (`idContractor`);

--
-- Indexes for table `emergency_contact`
--
ALTER TABLE `emergency_contact`
  ADD PRIMARY KEY (`idEmergencyContact`),
  ADD KEY `fkPersonal_idx` (`fkContractor`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`idHistory`),
  ADD KEY `FK__history__personal_idx` (`fkContractor`),
  ADD KEY `FK__history__project_idx` (`fkProject`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`idNote`),
  ADD KEY `FK__notes__personal_idx` (`fkContractor`),
  ADD KEY `FK__notes__user_idx` (`fkUser`);

--
-- Indexes for table `passport`
--
ALTER TABLE `passport`
  ADD PRIMARY KEY (`idPassport`),
  ADD KEY `fkPersonal_idx` (`fkContractor`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`idProject`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `Login` (`Login`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contractor`
--
ALTER TABLE `contractor`
  MODIFY `idContractor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `emergency_contact`
--
ALTER TABLE `emergency_contact`
  MODIFY `idEmergencyContact` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `idHistory` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `note`
--
ALTER TABLE `note`
  MODIFY `idNote` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `passport`
--
ALTER TABLE `passport`
  MODIFY `idPassport` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `idProject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `FK__history__project` FOREIGN KEY (`fkProject`) REFERENCES `project` (`idProject`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `FK__notes__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK__notes__user` FOREIGN KEY (`fkUser`) REFERENCES `user` (`idUser`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `passport`
--
ALTER TABLE `passport`
  ADD CONSTRAINT `fk__passport__contractor` FOREIGN KEY (`fkContractor`) REFERENCES `contractor` (`idContractor`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;
