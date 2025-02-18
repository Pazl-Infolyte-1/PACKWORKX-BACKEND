-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 34.192.188.118
-- Generation Time: Feb 16, 2025 at 05:41 PM
-- Server version: 8.0.41-0ubuntu0.22.04.1
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `packworks`
--

-- --------------------------------------------------------

--
-- Table structure for table `api_logs`
--

CREATE TABLE `api_logs` (
  `id` int NOT NULL COMMENT 'Primary key of the table',
  `userId` int DEFAULT NULL COMMENT 'Foreign key referencing the users table',
  `method` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'HTTP method of the API request',
  `url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'URL of the API request',
  `statusCode` int NOT NULL COMMENT 'HTTP status code of the API response',
  `requestBody` text COLLATE utf8mb4_general_ci COMMENT 'Request body of the API request',
  `requestHeaders` text COLLATE utf8mb4_general_ci COMMENT 'Header of the API request',
  `responseBody` text COLLATE utf8mb4_general_ci COMMENT 'Response body of the API response',
  `errorMessage` text COLLATE utf8mb4_general_ci COMMENT 'Error message if the API request failed',
  `stackTrace` text COLLATE utf8mb4_general_ci COMMENT 'Stack trace if the API request failed',
  `duration` int DEFAULT NULL COMMENT 'Duration of the API request in milliseconds',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the record was created',
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp when the record was last updated'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Table containing logs of API requests and responses';

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int NOT NULL COMMENT 'Primary Key',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Company name',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Company email',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Company phone number',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Company website',
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Company address',
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'City',
  `state` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'State',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Country',
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ZIP code',
  `countryCode` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Country code',
  `logo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Company logo URL',
  `timezone` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Timezone',
  `date_format` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Date format',
  `time_format` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Time format',
  `latitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Latitude',
  `longitude` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Longitude',
  `ticket_count` int DEFAULT NULL COMMENT 'Number of tickets',
  `user_count` int DEFAULT NULL COMMENT 'Number of users',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT 'Company status',
  `valid_from` timestamp NULL DEFAULT NULL COMMENT 'Validity start date',
  `valid_till` timestamp NULL DEFAULT NULL COMMENT 'Validity end date',
  `login` enum('enable','disable') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enable' COMMENT 'Login status',
  `email_notifications` enum('enable','disable') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'enable' COMMENT 'Email notifications status',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation date',
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `email`, `phone`, `website`, `address`, `city`, `state`, `country`, `zip`, `countryCode`, `logo`, `timezone`, `date_format`, `time_format`, `latitude`, `longitude`, `ticket_count`, `user_count`, `status`, `valid_from`, `valid_till`, `login`, `email_notifications`, `createdAt`, `updatedAt`) VALUES
(1, 'Pacx work', 'pacx@pazl.info', NULL, NULL, '123 Main St, New York', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'active', NULL, NULL, 'enable', 'enable', '2025-02-03 16:31:34', '2025-02-03 16:48:32');

-- --------------------------------------------------------

--
-- Table structure for table `forms`
--

CREATE TABLE `forms` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `module_id` int UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_fields`
--

CREATE TABLE `form_fields` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `form_id` int UNSIGNED NOT NULL,
  `module_id` int UNSIGNED NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `input_type_id` int UNSIGNED NOT NULL,
  `options` text COLLATE utf8mb4_unicode_ci,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `key_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `export` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `view` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_submissions`
--

CREATE TABLE `form_submissions` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `form_id` int UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_submission_values`
--

CREATE TABLE `form_submission_values` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `submission_id` int UNSIGNED NOT NULL,
  `field_id` int UNSIGNED NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `input_types`
--

CREATE TABLE `input_types` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `input_types`
--

INSERT INTO `input_types` (`id`, `company_id`, `type`, `status`, `created_at`) VALUES
(1, 1, 'text', 'active', '2025-02-13 05:17:44'),
(2, 1, 'password', 'active', '2025-02-13 05:17:44'),
(3, 1, 'email', 'active', '2025-02-13 05:17:44'),
(4, 1, 'number', 'active', '2025-02-13 05:17:44'),
(5, 1, 'tel', 'active', '2025-02-13 05:17:44'),
(6, 1, 'url', 'active', '2025-02-13 05:17:44'),
(7, 1, 'search', 'active', '2025-02-13 05:17:44'),
(8, 1, 'date', 'active', '2025-02-13 05:17:44'),
(9, 1, 'time', 'active', '2025-02-13 05:17:44'),
(10, 1, 'datetime-local', 'active', '2025-02-13 05:17:44'),
(11, 1, 'month', 'active', '2025-02-13 05:17:44'),
(12, 1, 'week', 'active', '2025-02-13 05:17:44'),
(13, 1, 'checkbox', 'active', '2025-02-13 05:17:44'),
(14, 1, 'radio', 'active', '2025-02-13 05:17:44'),
(15, 1, 'select', 'active', '2025-02-13 05:17:44'),
(16, 1, 'file', 'active', '2025-02-13 05:17:44'),
(17, 1, 'color', 'active', '2025-02-13 05:17:44'),
(18, 1, 'range', 'active', '2025-02-13 05:17:44'),
(19, 1, 'hidden', 'active', '2025-02-13 05:17:44'),
(20, 1, 'button', 'active', '2025-02-13 05:17:44'),
(21, 1, 'submit', 'active', '2025-02-13 05:17:44'),
(22, 1, 'reset', 'active', '2025-02-13 05:17:44');

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` int UNSIGNED NOT NULL,
  `module_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_group_id` int DEFAULT NULL,
  `module_icon_id` int DEFAULT NULL,
  `key` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `company_id` int DEFAULT NULL,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `module_name`, `description`, `module_group_id`, `module_icon_id`, `key`, `company_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Employee', NULL, 1, 1, 'view_employee', 1, 'active', '2025-02-13 23:47:00', NULL),
(2, 'Attendance', NULL, 1, 2, 'view_attendance', 1, 'active', '2025-02-13 23:47:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `module_groups`
--

CREATE TABLE `module_groups` (
  `id` int NOT NULL,
  `group_name` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `module_groups`
--

INSERT INTO `module_groups` (`id`, `group_name`, `status`, `created_at`, `updated_at`, `company_id`) VALUES
(1, 'HRMS', 'active', '2025-02-13 18:00:37', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `module_icons`
--

CREATE TABLE `module_icons` (
  `id` int NOT NULL,
  `icon_name` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `module_icons`
--

INSERT INTO `module_icons` (`id`, `icon_name`, `status`) VALUES
(1, 'cilHome', 'active'),
(2, 'cilUser', 'active'),
(3, 'cilSettings', 'active'),
(4, 'cilBell', 'active'),
(5, 'cilEnvelope', 'active'),
(6, 'cilCalculator', 'active'),
(7, 'cilArrowLeft', 'active'),
(8, 'cilArrowRight', 'active'),
(9, 'cilChevronCircleDown', 'inactive'),
(10, 'cilPlus', 'active'),
(11, 'cilMinus', 'active'),
(12, 'cilTrash', 'inactive'),
(13, 'cilSave', 'active'),
(14, 'cilCheckCircle', 'active'),
(15, 'cilVideo', 'active'),
(16, 'cilMusicNote', 'active'),
(17, 'cilFolderOpen', 'inactive'),
(18, 'cilCloudDownload', 'active'),
(19, 'cilFile', 'active'),
(20, 'cilCart', 'active'),
(21, 'cilCreditCard', 'inactive'),
(22, 'cilDollar', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_id` int UNSIGNED NOT NULL,
  `is_custom` tinyint(1) NOT NULL DEFAULT '0',
  `company_id` int NOT NULL,
  `allowed_permissions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

CREATE TABLE `permission_role` (
  `id` int NOT NULL,
  `sub_module_id` int NOT NULL,
  `role_id` int UNSIGNED NOT NULL,
  `permission_type_id` bigint UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `permission_role`
--

INSERT INTO `permission_role` (`id`, `sub_module_id`, `role_id`, `permission_type_id`, `company_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 4, 1, '2025-02-14 05:58:47', NULL),
(2, 2, 1, 4, 1, '2025-02-14 05:59:05', NULL),
(3, 3, 1, 4, 1, '2025-02-14 05:59:19', NULL),
(4, 4, 1, 4, 1, '2025-02-14 05:59:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `permission_types`
--

CREATE TABLE `permission_types` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_types`
--

INSERT INTO `permission_types` (`id`, `name`, `company_id`, `created_at`, `updated_at`) VALUES
(1, 'added', 1, NULL, NULL),
(2, 'owned', 1, NULL, NULL),
(3, 'both', 1, NULL, NULL),
(4, 'all', 1, NULL, NULL),
(5, 'none', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int UNSIGNED NOT NULL,
  `company_id` int DEFAULT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `company_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin', 'App Administrator', 'Admin is allowed to manage everything of the app.', '2025-02-14 02:21:09', NULL),
(2, 1, 'employee', 'Employee', 'Employee can see tasks and projects assigned to him', '2025-02-14 02:21:40', NULL),
(3, 1, 'client', 'Client', 'Client can see own tasks and projects.', '2025-02-14 02:22:05', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `id` int NOT NULL,
  `company_id` int NOT NULL,
  `user_id` int NOT NULL,
  `role_id` int UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_user`
--

INSERT INTO `role_user` (`id`, `company_id`, `user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '2025-02-14 02:23:22', NULL),
(2, 1, 1, 2, '2025-02-14 02:23:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sub_modules`
--

CREATE TABLE `sub_modules` (
  `id` int UNSIGNED NOT NULL,
  `sub_module_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_icon_id` int DEFAULT NULL,
  `key` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `module_id` int UNSIGNED DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `is_custom` int NOT NULL DEFAULT '0',
  `allowed_permissions` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sub_modules`
--

INSERT INTO `sub_modules` (`id`, `sub_module_name`, `description`, `module_icon_id`, `key`, `module_id`, `company_id`, `is_custom`, `allowed_permissions`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Add Employee', 'Add Employee', 3, 'add_employee', 1, 1, 0, '{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}', 'active', '2025-02-13 23:52:00', NULL),
(2, 'View Employee', 'View Employee', 4, 'view_employee', 1, 1, 0, '{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}', 'active', '2025-02-13 23:52:00', NULL),
(3, 'Add Attendance ', 'Add Attendance ', 5, 'add_attendance', 2, 1, 0, '{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}', 'active', '2025-02-13 23:52:00', NULL),
(4, 'View Attendance ', 'View Attendance ', 6, 'view_attendance', 2, 1, 0, '{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}', 'active', '2025-02-13 23:52:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `company_id` int DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phoneNumber` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  `login` enum('enable','disable') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'enable',
  `email_notifications` enum('enable','disable') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'enable',
  `customized_permissions` enum('enable','disable') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'male',
  `dob` date DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `state` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `zip` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `countryCode` varchar(3) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `company_id`, `name`, `email`, `password`, `phoneNumber`, `role`, `status`, `login`, `email_notifications`, `customized_permissions`, `last_login`, `gender`, `dob`, `address`, `city`, `state`, `country`, `zip`, `countryCode`, `image`, `createdAt`, `updatedAt`) VALUES
(1, NULL, 'Kathick', 'ananda.s@pazl.info', '$2b$10$S3VzRzWAetvQifzSHrMB3OTrY25Vn2zUnVzyiS6lMiZiSyf4uGFEu', NULL, '', 'active', 'enable', 'enable', 'enable', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-03 18:46:55', '2025-02-03 18:46:55'),
(2, 1, 'Ananda Kathick', 'anandas.s@pazl.info', '$2b$10$yxRXIDHw2O.wEmjBXu1GJuhSmN9lhUDTxSM9vIdQEKP3vDUeOLgBK', NULL, '', 'active', 'enable', 'enable', 'enable', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-02-03 18:47:52', '2025-02-03 18:47:52');

-- --------------------------------------------------------

--
-- Table structure for table `user_permissions`
--

CREATE TABLE `user_permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `sub_module_id` int UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `permission_type_id` bigint UNSIGNED NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_permissions`
--

INSERT INTO `user_permissions` (`id`, `sub_module_id`, `user_id`, `permission_type_id`, `company_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 4, 1, NULL, NULL),
(2, 2, 1, 4, 1, NULL, NULL),
(3, 3, 1, 4, 1, NULL, NULL),
(4, 4, 1, 4, 1, NULL, NULL),
(5, 4, 1, 4, 1, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_logs`
--
ALTER TABLE `api_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `api_logs_userId_idx` (`userId`),
  ADD KEY `api_logs_statusCode_idx` (`statusCode`),
  ADD KEY `api_logs_createdAt_idx` (`createdAt`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`,`phone`);

--
-- Indexes for table `forms`
--
ALTER TABLE `forms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `module_id` (`module_id`);

--
-- Indexes for table `form_fields`
--
ALTER TABLE `form_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `form_id` (`form_id`),
  ADD KEY `module_id` (`module_id`),
  ADD KEY `input_type_id` (`input_type_id`);

--
-- Indexes for table `form_submissions`
--
ALTER TABLE `form_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `form_id` (`form_id`);

--
-- Indexes for table `form_submission_values`
--
ALTER TABLE `form_submission_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `submission_id` (`submission_id`),
  ADD KEY `field_id` (`field_id`);

--
-- Indexes for table `input_types`
--
ALTER TABLE `input_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type` (`type`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `module_group_id` (`module_group_id`),
  ADD KEY `module_icon_id` (`module_icon_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `module_groups`
--
ALTER TABLE `module_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_name` (`group_name`);

--
-- Indexes for table `module_icons`
--
ALTER TABLE `module_icons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `icon_name` (`icon_name`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_module_id_unique` (`name`,`module_id`),
  ADD KEY `permissions_module_id_foreign` (`module_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`sub_module_id`,`role_id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `permission_type_id` (`permission_type_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `permission_types`
--
ALTER TABLE `permission_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_company_id_unique` (`name`,`company_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `sub_modules`
--
ALTER TABLE `sub_modules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `module_icon_id` (`module_icon_id`),
  ADD KEY `module_id` (`module_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phoneNumber` (`phoneNumber`),
  ADD KEY `idx_users_email` (`email`),
  ADD KEY `idx_users_phoneNumber` (`phoneNumber`),
  ADD KEY `idx_users_status` (`status`),
  ADD KEY `idx_users_company_id` (`company_id`);

--
-- Indexes for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `permission_type_id` (`permission_type_id`),
  ADD KEY `company_id` (`company_id`),
  ADD KEY `sub_module_id` (`sub_module_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `api_logs`
--
ALTER TABLE `api_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary key of the table';

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary Key', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `forms`
--
ALTER TABLE `forms`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_fields`
--
ALTER TABLE `form_fields`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_submissions`
--
ALTER TABLE `form_submissions`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `form_submission_values`
--
ALTER TABLE `form_submission_values`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `input_types`
--
ALTER TABLE `input_types`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `module_groups`
--
ALTER TABLE `module_groups`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `module_icons`
--
ALTER TABLE `module_icons`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permission_role`
--
ALTER TABLE `permission_role`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `permission_types`
--
ALTER TABLE `permission_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `role_user`
--
ALTER TABLE `role_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sub_modules`
--
ALTER TABLE `sub_modules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_permissions`
--
ALTER TABLE `user_permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `api_logs`
--
ALTER TABLE `api_logs`
  ADD CONSTRAINT `fk_api_logs_users` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `forms`
--
ALTER TABLE `forms`
  ADD CONSTRAINT `forms_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `forms_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`);

--
-- Constraints for table `form_fields`
--
ALTER TABLE `form_fields`
  ADD CONSTRAINT `form_fields_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `form_fields_ibfk_2` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`),
  ADD CONSTRAINT `form_fields_ibfk_3` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  ADD CONSTRAINT `form_fields_ibfk_4` FOREIGN KEY (`input_type_id`) REFERENCES `input_types` (`id`);

--
-- Constraints for table `form_submissions`
--
ALTER TABLE `form_submissions`
  ADD CONSTRAINT `form_submissions_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `form_submissions_ibfk_2` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`);

--
-- Constraints for table `form_submission_values`
--
ALTER TABLE `form_submission_values`
  ADD CONSTRAINT `form_submission_values_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `form_submission_values_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `form_submissions` (`id`),
  ADD CONSTRAINT `form_submission_values_ibfk_3` FOREIGN KEY (`field_id`) REFERENCES `form_fields` (`id`);

--
-- Constraints for table `input_types`
--
ALTER TABLE `input_types`
  ADD CONSTRAINT `input_types_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `modules_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `modules_ibfk_2` FOREIGN KEY (`module_group_id`) REFERENCES `module_groups` (`id`),
  ADD CONSTRAINT `modules_ibfk_3` FOREIGN KEY (`module_icon_id`) REFERENCES `module_icons` (`id`),
  ADD CONSTRAINT `modules_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `permissions`
--
ALTER TABLE `permissions`
  ADD CONSTRAINT `permissions_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  ADD CONSTRAINT `permissions_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `permissions_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `permission_role_ibfk_2` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`),
  ADD CONSTRAINT `permission_role_ibfk_3` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `permission_types`
--
ALTER TABLE `permission_types`
  ADD CONSTRAINT `permission_types_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `role_user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `role_user_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `sub_modules`
--
ALTER TABLE `sub_modules`
  ADD CONSTRAINT `sub_modules_ibfk_1` FOREIGN KEY (`module_icon_id`) REFERENCES `module_icons` (`id`),
  ADD CONSTRAINT `sub_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  ADD CONSTRAINT `sub_modules_ibfk_3` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD CONSTRAINT `user_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_permissions_ibfk_3` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`),
  ADD CONSTRAINT `user_permissions_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  ADD CONSTRAINT `user_permissions_ibfk_5` FOREIGN KEY (`sub_module_id`) REFERENCES `sub_modules` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
