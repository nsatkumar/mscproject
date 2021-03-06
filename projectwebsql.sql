-- MySQL Script generated by MySQL Workbench
-- Fri Jun  3 21:26:22 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema projecttracker
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `projecttracker` ;

-- -----------------------------------------------------
-- Schema projecttracker
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `projecttracker` DEFAULT CHARACTER SET utf8 ;
USE `projecttracker` ;

-- -----------------------------------------------------
-- Table `projecttracker`.`roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`roles` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`roles` (
  `role_id` INT NOT NULL,
  `role_desc` VARCHAR(60) NULL,
  PRIMARY KEY (`role_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`users` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`users` (
  `user_id` VARCHAR(250) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `role_id` INT NOT NULL,
  `user_name` VARCHAR(250) NOT NULL,
  `id` INT NOT NULL AUTO_INCREMENT,
  INDEX `users.role_id_idx` (`role_id` ASC),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `users.role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `projecttracker`.`roles` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table `projecttracker`.`tasks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`tasks` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`tasks` (
  `task_id` INT NOT NULL,
  `task_name` VARCHAR(45) NULL,
  PRIMARY KEY (`task_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`phases`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`phases` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`phases` (
  `phase_id` INT NOT NULL AUTO_INCREMENT,
  `phase_name` VARCHAR(200) NULL,
  PRIMARY KEY (`phase_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table `projecttracker`.`activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`activity` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`activity` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `activity_name` VARCHAR(250) NULL,
  `parent_id` INT NOT NULL,
  PRIMARY KEY (`activity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`sub_phases`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`sub_phases` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`sub_phases` (
  `sub_phase_id` INT NOT NULL AUTO_INCREMENT,
  `sub_phase_name` VARCHAR(200) NULL,
  PRIMARY KEY (`sub_phase_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`phase_sub_phase_mapper`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`phase_sub_phase_mapper` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`phase_sub_phase_mapper` (
  `phase_id` INT NOT NULL,
  `sub_phase_id` INT NOT NULL,
  PRIMARY KEY (`phase_id`, `sub_phase_id`),
  INDEX `phase_sub_phase_mapper.sub_phase_id_idx` (`sub_phase_id` ASC),
  CONSTRAINT `phase_sub_phase_mapper.phase_id`
    FOREIGN KEY (`phase_id`)
    REFERENCES `projecttracker`.`phases` (`phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `phase_sub_phase_mapper.sub_phase_id`
    FOREIGN KEY (`sub_phase_id`)
    REFERENCES `projecttracker`.`sub_phases` (`sub_phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`task_activity_mapper`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`task_activity_mapper` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`task_activity_mapper` (
  `task_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  `estimate` DECIMAL(2) NULL,
  `phase_id` INT NOT NULL,
  `sub_phase_id` INT NOT NULL,
  `planned_start_date` VARCHAR(45) NULL,
  `id` INT NOT NULL,
  PRIMARY KEY (`task_id`, `activity_id`, `phase_id`, `sub_phase_id`),
  INDEX `task_activity_mapper.activity_id_idx` (`activity_id` ASC),
  INDEX `task_activity_mapper.id_idx` (`id` ASC),
  INDEX `task_activity_mapper.sub_phase_id_idx` (`sub_phase_id` ASC, `task_id` ASC),
  INDEX `task_activity_mapper.phase_id_idx` (`phase_id` ASC),
  CONSTRAINT `task_activity_mapper.task_id`
    FOREIGN KEY (`task_id`)
    REFERENCES `projecttracker`.`tasks` (`task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_mapper.activity_id`
    FOREIGN KEY (`activity_id`)
    REFERENCES `projecttracker`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_mapper.phase_id`
    FOREIGN KEY (`phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_mapper.sub_phase_id`
    FOREIGN KEY (`sub_phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`sub_phase_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_mapper.id`
    FOREIGN KEY (`id`)
    REFERENCES `projecttracker`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`task_activity_schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`task_activity_schedule` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`task_activity_schedule` (
  `task_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  `phase_id` INT NOT NULL,
  `sub_phase_id` INT NOT NULL,
  `sequence` INT NOT NULL,
  `planned_start_date` DATETIME NOT NULL,
  `planned_end_date` DATETIME NOT NULL,
  `actual_start_date` DATETIME NOT NULL,
  `actual_end_date` DATETIME NOT NULL,
  `task_activity_status` VARCHAR(1) NOT NULL,
  `poc` INT NULL,
  PRIMARY KEY (`task_id`, `activity_id`, `phase_id`, `sub_phase_id`),
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC),
  INDEX `task_activity_schedule.activity_id_idx` (`activity_id` ASC),
  INDEX `task_activity_schedule.phase_id_idx` (`phase_id` ASC),
  INDEX `task_activity_schedule.sub_phase_id_idx` (`sub_phase_id` ASC),
  CONSTRAINT `task_activity_schedule.task_id`
    FOREIGN KEY (`task_id`)
    REFERENCES `projecttracker`.`tasks` (`task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_schedule.activity_id`
    FOREIGN KEY (`activity_id`)
    REFERENCES `projecttracker`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_schedule.phase_id`
    FOREIGN KEY (`phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `task_activity_schedule.sub_phase_id`
    FOREIGN KEY (`sub_phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`sub_phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`time_tracker`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`time_tracker` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`time_tracker` (
  `timesheet_id` INT NOT NULL AUTO_INCREMENT,
  `time_date` DATETIME NOT NULL,
  `task_id` INT NOT NULL,
  `activity_id` INT NOT NULL,
  `phase_id` INT NOT NULL,
  `sub_phase_id` INT NOT NULL,
  `hours_spent` DECIMAL(2) NOT NULL,
  `id` INT NOT NULL,
  `comments` VARCHAR(1000) NULL,
  PRIMARY KEY (`timesheet_id`),
  INDEX `time_tracker.id_idx` (`id` ASC),
  INDEX `time_tracker.activity_id_idx` (`activity_id` ASC),
  INDEX `time_tracker.phase_id_idx` (`phase_id` ASC),
  INDEX `time_tracker.sub_phase_id_idx` (`sub_phase_id` ASC),
  CONSTRAINT `time_tracker.task_id`
    FOREIGN KEY (`task_id`)
    REFERENCES `projecttracker`.`tasks` (`task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `time_tracker.activity_id`
    FOREIGN KEY (`activity_id`)
    REFERENCES `projecttracker`.`activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `time_tracker.phase_id`
    FOREIGN KEY (`phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `time_tracker.sub_phase_id`
    FOREIGN KEY (`sub_phase_id`)
    REFERENCES `projecttracker`.`phase_sub_phase_mapper` (`sub_phase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `time_tracker.id`
    FOREIGN KEY (`id`)
    REFERENCES `projecttracker`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`project` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`project` (
  `project_id` INT NOT NULL AUTO_INCREMENT,
  `project_name` VARCHAR(250) NOT NULL,
  `project_desc` VARCHAR(1000) NULL,
  PRIMARY KEY (`project_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projecttracker`.`project_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `projecttracker`.`project_users` ;

CREATE TABLE IF NOT EXISTS `projecttracker`.`project_users` (
  `project_id` INT NOT NULL,
  `id` INT NOT NULL,
  PRIMARY KEY (`project_id`, `id`),
  CONSTRAINT `project_users.project_id`
    FOREIGN KEY (`project_id`)
    REFERENCES `projecttracker`.`project` (`project_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `project_users.id`
    FOREIGN KEY (`id`)
    REFERENCES `projecttracker`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
