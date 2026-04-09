SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `nyc_taxi` DEFAULT CHARACTER SET utf8mb4;
USE `nyc_taxi`;

CREATE TABLE IF NOT EXISTS `Dim_Vendor` (
  `vendor_id`   TINYINT(4)   NOT NULL,
  `vendor_name` VARCHAR(50)  NOT NULL,
  PRIMARY KEY (`vendor_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Dim_RateCode` (
  `rate_code_id`   TINYINT(4)  NOT NULL,
  `rate_code_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`rate_code_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Dim_PaymentType` (
  `payment_type_id`   TINYINT(4)  NOT NULL,
  `payment_type_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`payment_type_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Dim_TaxiZone` (
  `location_id`  SMALLINT(6) NOT NULL,
  `borough`      VARCHAR(50) NOT NULL,
  `zone_name`    VARCHAR(50) NOT NULL,
  `service_zone` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Dim_DateTime` (
  `datetime_id`      INT          NOT NULL,
  `pickup_datetime`  DATETIME     NOT NULL,
  `year`             SMALLINT(6)  NOT NULL,
  `month`            TINYINT(4)   NOT NULL,
  `day`              TINYINT(4)   NOT NULL,
  `hour`             TINYINT(4)   NOT NULL,
  `weekday_num`      TINYINT(4)   NOT NULL,
  `weekday_name`     VARCHAR(50)  NOT NULL,
  `is_weekend`       TINYINT(4)   NOT NULL,
  `month_name`       VARCHAR(50)  NOT NULL,
  PRIMARY KEY (`datetime_id`),
  CONSTRAINT chk_month    CHECK (`month`       BETWEEN 1 AND 12),
  CONSTRAINT chk_day      CHECK (`day`         BETWEEN 1 AND 31),
  CONSTRAINT chk_hour     CHECK (`hour`        BETWEEN 0 AND 23),
  CONSTRAINT chk_weekday  CHECK (`weekday_num` BETWEEN 1 AND 7),
  CONSTRAINT chk_weekend  CHECK (`is_weekend`  IN (0, 1))
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Fact_Trips` (
  `trip_id`               INT           NOT NULL AUTO_INCREMENT,
  `taxi_type`             VARCHAR(10)   NOT NULL,
  `datetime_id`           INT           NOT NULL,
  `vendor_id`             TINYINT(4)    NOT NULL,
  `pickup_location_id`    SMALLINT(6)   NOT NULL,
  `dropoff_location_id`   SMALLINT(6)   NOT NULL,
  `rate_code_id`          TINYINT(4)    NOT NULL,
  `payment_type_id`       TINYINT(4)    NOT NULL,
  `passenger_count`       TINYINT(4)    NULL,
  `trip_distance`         DECIMAL(8,2)  NOT NULL,
  `trip_duration_min`     DECIMAL(6,2)  NOT NULL,
  `fare_amount`           DECIMAL(8,2)  NOT NULL,
  `extra`                 DECIMAL(8,2)  NOT NULL,
  `mta_tax`               DECIMAL(8,2)  NOT NULL,
  `tip_amount`            DECIMAL(8,2)  NOT NULL,
  `tolls_amount`          DECIMAL(8,2)  NOT NULL,
  `improvement_surcharge` DECIMAL(8,2)  NOT NULL,
  `congestion_surcharge`  DECIMAL(8,2)  NOT NULL,
  `airport_fee`           DECIMAL(8,2)  NOT NULL,
  `cbd_congestion_fee`    DECIMAL(8,2)  NOT NULL,
  `total_amount`          DECIMAL(8,2)  NOT NULL,
  `trip_type`             TINYINT(4)    NULL,
  `store_and_fwd_flag`    CHAR(1)       NULL,
  PRIMARY KEY (`trip_id`),
  CONSTRAINT chk_taxi_type CHECK (`taxi_type`         IN ('yellow', 'green')),
  CONSTRAINT chk_distance  CHECK (`trip_distance`     >= 0),
  CONSTRAINT chk_duration  CHECK (`trip_duration_min` >= 0),
  CONSTRAINT chk_fare      CHECK (`fare_amount`       >= 0),
  CONSTRAINT chk_total     CHECK (`total_amount`      >= 0),
  CONSTRAINT chk_trip_type CHECK (`trip_type` IN (1, 2) OR `trip_type` IS NULL),
  CONSTRAINT chk_fwd_flag  CHECK (`store_and_fwd_flag` IN ('Y', 'N') OR `store_and_fwd_flag` IS NULL),
  INDEX `idx_datetime_id`         (`datetime_id`         ASC),
  INDEX `idx_vendor_id`           (`vendor_id`           ASC),
  INDEX `idx_pickup_location_id`  (`pickup_location_id`  ASC),
  INDEX `idx_dropoff_location_id` (`dropoff_location_id` ASC),
  INDEX `idx_rate_code_id`        (`rate_code_id`        ASC),
  INDEX `idx_payment_type_id`     (`payment_type_id`     ASC),
  CONSTRAINT `fk_datetime`
    FOREIGN KEY (`datetime_id`)
    REFERENCES `Dim_DateTime` (`datetime_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendor`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `Dim_Vendor` (`vendor_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pickup_zone`
    FOREIGN KEY (`pickup_location_id`)
    REFERENCES `Dim_TaxiZone` (`location_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dropoff_zone`
    FOREIGN KEY (`dropoff_location_id`)
    REFERENCES `Dim_TaxiZone` (`location_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_rate_code`
    FOREIGN KEY (`rate_code_id`)
    REFERENCES `Dim_RateCode` (`rate_code_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_type`
    FOREIGN KEY (`payment_type_id`)
    REFERENCES `Dim_PaymentType` (`payment_type_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;