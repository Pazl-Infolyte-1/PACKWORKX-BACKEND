-- Adminer 4.8.1 MySQL 8.0.41-0ubuntu0.22.04.1 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER ;;

DROP PROCEDURE IF EXISTS `GetFormStructure`;;
CREATE PROCEDURE `GetFormStructure`(IN `subModuleKey` varchar(255))
BEGIN
    SELECT 
        f.id AS formKey,
        sm.sub_module_name AS pageTitle,
        fg.group_name AS groupName,
        fg.id AS groupId,
        f.id AS inputId,
        f.form_id AS formId,
        f.input_type_id,
        it.type AS inputType, -- Added this line
        f.label AS inputLabel,
        f.placeholder AS inputPlaceholder,
        f.required AS inputRequired,
        f.name AS inputName,
        f.default_value AS inputDefaultValue,
        fo.id AS optionId,
        fo.label AS optionLabel
    FROM forms AS frm
    INNER JOIN form_fields_group AS fg ON fg.form_id = frm.id
    INNER JOIN form_fields AS f ON f.form_group_id = fg.id
    INNER JOIN input_types AS it ON it.id = f.input_type_id -- Added this join
    LEFT JOIN form_fields_option_value AS fo ON fo.form_field_id = f.id
    INNER JOIN sub_modules AS sm ON sm.id = frm.sub_module_id
    WHERE sm.`key` = subModuleKey;
END;;

DROP PROCEDURE IF EXISTS `GetUserModules`;;
CREATE PROCEDURE `GetUserModules`(IN `p_user_id` int, IN `p_company_id` int)
BEGIN
    DECLARE v_customized_permissions VARCHAR(10);

    -- Fetch the customized_permissions value for the user
    SELECT customized_permissions 
    INTO v_customized_permissions 
    FROM users 
    WHERE id = p_user_id;

    IF v_customized_permissions = 'enable' THEN
        SELECT 
            module_groups.group_name,
            modules.module_name,
            modules.key AS module_key,
            MIM.icon_name AS module_icon_name,
            sub_modules.sub_module_name,
            sub_modules.key AS sub_module_key,
            MISM.icon_name AS sub_module_icon_name,
            sub_modules.form_type AS sub_module_form_type,
            sub_modules.id AS sub_module_id
        FROM sub_modules
        INNER JOIN module_icons AS MISM ON sub_modules.module_icon_id = MISM.id
        INNER JOIN modules ON sub_modules.module_id = modules.id
        INNER JOIN module_icons AS MIM ON modules.module_icon_id = MIM.id
        INNER JOIN module_groups ON modules.module_group_id = module_groups.id
        WHERE sub_modules.id IN (
            SELECT sub_module_id  
            FROM user_permissions 
            WHERE user_id = p_user_id 
              AND permission_type_id != 5 
              AND company_id = p_company_id
        ) 
          AND sub_modules.is_custom = 0 
          AND sub_modules.company_id = p_company_id 
          AND sub_modules.status = 'active' 
          AND modules.company_id = p_company_id 
          AND modules.status = 'active' 
          AND module_groups.company_id = p_company_id 
          AND module_groups.status = 'active' 
        ORDER BY module_groups.module_groups_order ASC,
                 modules.module_order ASC,
                 sub_modules.sub_modules_order ASC;
    ELSE
        SELECT 
            module_groups.group_name,
            modules.module_name,
            modules.key AS module_key,
            MIM.icon_name AS module_icon_name,
            sub_modules.sub_module_name,
            sub_modules.key AS sub_module_key,
            sub_modules.form_type AS sub_module_form_type,
            MISM.icon_name AS sub_module_icon_name,
            sub_modules.id AS sub_module_id
        FROM sub_modules
        INNER JOIN module_icons AS MISM ON sub_modules.module_icon_id = MISM.id
        INNER JOIN modules ON sub_modules.module_id = modules.id
        INNER JOIN module_icons AS MIM ON modules.module_icon_id = MIM.id
        INNER JOIN module_groups ON modules.module_group_id = module_groups.id
        WHERE sub_modules.id IN (
            SELECT sub_module_id 
            FROM permission_role 
            WHERE role_id IN (
                SELECT role_id 
                FROM role_user 
                WHERE user_id = p_user_id 
                  AND company_id = p_company_id
            ) 
              AND permission_type_id != 5 
              AND company_id = p_company_id
        ) 
          AND sub_modules.is_custom = 0 
          AND sub_modules.company_id = p_company_id 
          AND sub_modules.status = 'active' 
          AND modules.company_id = p_company_id 
          AND modules.status = 'active' 
          AND module_groups.company_id = p_company_id 
          AND module_groups.status = 'active' 
        ORDER BY module_groups.module_groups_order ASC,
                 modules.module_order ASC,
                 sub_modules.sub_modules_order ASC;
    END IF;
END;;

DELIMITER ;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `api_logs`;
CREATE TABLE `api_logs` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary key of the table',
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
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp when the record was last updated',
  PRIMARY KEY (`id`),
  KEY `api_logs_userId_idx` (`userId`),
  KEY `api_logs_statusCode_idx` (`statusCode`),
  KEY `api_logs_createdAt_idx` (`createdAt`),
  CONSTRAINT `fk_api_logs_users` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Table containing logs of API requests and responses';

