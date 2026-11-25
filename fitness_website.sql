-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 25, 2026 at 01:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fitness_website`
--

-- --------------------------------------------------------

--
-- Table structure for table `exercises`
--

CREATE TABLE `exercises` (
  `exercise_id` int(10) UNSIGNED NOT NULL,
  `exercise_name` varchar(100) NOT NULL,
  `muscle_group` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `exercises`
--

INSERT INTO `exercises` (`exercise_id`, `exercise_name`, `muscle_group`, `description`) VALUES
(1, 'Bench Press', 'Chest', NULL),
(2, 'Lat Pulldown', 'Back', NULL),
(3, 'Squat', 'Legs', NULL),
(4, 'Bicep Curl', 'Arms', NULL),
(5, 'Shoulder Press', 'Shoulders', NULL),
(6, 'Cable Row', 'Back', NULL),
(7, 'Leg Curl', 'Legs', NULL),
(8, 'Tricep Pushdown', 'Arms', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `fitness_goals`
--

CREATE TABLE `fitness_goals` (
  `goal_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `goal_type` enum('weight_loss','weight_gain','maintenance','strength','consistency','other') NOT NULL,
  `description` varchar(255) NOT NULL,
  `target_weight_kg` decimal(6,2) DEFAULT NULL CHECK (`target_weight_kg` > 0),
  `start_date` date NOT NULL,
  `target_date` date DEFAULT NULL,
  `status` enum('active','completed','cancelled') NOT NULL DEFAULT 'active'
) ;

-- --------------------------------------------------------

--
-- Table structure for table `progress_logs`
--

