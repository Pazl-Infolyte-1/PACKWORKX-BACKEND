
ALTER TABLE `companies`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `email_notifications`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `form_fields`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `form_fields_group`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `form_fields_option_value`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `form_submission_values`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `form_submissions`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `form_submissions_export`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `form_submissions_view`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `forms`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `input_types`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `created_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `module_groups`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `module_icons`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `status`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `modules`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `permission_role`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `permission_types`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `permissions`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `role_user`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `roles`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `sub_modules`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

ALTER TABLE `user_permissions`
ADD `created_by` int NOT NULL DEFAULT '1' AFTER `updated_at`,
ADD `updated_by` int NOT NULL DEFAULT '1' AFTER `created_by`,
ADD FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
ADD FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);


ALTER TABLE `sub_modules`
CHANGE `form_type` `form_type` enum('add','view','get','update','delete','other') COLLATE 'utf8mb4_unicode_ci' NOT NULL AFTER `sub_modules_order`;