INSERT INTO `api_logs` (`id`, `userId`, `method`, `url`, `statusCode`, `requestBody`, `requestHeaders`, `responseBody`, `errorMessage`, `stackTrace`, `duration`, `createdAt`, `updatedAt`) VALUES
(1,	NULL,	'POST',	'/api/user/login',	200,	'{\"userName\":\"anandas.s@pazl.info\",\"password\":\"123456\"}',	'{\"connection\":\"upgrade\",\"host\":\"packworkx.pazl.info\",\"content-length\":\"70\",\"request-body\":\"VjJ4b2EyUnNiM2RpUlZKU1ZqSlNTMWx0ZUdGT2JHUnpZVVYwVlUxWGVGbFVWbVEwVTIxR2RFOVhOVlJXZWtaSVdrWmFjMWRGTlZoa1JuQllVbFJGZUZkWWNFTlJNbEY0WWtac2FsTkZOVTVaYkdRMFRWWmtkRTFFVW1oV1dHaERXV3BLYTFOc1JYZFNiVFZVVm5wV1JGbFZaRTVsYkZKeFZHMXNUazFJUW5sVk1XUjNaR3h2ZDJKSVJsTlhSM2hQV2xkNFJtVkdVblJpUlhCVVRXeHdVMVZHVVhkUVVUMDk=\",\"content-type\":\"application/json\",\"authorization\":\"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicGhvbmVOdW1iZXIiOiI5MDAzMDk2ODg1IiwiaWF0IjoxNzM4MjM4Mzk4fQ.Dih8ofDPko1nn7yRahVo0gW_XdVX0l7ylsfEYzR_Gus\",\"user-agent\":\"PostmanRuntime/7.43.0\",\"accept\":\"*/*\",\"postman-token\":\"385cc68a-7f2d-4f7c-acd9-bb2356ce1567\",\"accept-encoding\":\"gzip, deflate, br\"}',	'{\"status\":true,\"message\":\"Login successful\",\"data\":{\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzM5OTU3Nzc4LCJleHAiOjE3NDA4MjE3Nzh9.4t-y2A3ykgB2iCGO-ih7QPIOSgPNgw9sAOAjGDb5Im4\"}}',	'',	'',	129,	'2025-02-19 09:36:18',	'2025-02-19 09:36:18'),
(2,	NULL,	'POST',	'/api/user/login',	200,	'{\"userName\":\"anandas.s@pazl.info\",\"password\":\"123456\"}',	'{\"connection\":\"upgrade\",\"host\":\"packworkx.pazl.info\",\"content-length\":\"54\",\"sec-ch-ua-platform\":\"\\\"Windows\\\"\",\"user-agent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36\",\"accept\":\"application/json, text/plain, */*\",\"sec-ch-ua\":\"\\\"Not(A:Brand\\\";v=\\\"99\\\", \\\"Google Chrome\\\";v=\\\"133\\\", \\\"Chromium\\\";v=\\\"133\\\"\",\"content-type\":\"application/json\",\"sec-ch-ua-mobile\":\"?0\",\"origin\":\"http://localhost:3000\",\"sec-fetch-site\":\"cross-site\",\"sec-fetch-mode\":\"cors\",\"sec-fetch-dest\":\"empty\",\"referer\":\"http://localhost:3000/\",\"accept-encoding\":\"gzip, deflate, br, zstd\",\"accept-language\":\"en-US,en;q=0.9\"}',	'{\"status\":true,\"message\":\"Login successful\",\"data\":{\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzM5OTU4MDQ3LCJleHAiOjE3NDA4MjIwNDd9.V20vZohgA8qcRI-a8Zj6mRuf800MCRlHdDB6ge8FuhE\"}}',	'',	'',	93,	'2025-02-19 09:40:47',	'2025-02-19 09:40:47'),
(3,	NULL,	'POST',	'/api/user/login',	200,	'{\"userName\":\"anandas.s@pazl.info\",\"password\":\"123456\"}',	'{\"connection\":\"upgrade\",\"host\":\"packworkx.pazl.info\",\"content-length\":\"70\",\"content-type\":\"application/json\",\"user-agent\":\"PostmanRuntime/7.43.0\",\"accept\":\"*/*\",\"postman-token\":\"fc27bc54-d00a-414f-8d37-5dcc920ccfdd\",\"accept-encoding\":\"gzip, deflate, br\"}',	'{\"status\":true,\"message\":\"Login successful\",\"data\":{\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzM5OTU4ODYzLCJleHAiOjE3NDA4MjI4NjN9.Qa8P5l9cHLJuhA9ORR-GjPJsu4rwpx3yNigHgxCjVJc\"}}',	'',	'',	88,	'2025-02-19 09:54:23',	'2025-02-19 09:54:23'),
(4,	NULL,	'POST',	'/api/user/login',	200,	'{\"userName\":\"anandas.s@pazl.info\",\"password\":\"123456\"}',	'{\"connection\":\"upgrade\",\"host\":\"packworkx.pazl.info\",\"content-length\":\"70\",\"request-body\":\"VjJ4b2EyUnNiM2RpUlZKU1ZqSlNTMWx0ZUdGT2JHUnpZVVYwVlUxWGVGbFVWbVEwVTIxR2RFOVhOVlJXZWtaSVdrWmFjMWRGTlZoa1JuQllVbFJGZUZkWWNFTlJNbEY0WWtac2FsTkZOVTVaYkdRMFRWWmtkRTFFVW1oV1dHaERXV3BLYTFOc1JYZFNiVFZVVm5wV1JGbFZaRTVsYkZKeFZHMXNUazFJUW5sVk1XUjNaR3h2ZDJKSVJsTlhSM2hQV2xkNFJtVkdVblJpUlhCVVRXeHdVMVZHVVhkUVVUMDk=\",\"content-type\":\"application/json\",\"authorization\":\"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicGhvbmVOdW1iZXIiOiI5MDAzMDk2ODg1IiwiaWF0IjoxNzM4MjM4Mzk4fQ.Dih8ofDPko1nn7yRahVo0gW_XdVX0l7ylsfEYzR_Gus\",\"user-agent\":\"PostmanRuntime/7.43.0\",\"accept\":\"*/*\",\"postman-token\":\"d800dbb0-2f2f-494f-b295-1bc0a5630041\",\"accept-encoding\":\"gzip, deflate, br\"}',	'{\"status\":true,\"message\":\"Login successful\",\"data\":{\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzQwMDE5MjMzLCJleHAiOjE3NDA4ODMyMzN9.s4OxwyQTAlDqdzPevih-o40yBJWZ3HSJ4T1BXEhmKUc\"}}',	'',	'',	134,	'2025-02-20 02:40:33',	'2025-02-20 02:40:33'),
(5,	NULL,	'POST',	'/api/user/login',	200,	'{\"userName\":\"anandas.s@pazl.info\",\"password\":\"123456\"}',	'{\"request-body\":\"VjJ4b2EyUnNiM2RpUlZKU1ZqSlNTMWx0ZUdGT2JHUnpZVVYwVlUxWGVGbFVWbVEwVTIxR2RFOVhOVlJXZWtaSVdrWmFjMWRGTlZoa1JuQllVbFJGZUZkWWNFTlJNbEY0WWtac2FsTkZOVTVaYkdRMFRWWmtkRTFFVW1oV1dHaERXV3BLYTFOc1JYZFNiVFZVVm5wV1JGbFZaRTVsYkZKeFZHMXNUazFJUW5sVk1XUjNaR3h2ZDJKSVJsTlhSM2hQV2xkNFJtVkdVblJpUlhCVVRXeHdVMVZHVVhkUVVUMDk=\",\"content-type\":\"application/json\",\"authorization\":\"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwicGhvbmVOdW1iZXIiOiI5MDAzMDk2ODg1IiwiaWF0IjoxNzM4MjM4Mzk4fQ.Dih8ofDPko1nn7yRahVo0gW_XdVX0l7ylsfEYzR_Gus\",\"user-agent\":\"PostmanRuntime/7.43.0\",\"accept\":\"*/*\",\"postman-token\":\"f32f5017-3ac6-4731-91c7-77eb4c405fe4\",\"host\":\"localhost:3002\",\"accept-encoding\":\"gzip, deflate, br\",\"connection\":\"keep-alive\",\"content-length\":\"70\"}',	'{\"status\":true,\"message\":\"Login successful\",\"data\":{\"token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzQwMDE5Mjg4LCJleHAiOjE3NDA4ODMyODh9.7c599xFS4nWyVZgal85W5Lf-JXvIkF7Du95hkAPde08\"}}',	'',	'',	2768,	'2025-02-20 02:41:28',	'2025-02-20 02:41:31');

DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
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
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update date',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `companies` (`id`, `name`, `email`, `phone`, `website`, `address`, `city`, `state`, `country`, `zip`, `countryCode`, `logo`, `timezone`, `date_format`, `time_format`, `latitude`, `longitude`, `ticket_count`, `user_count`, `status`, `valid_from`, `valid_till`, `login`, `email_notifications`, `createdAt`, `updatedAt`) VALUES
(1,	'Pacx work',	'pacx@pazl.info',	NULL,	NULL,	'123 Main St, New York',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'active',	NULL,	NULL,	'enable',	'enable',	'2025-02-03 16:31:34',	'2025-02-03 16:48:32');

DROP TABLE IF EXISTS `form_fields`;
CREATE TABLE `form_fields` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_id` int unsigned NOT NULL,
  `module_id` int unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `input_type_id` int unsigned NOT NULL,
  `form_group_id` int NOT NULL,
  `required` enum('yes','no') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'no',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `table_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `key_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `column_type` enum('row','column') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int DEFAULT NULL,
  `input_value_type` enum('static','dynamic') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'static',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `form_id` (`form_id`),
  KEY `module_id` (`module_id`),
  KEY `input_type_id` (`input_type_id`),
  KEY `form_group_id` (`form_group_id`),
  CONSTRAINT `form_fields_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `form_fields_ibfk_2` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`),
  CONSTRAINT `form_fields_ibfk_3` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `form_fields_ibfk_4` FOREIGN KEY (`input_type_id`) REFERENCES `input_types` (`id`),
  CONSTRAINT `form_fields_ibfk_5` FOREIGN KEY (`form_group_id`) REFERENCES `form_fields_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `form_fields` (`id`, `company_id`, `form_id`, `module_id`, `label`, `name`, `description`, `input_type_id`, `form_group_id`, `required`, `placeholder`, `default_value`, `table_data`, `key_name`, `column_type`, `order`, `input_value_type`, `created_at`, `updated_at`, `status`) VALUES