CREATE TABLE `progress_logs` (
  `progress_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `log_date` date NOT NULL,
  `weight_kg` decimal(6,2) NOT NULL CHECK (`weight_kg` > 0),
  `height_cm` decimal(5,2) NOT NULL CHECK (`height_cm` > 0),
  `bmi` decimal(8,2) GENERATED ALWAYS AS (round(`weight_kg` / pow(nullif(`height_cm`,0) / 100,2),2)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `routine_exercises`
--

CREATE TABLE `routine_exercises` (
  `routine_id` int(10) UNSIGNED NOT NULL,
  `exercise_id` int(10) UNSIGNED NOT NULL,
  `target_sets` smallint(5) UNSIGNED NOT NULL CHECK (`target_sets` > 0),
  `target_reps` smallint(5) UNSIGNED NOT NULL CHECK (`target_reps` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `height_cm` decimal(5,2) NOT NULL CHECK (`height_cm` > 0),
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_latest_progress`
-- (See below for the actual view)
--
CREATE TABLE `v_latest_progress` (
`progress_id` int(10) unsigned
,`user_id` int(10) unsigned
,`log_date` date
,`weight_kg` decimal(6,2)
,`height_cm` decimal(5,2)
,`bmi` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_dashboard`
-- (See below for the actual view)
--
CREATE TABLE `v_user_dashboard` (
`user_id` int(10) unsigned
,`full_name` varchar(100)
,`weight_kg` decimal(6,2)
,`bmi` decimal(8,2)
,`latest_progress_date` date
,`total_workouts` bigint(21)
,`active_goals` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_workout_summary`
-- (See below for the actual view)
--
CREATE TABLE `v_workout_summary` (
`workout_id` int(10) unsigned
,`user_id` int(10) unsigned
,`workout_date` datetime
,`workout_name` varchar(100)
,`duration_minutes` smallint(5) unsigned
,`total_sets` bigint(21)
,`total_reps` decimal(27,0)
,`volume_kg` decimal(34,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `workouts`
--

CREATE TABLE `workouts` (
  `workout_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `workout_date` datetime NOT NULL DEFAULT current_timestamp(),
  `workout_name` varchar(100) NOT NULL,
  `duration_minutes` smallint(5) UNSIGNED DEFAULT NULL CHECK (`duration_minutes` > 0),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `workout_routines`
--

CREATE TABLE `workout_routines` (
  `routine_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `routine_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `workout_sets`
--

CREATE TABLE `workout_sets` (
  `set_id` int(10) UNSIGNED NOT NULL,
  `workout_id` int(10) UNSIGNED NOT NULL,
  `exercise_id` int(10) UNSIGNED NOT NULL,
  `set_number` smallint(5) UNSIGNED NOT NULL CHECK (`set_number` > 0),
  `reps` smallint(5) UNSIGNED NOT NULL CHECK (`reps` > 0),
  `weight_kg` decimal(7,2) NOT NULL DEFAULT 0.00 CHECK (`weight_kg` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure for view `v_latest_progress`
--
DROP TABLE IF EXISTS `v_latest_progress`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_latest_progress`  AS SELECT `ranked`.`progress_id` AS `progress_id`, `ranked`.`user_id` AS `user_id`, `ranked`.`log_date` AS `log_date`, `ranked`.`weight_kg` AS `weight_kg`, `ranked`.`height_cm` AS `height_cm`, `ranked`.`bmi` AS `bmi` FROM (select `p`.`progress_id` AS `progress_id`,`p`.`user_id` AS `user_id`,`p`.`log_date` AS `log_date`,`p`.`weight_kg` AS `weight_kg`,`p`.`height_cm` AS `height_cm`,`p`.`bmi` AS `bmi`,row_number() over ( partition by `p`.`user_id` order by `p`.`log_date` desc,`p`.`progress_id` desc) AS `rn` from `progress_logs` `p`) AS `ranked` WHERE `ranked`.`rn` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_dashboard`
--
DROP TABLE IF EXISTS `v_user_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_dashboard`  AS SELECT `u`.`user_id` AS `user_id`, `u`.`full_name` AS `full_name`, `p`.`weight_kg` AS `weight_kg`, `p`.`bmi` AS `bmi`, `p`.`log_date` AS `latest_progress_date`, (select count(0) from `workouts` `w` where `w`.`user_id` = `u`.`user_id`) AS `total_workouts`, (select count(0) from `fitness_goals` `g` where `g`.`user_id` = `u`.`user_id` and `g`.`status` = 'active') AS `active_goals` FROM (`users` `u` left join `v_latest_progress` `p` on(`u`.`user_id` = `p`.`user_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_workout_summary`
--
DROP TABLE IF EXISTS `v_workout_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_workout_summary`  AS SELECT `w`.`workout_id` AS `workout_id`, `w`.`user_id` AS `user_id`, `w`.`workout_date` AS `workout_date`, `w`.`workout_name` AS `workout_name`, `w`.`duration_minutes` AS `duration_minutes`, count(`s`.`set_id`) AS `total_sets`, coalesce(sum(`s`.`reps`),0) AS `total_reps`, coalesce(sum(`s`.`reps` * `s`.`weight_kg`),0) AS `volume_kg` FROM (`workouts` `w` left join `workout_sets` `s` on(`w`.`workout_id` = `s`.`workout_id`)) GROUP BY `w`.`workout_id`, `w`.`user_id`, `w`.`workout_date`, `w`.`workout_name`, `w`.`duration_minutes` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `exercises`
--
ALTER TABLE `exercises`
  ADD PRIMARY KEY (`exercise_id`),
  ADD UNIQUE KEY `exercise_name` (`exercise_name`);

--
-- Indexes for table `fitness_goals`
--
ALTER TABLE `fitness_goals`
  ADD PRIMARY KEY (`goal_id`),
  ADD KEY `user_id` (`user_id`,`status`);

--
-- Indexes for table `progress_logs`
--
ALTER TABLE `progress_logs`
  ADD PRIMARY KEY (`progress_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`log_date`);

--
-- Indexes for table `routine_exercises`
--
ALTER TABLE `routine_exercises`
  ADD PRIMARY KEY (`routine_id`,`exercise_id`),
  ADD KEY `exercise_id` (`exercise_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `workouts`
--
ALTER TABLE `workouts`
  ADD PRIMARY KEY (`workout_id`),
  ADD KEY `user_id` (`user_id`,`workout_date`);

--
-- Indexes for table `workout_routines`
--
ALTER TABLE `workout_routines`
  ADD PRIMARY KEY (`routine_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`routine_id`);

--
-- Indexes for table `workout_sets`
--
ALTER TABLE `workout_sets`
  ADD PRIMARY KEY (`set_id`),
  ADD UNIQUE KEY `workout_id` (`workout_id`,`exercise_id`,`set_number`),
  ADD KEY `exercise_id` (`exercise_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `exercises`
--
ALTER TABLE `exercises`
  MODIFY `exercise_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `fitness_goals`
--
ALTER TABLE `fitness_goals`
  MODIFY `goal_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `progress_logs`
--
ALTER TABLE `progress_logs`
  MODIFY `progress_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `workouts`
--
ALTER TABLE `workouts`
  MODIFY `workout_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `workout_routines`
--
ALTER TABLE `workout_routines`
  MODIFY `routine_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `workout_sets`
--
ALTER TABLE `workout_sets`
  MODIFY `set_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fitness_goals`
--
ALTER TABLE `fitness_goals`
  ADD CONSTRAINT `fitness_goals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `progress_logs`
--
ALTER TABLE `progress_logs`
  ADD CONSTRAINT `progress_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `routine_exercises`
--
ALTER TABLE `routine_exercises`
  ADD CONSTRAINT `routine_exercises_ibfk_1` FOREIGN KEY (`routine_id`) REFERENCES `workout_routines` (`routine_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `routine_exercises_ibfk_2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`);

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `workouts`
--
ALTER TABLE `workouts`
  ADD CONSTRAINT `workouts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `workout_routines`
--
ALTER TABLE `workout_routines`
  ADD CONSTRAINT `workout_routines_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `workout_sets`
--
ALTER TABLE `workout_sets`
  ADD CONSTRAINT `workout_sets_ibfk_1` FOREIGN KEY (`workout_id`) REFERENCES `workouts` (`workout_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `workout_sets_ibfk_2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