(1,	1,	3,	4,	'Customer Type',	'customer_type',	NULL,	14,	2,	'no',	NULL,	'1',	NULL,	'customer_type',	NULL,	1,	'static',	'2025-02-19 12:22:08',	'2025-02-19 12:22:08',	'active'),
(2,	1,	2,	5,	' SKU',	'sku',	NULL,	15,	3,	'no',	'',	NULL,	NULL,	'sku',	NULL,	1,	'static',	'2025-02-19 16:54:46',	'2025-02-19 16:54:46',	'active'),
(5,	1,	3,	4,	'Primary Contact',	'salutation',	NULL,	15,	2,	'no',	'Select Salutation',	NULL,	NULL,	'salutation',	NULL,	1,	'static',	'2025-02-19 12:47:24',	'2025-02-19 12:47:24',	'active'),
(6,	1,	2,	5,	'SKU Version',	'sku_version',	NULL,	1,	3,	'no',	'Preview of SKU Version',	NULL,	NULL,	'sku_version',	NULL,	1,	'static',	'2025-02-19 12:48:07',	'2025-02-19 12:48:07',	'active'),
(7,	1,	2,	5,	'Planned End Date',	'planned_end_date',	NULL,	4,	3,	'no',	NULL,	NULL,	NULL,	'planned_end_date',	NULL,	1,	'static',	'2025-02-19 12:57:23',	'2025-02-19 12:57:23',	'active'),
(8,	1,	3,	4,	'Primary Contact',	'first_name',	NULL,	1,	2,	'no',	'Enter The First Name',	NULL,	NULL,	'first_name',	NULL,	1,	'static',	'2025-02-19 14:56:24',	'2025-02-19 14:56:24',	'active'),
(9,	1,	3,	4,	'Primary Contact',	'last_name',	NULL,	1,	2,	'no',	'Enter The Last Name',	NULL,	NULL,	'last_name',	NULL,	1,	'static',	'2025-02-19 15:09:48',	'2025-02-19 15:09:48',	'active'),
(10,	1,	3,	4,	'Company Name',	'company_name',	NULL,	1,	2,	'no',	'Enter The Company Name',	NULL,	NULL,	'company_name',	NULL,	1,	'static',	'2025-02-19 15:12:26',	'2025-02-19 15:12:26',	'active'),
(11,	1,	3,	4,	'Display Name',	'display_name',	NULL,	1,	2,	'yes',	' Enter The Display Name',	NULL,	NULL,	'display_name',	NULL,	1,	'static',	'2025-02-19 15:16:03',	'2025-02-19 15:16:03',	'active'),
(12,	1,	3,	4,	'Email Address',	'email_address',	NULL,	3,	2,	'no',	' Enter The Email Address',	NULL,	NULL,	'email_address',	NULL,	1,	'static',	'2025-02-19 15:20:15',	'2025-02-19 15:20:15',	'active'),
(13,	1,	3,	4,	'Phone',	'work_phone',	NULL,	5,	2,	'no',	' Enter The Work Phone',	NULL,	NULL,	'work_phone',	NULL,	1,	'static',	'2025-02-19 15:22:58',	'2025-02-19 15:22:58',	'active'),
(14,	1,	3,	4,	'Phone',	'mobile',	NULL,	5,	2,	'no',	'Enter The Mobile',	NULL,	NULL,	'mobile',	NULL,	1,	'static',	'2025-02-19 15:25:37',	'2025-02-19 15:25:37',	'active'),
(15,	1,	1,	3,	'Client',	'client',	NULL,	1,	1,	'no',	'Enter The Client Name',	NULL,	NULL,	'client',	NULL,	1,	'static',	'2025-02-19 15:45:28',	'2025-02-19 15:45:28',	'active'),
(16,	1,	1,	3,	'Ply',	'Ply',	NULL,	15,	1,	'no',	'Enter The Ply',	NULL,	NULL,	'Ply',	NULL,	1,	'static',	'2025-02-19 15:49:40',	'2025-02-19 15:49:40',	'active'),
(17,	1,	3,	4,	'PAN',	'pan',	NULL,	1,	4,	'no',	' Enter The PAN',	NULL,	NULL,	'pan',	NULL,	1,	'static',	'2025-02-19 15:53:52',	'2025-02-20 05:10:46',	'active'),
(18,	1,	3,	4,	'Currency',	'currency',	NULL,	15,	4,	'no',	' Select The Currency',	'6',	NULL,	'currency',	NULL,	1,	'static',	'2025-02-19 15:59:40',	'2025-02-20 05:10:46',	'active'),
(19,	1,	3,	4,	'Opening Balance',	'opening_balance',	NULL,	4,	4,	'no',	' Enter The Opening Balance',	NULL,	NULL,	'opening_balance',	NULL,	1,	'static',	'2025-02-19 16:06:46',	'2025-02-20 05:10:46',	'active'),
(20,	1,	3,	4,	'Payment Terms',	'payment_terms',	NULL,	15,	4,	'no',	'Select The Payment Terms',	'8',	NULL,	'payment_terms',	NULL,	1,	'static',	'2025-02-19 16:18:49',	'2025-02-20 05:10:46',	'active'),
(21,	1,	3,	4,	'Enable Portal ?',	'enable_portal ',	NULL,	13,	4,	'no',	NULL,	NULL,	NULL,	'enable_portal ',	NULL,	1,	'static',	'2025-02-19 16:25:55',	'2025-02-20 05:10:46',	'active'),
(22,	1,	3,	4,	'Portal Language',	'portal_language',	NULL,	15,	4,	'no',	'Select Portal Language',	'10',	NULL,	'portal_language',	NULL,	1,	'static',	'2025-02-19 16:29:24',	'2025-02-20 05:10:46',	'active'),
(23,	1,	3,	4,	'Documents',	'documents',	NULL,	16,	4,	'no',	NULL,	NULL,	NULL,	'documents',	NULL,	1,	'static',	'2025-02-19 16:33:08',	'2025-02-20 05:10:46',	'active'),
(24,	1,	3,	4,	'Website URL',	'website_url',	NULL,	6,	4,	'no',	'ex:www.demo.com',	NULL,	NULL,	'website_url',	NULL,	1,	'static',	'2025-02-19 16:39:36',	'2025-02-20 05:10:46',	'active'),
(25,	1,	3,	4,	'Department',	'department',	NULL,	1,	4,	'no',	'Enter The  Department',	NULL,	NULL,	'department',	NULL,	1,	'static',	'2025-02-19 16:42:27',	'2025-02-20 05:10:46',	'active'),
(26,	1,	3,	4,	'Designation',	'designation',	NULL,	1,	4,	'no',	'Enter The Designation',	NULL,	NULL,	'designation',	NULL,	1,	'static',	'2025-02-19 16:43:43',	'2025-02-20 05:10:46',	'active'),
(27,	1,	3,	4,	'Twitter',	'twitter',	NULL,	6,	4,	'no',	'ex:www.twitter.com',	NULL,	NULL,	'twitter',	NULL,	1,	'static',	'2025-02-19 16:44:53',	'2025-02-20 05:10:46',	'active'),
(28,	1,	1,	3,	'Length',	'length',	NULL,	1,	1,	'no',	'Enter The Length',	NULL,	NULL,	'length',	NULL,	1,	'static',	'2025-02-19 16:52:19',	'2025-02-19 16:52:19',	'active'),
(29,	1,	1,	3,	'Width',	'width',	NULL,	1,	1,	'no',	'Enter The Width',	NULL,	NULL,	'width',	NULL,	1,	'static',	'2025-02-19 16:54:02',	'2025-02-19 16:54:02',	'active'),
(30,	1,	1,	3,	'Height',	'height',	NULL,	1,	1,	'no',	'Enter The Height',	NULL,	NULL,	'height',	NULL,	1,	'static',	'2025-02-19 16:55:08',	'2025-02-19 16:55:08',	'active'),
(31,	1,	1,	3,	'Joints',	'joints',	NULL,	1,	1,	'no',	'Enter The Joints',	NULL,	NULL,	'joints',	NULL,	1,	'static',	'2025-02-19 16:56:55',	'2025-02-19 16:56:55',	'active'),
(32,	1,	1,	3,	'Ups',	'ups',	NULL,	1,	1,	'no',	'Enter The Ups',	NULL,	NULL,	'ups',	NULL,	1,	'static',	'2025-02-19 16:58:16',	'2025-02-19 16:58:16',	'active'),
(33,	1,	1,	3,	'Inner/Outer_Dimension',	'inner/outer_dimension',	NULL,	14,	1,	'no',	NULL,	NULL,	NULL,	'inner/outer_dimension',	NULL,	1,	'static',	'2025-02-19 17:00:17',	'2025-02-19 17:00:17',	'active'),
(34,	1,	3,	4,	'Skype Name/ Number',	'skype_name/ number',	NULL,	1,	4,	'no',	'Enter The Skype Name/ Number',	NULL,	NULL,	'skype_name/ number',	NULL,	1,	'static',	'2025-02-19 17:01:25',	'2025-02-20 05:10:46',	'active'),
(35,	1,	1,	3,	'Flap Width',	'flap_width',	NULL,	1,	1,	'no',	'Enter The Flap Width',	NULL,	NULL,	'flap_width',	NULL,	1,	'static',	'2025-02-19 17:03:51',	'2025-02-19 17:03:51',	'active'),
(36,	1,	1,	3,	'Flap Tolerance',	'flap_tolerance',	NULL,	1,	1,	'no',	'Enter The Flap Tolerance',	NULL,	NULL,	'flap_tolerance',	NULL,	1,	'static',	'2025-02-19 17:05:03',	'2025-02-19 17:05:03',	'active'),
(37,	1,	3,	4,	'Facebook',	'facebook',	NULL,	6,	4,	'no',	'www.facebook.com',	NULL,	NULL,	'facebook',	NULL,	1,	'static',	'2025-02-19 17:05:46',	'2025-02-20 05:10:46',	'active'),
(38,	1,	1,	3,	'Length Trimming Tolerance',	'length_trimming_tolerance',	NULL,	1,	1,	'no',	'Enter The Length Trimming Tolerance',	NULL,	NULL,	'length_trimming_tolerance',	NULL,	1,	'static',	'2025-02-19 17:06:16',	'2025-02-19 17:06:16',	'active'),
(39,	1,	1,	3,	'Width Trimming Tolerance',	'width_trimming_tolerance',	NULL,	1,	1,	'no',	'Enter The Width Trimming Tolerance',	NULL,	NULL,	'width_trimming_tolerance',	NULL,	1,	'static',	'2025-02-19 17:07:52',	'2025-02-19 17:07:52',	'active'),
(40,	1,	2,	5,	'Estimated Delivery Date',	'estimated delivery_date',	NULL,	8,	3,	'no',	NULL,	NULL,	NULL,	'estimated delivery_date',	NULL,	1,	'static',	'2025-02-19 17:11:37',	'2025-02-19 17:11:37',	'active'),
(41,	1,	1,	3,	'Strict Adherence for All Layers',	'strict_adherence_for_all_layers',	NULL,	24,	1,	'no',	NULL,	NULL,	NULL,	'strict_adherence_for_all_layers',	NULL,	1,	'static',	'2025-02-19 17:13:01',	'2025-02-19 17:13:01',	'active'),
(42,	1,	1,	3,	'Customer reference',	'customer_reference',	NULL,	1,	1,	'no',	'Enter The Customer reference',	NULL,	NULL,	'customer_reference',	NULL,	1,	'static',	'2025-02-19 17:22:36',	'2025-02-19 17:22:36',	'active'),
(43,	1,	2,	5,	'Quantity Required',	'quantity_required',	NULL,	4,	3,	'no',	NULL,	NULL,	NULL,	'quantity_required',	NULL,	1,	'static',	'2025-02-19 17:23:24',	'2025-02-19 17:23:24',	'active'),
(44,	1,	1,	3,	'Reference #',	'reference_ #',	NULL,	1,	1,	'no',	'Enter The Reference #',	NULL,	NULL,	'reference_ #',	NULL,	1,	'static',	'2025-02-19 17:24:32',	'2025-02-19 17:24:32',	'active'),
(45,	1,	1,	3,	'Internal ID',	'internal_id',	NULL,	1,	1,	'no',	'Enter The Internal ID',	NULL,	NULL,	'internal_id',	NULL,	1,	'static',	'2025-02-19 17:25:44',	'2025-02-19 17:25:44',	'active'),
(46,	1,	1,	3,	'Board Size (cm2)',	'board_size_(cm2)',	NULL,	1,	1,	'no',	'Enter The Board Size (cm2)',	NULL,	NULL,	'board_size_(cm2)',	NULL,	1,	'static',	'2025-02-19 17:27:17',	'2025-02-19 17:27:17',	'active'),
(47,	1,	2,	5,	'Planned Start Date',	'planned_start_date',	NULL,	8,	3,	'no',	NULL,	NULL,	NULL,	'planned_start_date',	NULL,	1,	'static',	'2025-02-19 17:28:20',	'2025-02-19 17:28:20',	'active'),
(48,	1,	1,	3,	'Deckle size',	'deckle_size',	NULL,	1,	1,	'no',	'Enter The Deckle size',	NULL,	NULL,	'deckle_size',	NULL,	1,	'static',	'2025-02-19 17:28:28',	'2025-02-19 17:28:28',	'active'),
(49,	1,	2,	5,	'Description',	'description',	NULL,	1,	3,	'no',	'Enter The Description',	NULL,	NULL,	'description',	NULL,	1,	'static',	'2025-02-19 17:31:23',	'2025-02-19 17:31:23',	'active'),
(51,	1,	2,	5,	'Acceptable Excess Units',	'acceptable_excess_units',	NULL,	4,	3,	'no',	NULL,	NULL,	NULL,	'acceptable_excess_units',	NULL,	1,	'static',	'2025-02-19 17:36:49',	'2025-02-19 17:36:49',	'active'),
(52,	1,	1,	3,	'Minimum Order Level',	'minimum_order_level',	NULL,	4,	1,	'no',	'Enter The Minimum Order Level',	NULL,	NULL,	'minimum_order_level',	NULL,	1,	'static',	'2025-02-19 17:37:01',	'2025-02-19 17:37:01',	'active'),
(53,	1,	3,	4,	'Attention',	'attention',	NULL,	1,	5,	'no',	' Enter The Attention',	NULL,	NULL,	'attention',	NULL,	1,	'static',	'2025-02-19 17:39:33',	'2025-02-20 05:10:46',	'active'),
(54,	1,	3,	4,	'Country/ Region',	'country/ region',	NULL,	15,	5,	'no',	' Select Country/ Region',	NULL,	NULL,	'country/ region',	NULL,	1,	'static',	'2025-02-19 17:42:52',	'2025-02-20 05:10:46',	'active'),
(55,	1,	1,	3,	'SKU Type',	'sku_type',	NULL,	15,	6,	'no',	NULL,	NULL,	NULL,	'sku_type',	NULL,	1,	'static',	'2025-02-19 17:49:47',	'2025-02-19 17:49:47',	'active'),
(56,	1,	2,	5,	'How Do You Want To Manufacture',	'how_do_you_want_to_manufacture',	NULL,	24,	3,	'no',	NULL,	'21',	NULL,	'how_do_you_want_to_manufacture',	NULL,	1,	'static',	'2025-02-19 17:49:53',	'2025-02-19 17:49:53',	'active'),
(57,	1,	3,	4,	'Address',	'street1',	'street1',	1,	5,	'no',	'Enter The street1',	NULL,	NULL,	'street1',	NULL,	1,	'static',	'2025-02-19 18:41:49',	'2025-02-20 05:10:46',	'active'),
(58,	1,	3,	4,	'Address',	'street2',	'street2',	1,	5,	'no',	'Enter The street2',	NULL,	NULL,	'street2',	NULL,	1,	'static',	'2025-02-19 18:48:50',	'2025-02-20 05:10:46',	'active'),
(59,	1,	3,	4,	'City',	'city',	'City',	1,	5,	'no',	'Enter The City',	NULL,	NULL,	'city',	NULL,	1,	'static',	'2025-02-19 18:49:59',	'2025-02-20 05:10:46',	'active'),
(60,	1,	3,	4,	'State',	'state',	'State',	15,	5,	'no',	'Select State',	NULL,	NULL,	'state',	NULL,	1,	'static',	'2025-02-19 18:53:25',	'2025-02-20 05:10:46',	'active'),
(61,	1,	3,	4,	'Pin Code',	'pin_code',	'Pin Code',	4,	5,	'no',	'Enter The Pin Code',	NULL,	NULL,	'pin_code',	NULL,	1,	'static',	'2025-02-19 18:57:53',	'2025-02-20 05:10:46',	'active'),
(62,	1,	3,	4,	'Fax Number',	'fax_number',	'Fax Number',	4,	5,	'no',	'Enter The Fax Number',	NULL,	NULL,	'fax_number',	NULL,	1,	'static',	'2025-02-19 19:00:13',	'2025-02-20 05:10:46',	'active'),
(63,	1,	3,	4,	'Attention',	'attention',	'Attention',	1,	7,	'no',	'Enter The Attention',	NULL,	NULL,	'attention',	NULL,	1,	'static',	'2025-02-19 19:16:55',	'2025-02-20 05:10:46',	'active'),
(64,	1,	3,	4,	'Country/ Region',	'country/ region',	'Country/ Region',	15,	7,	'no',	'Select Country/Region',	NULL,	NULL,	'country/ region	',	NULL,	1,	'static',	'2025-02-19 19:19:59',	'2025-02-20 05:10:46',	'active'),
(66,	1,	3,	4,	'Address',	'street1',	'street1',	1,	7,	'no',	'Enter The Street1',	NULL,	NULL,	'street1',	NULL,	1,	'static',	'2025-02-19 19:25:54',	'2025-02-20 05:10:46',	'active'),
(67,	1,	3,	4,	'Address',	'street2',	'Street2',	1,	7,	'no',	' Enter The Street2',	NULL,	NULL,	'street2',	NULL,	1,	'static',	'2025-02-19 19:27:35',	'2025-02-20 05:10:46',	'active'),
(68,	1,	3,	4,	'City',	'city',	'City',	1,	7,	'no',	'Enter The City',	NULL,	NULL,	'city',	NULL,	1,	'static',	'2025-02-19 19:30:31',	'2025-02-20 05:10:46',	'active'),
(69,	1,	3,	4,	'State',	'state',	'State',	15,	7,	'no',	'Select State',	NULL,	NULL,	'state',	NULL,	1,	'static',	'2025-02-19 19:32:43',	'2025-02-20 05:10:46',	'active'),
(70,	1,	3,	4,	'Pin Code',	'pin_code',	'Pin Code',	4,	7,	'no',	'Enter The Pin Code',	NULL,	NULL,	'pin_code',	NULL,	1,	'static',	'2025-02-19 19:35:30',	'2025-02-20 05:10:46',	'active'),
(71,	1,	3,	4,	'Phone',	'phone',	'Phone',	4,	7,	'no',	'Enter The Phone Number',	NULL,	NULL,	'phone',	NULL,	1,	'static',	'2025-02-19 19:37:28',	'2025-02-20 05:10:46',	'active'),
(72,	1,	3,	4,	'Phone',	'phone',	'Phone',	4,	5,	'no',	'Enter The Phone Number',	NULL,	NULL,	'phone',	NULL,	1,	'static',	'2025-02-19 19:39:55',	'2025-02-20 05:10:46',	'active'),
(73,	1,	3,	4,	'Fax Number',	'fax_number',	'Fax Number',	4,	7,	'no',	'Enter The Fax Number',	NULL,	NULL,	'fax_number',	NULL,	1,	'static',	'2025-02-19 19:41:30',	'2025-02-20 05:10:46',	'active'),
(74,	1,	3,	4,	'Salutation',	'salutation',	'Salutation',	15,	8,	'no',	'Select Salutation',	NULL,	NULL,	'salutation',	NULL,	1,	'static',	'2025-02-19 19:53:11',	'2025-02-20 05:10:46',	'active'),
(75,	1,	3,	4,	'First Name',	'first_name',	'First Name',	1,	8,	'no',	'Enter The First Name',	NULL,	NULL,	'first_name',	NULL,	1,	'static',	'2025-02-19 19:54:14',	'2025-02-20 05:10:46',	'active'),
(76,	1,	3,	4,	'Last Name',	'last_name',	'Last Name',	1,	8,	'no',	'Enter The Last Name',	NULL,	NULL,	'last_name',	NULL,	1,	'static',	'2025-02-19 19:55:05',	'2025-02-20 05:10:46',	'active'),
(77,	1,	3,	4,	'Email Address',	'email_address',	'Email Address',	3,	8,	'no',	'Enter The Email Address',	NULL,	NULL,	'email_address',	NULL,	1,	'static',	'2025-02-19 19:56:04',	'2025-02-20 05:10:46',	'active'),
(78,	1,	3,	4,	'Work Phone',	'work_phone',	'Work Phone',	5,	8,	'no',	'Enter The Work Phone',	NULL,	NULL,	'work_phone',	NULL,	1,	'static',	'2025-02-19 19:57:09',	'2025-02-20 05:10:46',	'active'),
(79,	1,	3,	4,	'Mobile',	'mobile',	'Mobile',	5,	8,	'no',	'Enter The Mobile',	NULL,	NULL,	'mobile',	NULL,	1,	'static',	'2025-02-19 19:58:10',	'2025-02-20 05:10:46',	'active'),
(80,	1,	2,	5,	'SKU',	'sku',	NULL,	15,	9,	'no',	NULL,	NULL,	NULL,	'sku',	NULL,	1,	'static',	'2025-02-20 06:01:29',	'2025-02-20 06:01:29',	'active'),
(81,	1,	2,	5,	'Quantity Required',	'quantity_required',	NULL,	4,	9,	'no',	NULL,	NULL,	NULL,	'quantity_required',	NULL,	1,	'static',	'2025-02-20 06:06:06',	'2025-02-20 06:06:06',	'active'),
(82,	1,	2,	5,	'Rate Per SKU',	'rate_per_sku',	NULL,	4,	9,	'no',	NULL,	NULL,	NULL,	'rate_per_sku',	NULL,	1,	'static',	'2025-02-20 06:10:00',	'2025-02-20 06:10:00',	'active'),
(83,	1,	2,	5,	'Acceptable Excess Units',	'acceptable_excess_units',	NULL,	4,	9,	'no',	NULL,	NULL,	NULL,	'acceptable_excess_units',	NULL,	1,	'static',	'2025-02-20 06:11:59',	'2025-02-20 06:11:59',	'active'),
(84,	1,	2,	5,	'Total Qty ',	'total_qty',	NULL,	26,	9,	'no',	NULL,	NULL,	NULL,	'total_qty',	NULL,	1,	'static',	'2025-02-20 06:19:11',	'2025-02-20 06:19:11',	'active'),
(85,	1,	2,	5,	'Total',	'total',	NULL,	26,	9,	'no',	NULL,	NULL,	NULL,	'total',	NULL,	NULL,	'static',	'2025-02-20 06:21:35',	'2025-02-20 06:21:35',	'active'),
(86,	1,	2,	5,	'SGST',	'sgst',	NULL,	26,	9,	'no',	NULL,	NULL,	NULL,	'sgst',	NULL,	1,	'static',	'2025-02-20 06:23:18',	'2025-02-20 06:23:18',	'active'),
(87,	1,	2,	5,	'CGST',	'cgst',	NULL,	26,	9,	'no',	NULL,	NULL,	NULL,	'cgst',	NULL,	1,	'static',	'2025-02-20 06:24:28',	'2025-02-20 06:24:28',	'active'),
(88,	1,	2,	5,	'Total Lncl GST',	'total_Incl_gst',	NULL,	26,	9,	'no',	NULL,	NULL,	NULL,	'total_Incl_gst',	NULL,	1,	'static',	'2025-02-20 06:27:13',	'2025-02-20 06:27:13',	'active'),
(89,	1,	2,	5,	'Sales Order Id',	'sales_order_id',	NULL,	1,	10,	'no',	'Enter The Sales Order Id',	NULL,	NULL,	'sales_order_id',	NULL,	1,	'static',	'2025-02-20 06:39:06',	'2025-02-20 06:39:06',	'active'),
(90,	1,	2,	5,	'Estimated Delivery Date',	'estimated_delivery_date',	NULL,	8,	10,	'no',	NULL,	NULL,	NULL,	'estimated_delivery_date',	NULL,	1,	'static',	'2025-02-20 06:41:24',	'2025-02-20 06:41:24',	'active'),
(91,	1,	2,	5,	'Client',	'client',	NULL,	15,	10,	'no',	NULL,	NULL,	NULL,	'client',	NULL,	1,	'static',	'2025-02-20 06:42:52',	'2025-02-20 06:42:52',	'active'),
(92,	1,	2,	5,	'Freight Paid',	'freight_paid',	NULL,	15,	10,	'no',	NULL,	NULL,	NULL,	'freight_paid',	NULL,	1,	'static',	'2025-02-20 06:46:28',	'2025-02-20 06:46:28',	'active'),
(93,	1,	2,	5,	'Credit Period',	'credit_period',	NULL,	1,	10,	'no',	'Enter The Credit Period',	NULL,	NULL,	'credit_period',	NULL,	1,	'static',	'2025-02-20 06:49:44',	'2025-02-20 06:49:44',	'active'),
(94,	1,	2,	5,	'Confirmation By',	'confirmation_by',	NULL,	24,	10,	'no',	NULL,	'43',	NULL,	'confirmation_by',	NULL,	1,	'static',	'2025-02-20 06:51:42',	'2025-02-20 06:51:42',	'active'),
(95,	1,	1,	3,	'Corrugated Sheet',	'corrugated_sheet',	NULL,	25,	6,	'no',	NULL,	NULL,	'{\r\n  \"tableHeaders\": [\r\n    { \"id\": \"#\", \"label\": \"#\" },\r\n    { \"id\": \"GSM\", \"label\": \"GSM\" },\r\n    { \"id\": \"BF\", \"label\": \"BF\" },\r\n    { \"id\": \"Color\", \"label\": \"Color\" },\r\n    { \"id\": \"FluteType\", \"label\": \"Flute Type\" },\r\n    { \"id\": \"FluteRatio\", \"label\": \"Flute Ratio\" },\r\n    { \"id\": \"WeightInKg\", \"label\": \"Weight In Kg\" },\r\n    { \"id\": \"BurstingStrength\", \"label\": \"Bursting Strength (Kg Per Cm2)\" }\r\n  ],\r\n  \"colorOptions\": [\r\n    { \"id\": \"1\", \"label\": \"Golden Yellow\" },\r\n    { \"id\": \"2\", \"label\": \"Natural\" },\r\n    { \"id\": \"3\", \"label\": \"White\" },\r\n    { \"id\": \"4\", \"label\": \"Brown\" }\r\n  ],\r\n  \"tableBody\": [\r\n    {\r\n      \"id\": \"Top_Layer\",\r\n      \"label\": \"Top Layer\",\r\n      \"GSM\": { \"id\": \"GSM\", \"type\": \"input\", \"name\": \"GSM\", \"defaultValue\": \"180\", \"required\": true },\r\n      \"BF\": { \"id\": \"BF\", \"type\": \"input\", \"name\": \"BF\", \"defaultValue\": \"18\", \"required\": true },\r\n      \"Color\": { \r\n        \"id\": \"Color\", \r\n        \"type\": \"select\", \r\n        \"label\": \"Color\", \r\n        \"name\": \"Color\", \r\n        \"defaultValue\": \"1\", \r\n        \"options\": \"colorOptions\", \r\n        \"required\": true \r\n      },\r\n      \"FluteType\": { \"id\": \"FluteType\", \"type\": \"label\", \"defaultValue\": \"-\" },\r\n      \"FluteRatio\": { \"id\": \"FluteRatio\", \"type\": \"label\", \"defaultValue\": \"1\" },\r\n      \"WeightInKg\": { \"id\": \"WeightInKg\", \"type\": \"label\", \"defaultValue\": \"0.102528\" },\r\n      \"BurstingStrength\": { \"id\": \"BurstingStrength\", \"type\": \"label\", \"defaultValue\": \"3.24\" }\r\n    },\r\n    {\r\n      \"id\": \"C1\",\r\n      \"label\": \"C1\",\r\n      \"GSM\": { \"id\": \"GSM\", \"type\": \"input\", \"name\": \"GSM\", \"defaultValue\": \"120\", \"required\": true },\r\n      \"BF\": { \"id\": \"BF\", \"type\": \"input\", \"name\": \"BF\", \"defaultValue\": \"18\", \"required\": true },\r\n      \"Color\": { \r\n        \"id\": \"Color\", \r\n        \"type\": \"select\", \r\n        \"label\": \"Color\", \r\n        \"name\": \"Color\", \r\n        \"defaultValue\": \"2\", \r\n        \"options\": \"colorOptions\", \r\n        \"required\": true \r\n      },\r\n      \"FluteType\": { \"id\": \"FluteType\", \"type\": \"input\", \"name\": \"FluteType\", \"defaultValue\": \"B\", \"required\": true },\r\n      \"FluteRatio\": { \"id\": \"FluteRatio\", \"type\": \"label\", \"defaultValue\": \"1.5\" },\r\n      \"WeightInKg\": { \"id\": \"WeightInKg\", \"type\": \"label\", \"defaultValue\": \"0.102528\" },\r\n      \"BurstingStrength\": { \"id\": \"BurstingStrength\", \"type\": \"label\", \"defaultValue\": \"1.08\" }\r\n    },\r\n    {\r\n      \"id\": \"L1\",\r\n      \"label\": \"L1\",\r\n      \"GSM\": { \"id\": \"GSM\", \"type\": \"input\", \"name\": \"GSM\", \"defaultValue\": \"180\", \"required\": true },\r\n      \"BF\": { \"id\": \"BF\", \"type\": \"input\", \"name\": \"BF\", \"defaultValue\": \"18\", \"required\": true },\r\n      \"Color\": { \r\n        \"id\": \"Color\", \r\n        \"type\": \"select\", \r\n        \"label\": \"Color\", \r\n        \"name\": \"Color\", \r\n        \"defaultValue\": \"1\", \r\n        \"options\": \"colorOptions\", \r\n        \"required\": true \r\n      },\r\n      \"FluteType\": { \"id\": \"FluteType\", \"type\": \"label\", \"defaultValue\": \"-\" },\r\n      \"FluteRatio\": { \"id\": \"FluteRatio\", \"type\": \"label\", \"defaultValue\": \"1\" },\r\n      \"WeightInKg\": { \"id\": \"WeightInKg\", \"type\": \"label\", \"defaultValue\": \"0.102528\" },\r\n      \"BurstingStrength\": { \"id\": \"BurstingStrength\", \"type\": \"label\", \"defaultValue\": \"3.24\" }\r\n    }\r\n  ]\r\n}\r\n\r\n',	'corrugated_sheet',	NULL,	1,	'static',	'2025-02-20 10:33:41',	'2025-02-20 10:33:41',	'active');

DROP TABLE IF EXISTS `form_fields_group`;
CREATE TABLE `form_fields_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_id` int unsigned NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `form_id` (`form_id`),
  CONSTRAINT `form_fields_group_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `form_fields_group_ibfk_3` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `form_fields_group` (`id`, `company_id`, `form_id`, `group_name`, `status`, `created_at`, `updated_at`) VALUES
(1,	1,	1,	'Default SKU Details',	'active',	'2025-02-19 12:09:42',	'2025-02-19 12:09:42'),
(2,	1,	3,	'Client Details',	'active',	'2025-02-19 12:09:44',	'2025-02-19 12:09:44'),
(3,	1,	2,	'Work Orders',	'active',	'2025-02-19 12:09:44',	'2025-02-19 12:09:44'),
(4,	1,	3,	'Other Details',	'active',	'2025-02-19 15:49:54',	'2025-02-19 15:49:54'),
(5,	1,	3,	'Billing Address',	'active',	'2025-02-19 17:31:21',	'2025-02-19 17:31:21'),
(6,	1,	1,	'SKU_Type',	'active',	'2025-02-19 17:42:40',	'2025-02-19 17:42:40'),
(7,	1,	3,	'Shipping Address',	'active',	'2025-02-19 19:10:45',	'2025-02-19 19:10:45'),
(8,	1,	3,	'Contact Persons',	'active',	'2025-02-19 19:50:39',	'2025-02-19 19:50:39'),
(9,	1,	2,	'SKU Details ',	'active',	'2025-02-20 05:57:47',	'2025-02-20 05:57:47'),
(10,	1,	2,	'Order Details  ',	'active',	'2025-02-20 06:36:34',	'2025-02-20 06:36:34');

DROP TABLE IF EXISTS `form_fields_option_value`;
CREATE TABLE `form_fields_option_value` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_field_id` int unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `form_field_id` (`form_field_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `form_fields_option_value_ibfk_1` FOREIGN KEY (`form_field_id`) REFERENCES `form_fields` (`id`),
  CONSTRAINT `form_fields_option_value_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `form_fields_option_value` (`id`, `company_id`, `form_field_id`, `label`, `status`, `created_at`, `updated_at`) VALUES
(1,	1,	1,	'Business',	'active',	'2025-02-19 12:22:54',	'2025-02-19 12:22:54'),
(2,	1,	1,	'Individual',	'active',	'2025-02-19 12:24:08',	'2025-02-19 12:24:08'),
(3,	1,	2,	'SKU 001',	'active',	'2025-02-19 12:47:46',	'2025-02-19 12:47:46'),
(4,	1,	5,	'Mr',	'active',	'2025-02-19 12:54:01',	'2025-02-19 12:54:01'),
(5,	1,	5,	'Mrs',	'active',	'2025-02-19 12:55:03',	'2025-02-19 12:55:03'),
(6,	1,	18,	'INR Indian Rupee',	'active',	'2025-02-19 16:08:44',	'2025-02-19 16:08:44'),
(7,	1,	18,	'US Dollars',	'active',	'2025-02-19 16:13:22',	'2025-02-19 16:13:22'),
(8,	1,	20,	'Due on Receipt',	'active',	'2025-02-19 16:19:54',	'2025-02-19 16:19:54'),
(9,	1,	20,	'Additional payment terms',	'active',	'2025-02-19 16:22:10',	'2025-02-19 16:22:10'),
(10,	1,	22,	'English',	'active',	'2025-02-19 16:30:19',	'2025-02-19 16:30:19'),
(11,	1,	22,	'Tamil',	'active',	'2025-02-19 16:31:00',	'2025-02-19 16:31:00'),
(12,	1,	1,	'05',	'active',	'2025-02-19 16:49:55',	'2025-02-19 16:49:55'),
(14,	1,	2,	'SKU 001',	'active',	'2025-02-19 16:59:17',	'2025-02-19 16:59:17'),
(15,	1,	33,	'Inner',	'active',	'2025-02-19 17:01:31',	'2025-02-19 17:01:31'),
(16,	1,	33,	'Outer',	'active',	'2025-02-19 17:02:14',	'2025-02-19 17:02:14'),
(17,	1,	41,	'Yes',	'active',	'2025-02-19 17:20:03',	'2025-02-19 17:20:03'),
(18,	1,	41,	'No',	'active',	'2025-02-19 17:20:45',	'2025-02-19 17:20:45'),
(21,	1,	56,	'INhouse',	'active',	'2025-02-19 17:53:38',	'2025-02-19 17:53:38'),
(22,	1,	56,	'Outsource',	'active',	'2025-02-19 17:55:37',	'2025-02-19 17:55:37'),
(23,	1,	55,	'Corrugated Sheet',	'active',	'2025-02-19 18:03:35',	'2025-02-19 18:03:35'),
(24,	1,	55,	'Corrugated Box',	'active',	'2025-02-19 18:05:07',	'2025-02-19 18:05:07'),
(25,	1,	55,	'Die Cut Box',	'active',	'2025-02-19 18:06:42',	'2025-02-19 18:06:42'),
(26,	1,	55,	'Custom Items',	'active',	'2025-02-19 18:07:54',	'2025-02-19 18:07:54'),
(27,	1,	55,	'Composite Item',	'active',	'2025-02-19 18:08:52',	'2025-02-19 18:08:52'),
(28,	1,	54,	'India',	'active',	'2025-02-19 18:43:03',	'2025-02-19 18:43:03'),
(29,	1,	54,	'USA',	'active',	'2025-02-19 18:43:42',	'2025-02-19 18:43:42'),
(30,	1,	60,	'Tamil Nadu',	'active',	'2025-02-19 18:54:25',	'2025-02-19 18:54:25'),
(31,	1,	60,	'Kerala',	'active',	'2025-02-19 18:55:14',	'2025-02-19 18:55:14'),
(32,	1,	64,	'India',	'active',	'2025-02-19 19:22:45',	'2025-02-19 19:22:45'),
(34,	1,	64,	'USA',	'active',	'2025-02-19 19:24:07',	'2025-02-19 19:24:07'),
(35,	1,	69,	'Tamil Nadu',	'active',	'2025-02-19 19:33:43',	'2025-02-19 19:33:43'),
(36,	1,	69,	'Kerala',	'active',	'2025-02-19 19:34:09',	'2025-02-19 19:34:09'),
(37,	1,	6,	'Preview Of SKU Version',	'active',	'2025-02-20 03:53:29',	'2025-02-20 03:53:29'),
(38,	1,	56,	'Purchase Order',	'active',	'2025-02-20 05:32:13',	'2025-02-20 05:32:13'),
(39,	1,	21,	'Allow portal access for this customer',	'active',	'2025-02-20 05:49:39',	'2025-02-20 05:49:39'),
(40,	1,	80,	'SKU 001',	'active',	'2025-02-20 06:03:08',	'2025-02-20 06:03:08'),
(41,	1,	91,	' + Create New Client',	'active',	'2025-02-20 06:43:57',	'2025-02-20 06:43:57'),
(42,	1,	92,	'To-Pay',	'active',	'2025-02-20 06:47:35',	'2025-02-20 06:47:35'),
(43,	1,	94,	'Email',	'active',	'2025-02-20 06:53:04',	'2025-02-20 06:53:04'),
(44,	1,	94,	'Oral',	'active',	'2025-02-20 06:53:46',	'2025-02-20 06:53:46');

DROP TABLE IF EXISTS `form_submission_values`;
CREATE TABLE `form_submission_values` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `submission_id` int unsigned NOT NULL,
  `field_id` int unsigned NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `submission_id` (`submission_id`),
  KEY `field_id` (`field_id`),
  CONSTRAINT `form_submission_values_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `form_submission_values_ibfk_2` FOREIGN KEY (`submission_id`) REFERENCES `form_submissions` (`id`),
  CONSTRAINT `form_submission_values_ibfk_3` FOREIGN KEY (`field_id`) REFERENCES `form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `form_submissions`;
CREATE TABLE `form_submissions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_id` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `form_id` (`form_id`),
  CONSTRAINT `form_submissions_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `form_submissions_ibfk_2` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `form_submissions_export`;
CREATE TABLE `form_submissions_export` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_field_id` int unsigned NOT NULL,
  `form_submissions_order` int NOT NULL DEFAULT '1',
  `status` enum('active','inactive') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `form_field_id` (`form_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `form_submissions_view`;
CREATE TABLE `form_submissions_view` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `form_field_id` int unsigned NOT NULL,
  `form_submissions_order` int NOT NULL DEFAULT '1',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `form_field_id` (`form_field_id`),
  CONSTRAINT `form_submissions_view_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `form_submissions_view_ibfk_2` FOREIGN KEY (`form_field_id`) REFERENCES `form_fields` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `sub_module_id` int unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `sub_module_id` (`sub_module_id`),
  CONSTRAINT `forms_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `forms_ibfk_2` FOREIGN KEY (`sub_module_id`) REFERENCES `sub_modules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `forms` (`id`, `company_id`, `sub_module_id`, `name`, `description`, `config`, `created_at`, `updated_at`) VALUES
(1,	1,	11,	'Add New SKU Details',	'Add New SKU Details',	NULL,	'2025-02-19 11:34:23',	'2025-02-19 11:34:23'),
(2,	1,	9,	'Add Sales Order',	'Add Sales Order',	NULL,	'2025-02-19 12:05:11',	'2025-02-19 12:05:11'),
(3,	1,	12,	'Add New Client Details',	'Add New Client Details',	'{\r\n    \"pagination\": \"yes\",\r\n    \"pagePerItem\": \"10\"\r\n}',	'2025-02-19 12:05:14',	'2025-02-19 12:05:14');

DROP TABLE IF EXISTS `input_types`;
CREATE TABLE `input_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `input_types_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `input_types` (`id`, `company_id`, `type`, `status`, `created_at`) VALUES
(1,	1,	'text',	'active',	'2025-02-13 05:17:44'),
(2,	1,	'password',	'active',	'2025-02-13 05:17:44'),
(3,	1,	'email',	'active',	'2025-02-13 05:17:44'),
(4,	1,	'number',	'active',	'2025-02-13 05:17:44'),
(5,	1,	'tel',	'active',	'2025-02-13 05:17:44'),
(6,	1,	'url',	'active',	'2025-02-13 05:17:44'),
(7,	1,	'search',	'active',	'2025-02-13 05:17:44'),
(8,	1,	'date',	'active',	'2025-02-13 05:17:44'),
(9,	1,	'time',	'active',	'2025-02-13 05:17:44'),
(10,	1,	'datetime-local',	'active',	'2025-02-13 05:17:44'),
(11,	1,	'month',	'active',	'2025-02-13 05:17:44'),
(12,	1,	'week',	'active',	'2025-02-13 05:17:44'),
(13,	1,	'checkbox',	'active',	'2025-02-13 05:17:44'),
(14,	1,	'radio',	'active',	'2025-02-13 05:17:44'),
(15,	1,	'select',	'active',	'2025-02-13 05:17:44'),
(16,	1,	'file',	'active',	'2025-02-13 05:17:44'),
(17,	1,	'color',	'active',	'2025-02-13 05:17:44'),
(18,	1,	'range',	'active',	'2025-02-13 05:17:44'),
(19,	1,	'hidden',	'active',	'2025-02-13 05:17:44'),
(20,	1,	'button',	'active',	'2025-02-13 05:17:44'),
(21,	1,	'submit',	'active',	'2025-02-13 05:17:44'),
(22,	1,	'reset',	'active',	'2025-02-13 05:17:44'),
(24,	1,	'toggle',	'active',	'2025-02-19 17:11:54'),
(25,	1,	'table',	'active',	'2025-02-19 17:56:55'),
(26,	1,	'label',	'active',	'2025-02-20 04:22:41');

DROP TABLE IF EXISTS `module_groups`;
CREATE TABLE `module_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `module_groups_order` int NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_name` (`group_name`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `module_groups_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `module_groups_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `module_groups` (`id`, `group_name`, `status`, `module_groups_order`, `created_at`, `updated_at`, `company_id`) VALUES
(1,	'HRMS',	'active',	1,	'2025-02-13 18:00:37',	NULL,	1),
(2,	'SKU',	'active',	1,	'2025-02-19 11:32:05',	NULL,	1),
(3,	'Add Sales Order',	'active',	1,	'2025-02-19 11:32:58',	NULL,	1),
(4,	'Client Details',	'active',	1,	'2025-02-19 11:33:00',	NULL,	1);

DROP TABLE IF EXISTS `module_icons`;
CREATE TABLE `module_icons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `icon_name` varchar(255) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `icon_name` (`icon_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `module_icons` (`id`, `icon_name`, `status`) VALUES
(1,	'cilHome',	'active'),
(2,	'cilUser',	'active'),
(3,	'cilSettings',	'active'),
(4,	'cilBell',	'active'),
(5,	'cilEnvelope',	'active'),
(6,	'cilCalculator',	'active'),
(7,	'cilArrowLeft',	'active'),
(8,	'cilArrowRight',	'active'),
(9,	'cilChevronCircleDown',	'inactive'),
(10,	'cilPlus',	'active'),
(11,	'cilMinus',	'active'),
(12,	'cilTrash',	'inactive'),
(13,	'cilSave',	'active'),
(14,	'cilCheckCircle',	'active'),
(15,	'cilVideo',	'active'),
(16,	'cilMusicNote',	'active'),
(17,	'cilFolderOpen',	'inactive'),
(18,	'cilCloudDownload',	'active'),
(19,	'cilFile',	'active'),
(20,	'cilCart',	'active'),
(21,	'cilCreditCard',	'inactive'),
(22,	'cilDollar',	'active');

DROP TABLE IF EXISTS `modules`;
CREATE TABLE `modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_group_id` int DEFAULT NULL,
  `module_icon_id` int DEFAULT NULL,
  `key` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `module_order` int NOT NULL DEFAULT '1',
  `company_id` int DEFAULT NULL,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_group_id` (`module_group_id`),
  KEY `module_icon_id` (`module_icon_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `modules_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `modules_ibfk_2` FOREIGN KEY (`module_group_id`) REFERENCES `module_groups` (`id`),
  CONSTRAINT `modules_ibfk_3` FOREIGN KEY (`module_icon_id`) REFERENCES `module_icons` (`id`),
  CONSTRAINT `modules_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `modules` (`id`, `module_name`, `description`, `module_group_id`, `module_icon_id`, `key`, `module_order`, `company_id`, `status`, `created_at`, `updated_at`) VALUES
(1,	'Employee',	NULL,	1,	1,	'view_employee',	1,	1,	'active',	'2025-02-13 23:47:00',	NULL),
(2,	'Attendance',	NULL,	1,	2,	'view_attendance',	1,	1,	'active',	'2025-02-13 23:47:00',	NULL),
(3,	'SKU',	'SKU',	2,	1,	'sku',	1,	1,	'active',	'2025-02-19 11:51:07',	'2025-02-19 11:51:07'),
(4,	'Client Details',	'Client Details',	4,	1,	'Client_details',	1,	1,	'active',	'2025-02-19 11:51:10',	'2025-02-19 11:51:10'),
(5,	'Add Sale Order',	'Add Sale Order',	3,	1,	'add_sale_order',	1,	1,	'active',	'2025-02-19 11:51:32',	'2025-02-19 11:51:32');

DROP TABLE IF EXISTS `permission_role`;
CREATE TABLE `permission_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sub_module_id` int NOT NULL,
  `role_id` int unsigned NOT NULL,
  `permission_type_id` bigint unsigned NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`sub_module_id`,`role_id`),
  UNIQUE KEY `id` (`id`),
  KEY `role_id` (`role_id`),
  KEY `permission_type_id` (`permission_type_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `permission_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `permission_role_ibfk_2` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`),
  CONSTRAINT `permission_role_ibfk_3` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `permission_role` (`id`, `sub_module_id`, `role_id`, `permission_type_id`, `company_id`, `created_at`, `updated_at`) VALUES
(1,	1,	1,	4,	1,	'2025-02-14 05:58:47',	NULL),
(2,	2,	1,	4,	1,	'2025-02-14 05:59:05',	NULL),
(3,	3,	1,	4,	1,	'2025-02-14 05:59:19',	NULL),
(4,	4,	1,	4,	1,	'2025-02-14 05:59:37',	NULL),
(5,	5,	1,	4,	1,	'2025-02-20 05:23:20',	'2025-02-20 05:23:20'),
(6,	8,	1,	4,	1,	'2025-02-20 05:24:11',	NULL),
(7,	9,	1,	4,	1,	'2025-02-20 05:24:41',	NULL),
(8,	10,	1,	4,	1,	'2025-02-20 05:24:52',	NULL),
(9,	11,	1,	4,	1,	'2025-02-20 05:25:45',	NULL),
(10,	12,	1,	4,	1,	'2025-02-20 05:26:05',	NULL);

DROP TABLE IF EXISTS `permission_types`;
CREATE TABLE `permission_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `permission_types_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `permission_types` (`id`, `name`, `company_id`, `created_at`, `updated_at`) VALUES
(1,	'added',	1,	NULL,	NULL),
(2,	'owned',	1,	NULL,	NULL),
(3,	'both',	1,	NULL,	NULL),
(4,	'all',	1,	NULL,	NULL),
(5,	'none',	1,	NULL,	NULL);

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_id` int unsigned NOT NULL,
  `is_custom` tinyint(1) NOT NULL DEFAULT '0',
  `company_id` int NOT NULL,
  `allowed_permissions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_module_id_unique` (`name`,`module_id`),
  KEY `permissions_module_id_foreign` (`module_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `permissions_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `permissions_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `permissions_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `user_id` int NOT NULL,
  `role_id` int unsigned NOT NULL,
  `created_at` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  UNIQUE KEY `id` (`id`),
  KEY `company_id` (`company_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_user_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `role_user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `role_user_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `role_user` (`id`, `company_id`, `user_id`, `role_id`, `created_at`, `updated_at`) VALUES
(1,	1,	2,	1,	'2025-02-17 12:35:37',	NULL),
(2,	1,	2,	2,	'2025-02-17 12:35:56',	NULL);

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_company_id_unique` (`name`,`company_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `roles` (`id`, `company_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1,	1,	'admin',	'App Administrator',	'Admin is allowed to manage everything of the app.',	'2025-02-14 02:21:09',	NULL),
(2,	1,	'employee',	'Employee',	'Employee can see tasks and projects assigned to him',	'2025-02-14 02:21:40',	NULL),
(3,	1,	'client',	'Client',	'Client can see own tasks and projects.',	'2025-02-14 02:22:05',	NULL);

DROP TABLE IF EXISTS `sub_modules`;
CREATE TABLE `sub_modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `sub_module_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_icon_id` int DEFAULT NULL,
  `key` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sub_modules_order` int NOT NULL DEFAULT '1',
  `form_type` enum('add','view','update','delete') COLLATE utf8mb4_unicode_ci NOT NULL,
  `module_id` int unsigned DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  `is_custom` int NOT NULL DEFAULT '0',
  `allowed_permissions` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `module_icon_id` (`module_icon_id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `sub_modules_ibfk_1` FOREIGN KEY (`module_icon_id`) REFERENCES `module_icons` (`id`),
  CONSTRAINT `sub_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `sub_modules_ibfk_3` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `sub_modules` (`id`, `sub_module_name`, `description`, `module_icon_id`, `key`, `sub_modules_order`, `form_type`, `module_id`, `company_id`, `is_custom`, `allowed_permissions`, `status`, `created_at`, `updated_at`) VALUES
(1,	'Add Employee',	'Add Employee',	3,	'add_employee',	1,	'add',	1,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-13 23:52:00',	NULL),
(2,	'View Employee',	'View Employee',	4,	'view_employee',	1,	'view',	1,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-13 23:52:00',	NULL),
(3,	'Add Attendance ',	'Add Attendance ',	5,	'add_attendance',	1,	'add',	2,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-13 23:52:00',	NULL),
(4,	'View Attendance ',	'View Attendance ',	6,	'view_attendance',	1,	'view',	2,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-13 23:52:00',	NULL),
(5,	'View SKU',	'View SKU',	1,	'view_sku',	1,	'view',	3,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:46:20',	'2025-02-19 11:46:20'),
(8,	'View Sale Order',	'View Sale Order',	1,	'view _sale_ order',	1,	'view',	5,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:57:07',	'2025-02-19 11:57:07'),
(9,	'Add Sale Order',	'Add Sale Order',	1,	'add_sale_order',	1,	'add',	5,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:59:18',	'2025-02-19 11:59:18'),
(10,	'View Client Details',	'View Client Details',	1,	'view_client_details',	1,	'view',	4,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:54:20',	'2025-02-19 11:54:20'),
(11,	'Add New SKU',	'Add New SKU',	1,	'add_new_sku',	1,	'add',	3,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:55:45',	'2025-02-19 11:55:45'),
(12,	'Add Client Details',	'Add Client Details',	1,	'add_client_details',	1,	'add',	4,	1,	0,	'{\"all\":4, \"added\":1, \"owned\":2,\"both\":3, \"none\":5}',	'active',	'2025-02-19 11:56:04',	'2025-02-19 11:56:04');

DROP TABLE IF EXISTS `user_permissions`;
CREATE TABLE `user_permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sub_module_id` int unsigned NOT NULL,
  `user_id` int NOT NULL,
  `permission_type_id` bigint unsigned NOT NULL,
  `company_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `permission_type_id` (`permission_type_id`),
  KEY `company_id` (`company_id`),
  KEY `sub_module_id` (`sub_module_id`),
  CONSTRAINT `user_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_permissions_ibfk_3` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`),
  CONSTRAINT `user_permissions_ibfk_4` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `user_permissions_ibfk_5` FOREIGN KEY (`sub_module_id`) REFERENCES `sub_modules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user_permissions` (`id`, `sub_module_id`, `user_id`, `permission_type_id`, `company_id`, `created_at`, `updated_at`) VALUES
(1,	1,	1,	4,	1,	NULL,	NULL),
(2,	2,	1,	4,	1,	NULL,	NULL),
(3,	3,	1,	4,	1,	NULL,	NULL),
(4,	4,	1,	4,	1,	NULL,	NULL),
(5,	4,	1,	4,	1,	NULL,	NULL);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updatedAt` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phoneNumber` (`phoneNumber`),
  KEY `idx_users_email` (`email`),
  KEY `idx_users_phoneNumber` (`phoneNumber`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_company_id` (`company_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `users` (`id`, `company_id`, `name`, `email`, `password`, `phoneNumber`, `role`, `status`, `login`, `email_notifications`, `customized_permissions`, `last_login`, `gender`, `dob`, `address`, `city`, `state`, `country`, `zip`, `countryCode`, `image`, `createdAt`, `updatedAt`) VALUES
(1,	NULL,	'Kathick',	'ananda.s@pazl.info',	'$2b$10$S3VzRzWAetvQifzSHrMB3OTrY25Vn2zUnVzyiS6lMiZiSyf4uGFEu',	NULL,	'',	'active',	'enable',	'enable',	'enable',	NULL,	'male',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2025-02-03 18:46:55',	'2025-02-03 18:46:55'),
(2,	1,	'Ananda Kathick',	'anandas.s@pazl.info',	'$2b$10$yxRXIDHw2O.wEmjBXu1GJuhSmN9lhUDTxSM9vIdQEKP3vDUeOLgBK',	NULL,	'',	'active',	'enable',	'enable',	'disable',	NULL,	'male',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2025-02-03 18:47:52',	'2025-02-03 18:47:52');

-- 2025-02-20 17:36:19
