/**
 * @swagger
 * /api/user/login:
 *   post:
 *     summary: Login user and generate a JWT token
 *     description: This endpoint authenticates a user and generates a JWT token for authorized access.
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - userName
 *               - password
 *             properties:
 *               userName:
 *                 type: string
 *                 description: The user's email address.
 *                 example: user@example.com
 *               password:
 *                 type: string
 *                 description: The user's password.
 *                 example: Password123
 *     responses:
 *       200:
 *         description: Login successful, JWT token generated
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Login successful
 *                 data:
 *                   type: object
 *                   properties:
 *                     token:
 *                       type: string
 *                       description: JWT token generated for the authenticated user
 *                       example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjEyMzQ1NjA1fQ.E0xWyR9TRzyyz1pL9bgpWQ"
 *       400:
 *         description: Invalid credentials or validation error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Invalid credentials
 *                 data:
 *                   type: array
 *                   items:
 *                     type: string
 *                   example: []
 *       500:
 *         description: Internal Server Error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: Internal Server Error
 *                 error:
 *                   type: string
 *                   example: Some error message
 *                 filePath:
 *                   type: string
 *                   example: /path/to/file.ts
 *                 lineNumber:
 *                   type: string
 *                   example: "line 42"
 */

/**
 * @swagger
 * tags:
 *   - name: Users
 *     description: API for managing users
 */

/**
 * @swagger
 * /api/user/register:
 *   post:
 *     summary: Create a new user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - password
 *               - company_id
 *             properties:
 *               name:
 *                 type: string
 *                 minLength: 2
 *                 maxLength: 255
 *                 example: "John Doe"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "john.doe@example.com"
 *               password:
 *                 type: string
 *                 minLength: 6
 *                 maxLength: 128
 *                 example: "password123"
 *               company_id:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: User registered successfully
 *       400:
 *         description: Validation error or email already exists
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: User fetched successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user:
 *   get:
 *     summary: Get all users
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: Users fetched successfully
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   put:
 *     summary: Update user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Updated Name"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "updated@example.com"
 *     responses:
 *       200:
 *         description: User updated successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/user/{id}:
 *   delete:
 *     summary: Delete user by ID
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: User deactivated successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */


/**
 * @swagger
 * tags:
 *   name: Company
 *   description: API for managing companies
 */

/**
 * @swagger
 * /api/company:
 *   post:
 *     summary: Create a new company
 *     tags: [Company]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, email]
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Tech Solutions"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "contact@techsolutions.com"
 *               address:
 *                 type: string
 *                 example: "123 Business Street, NY"
 *     responses:
 *       200:
 *         description: Company created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "New company created successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       example: 1
 *                     name:
 *                       type: string
 *                       example: "Tech Solutions"
 *                     email:
 *                       type: string
 *                       format: email
 *                       example: "contact@techsolutions.com"
 *                     address:
 *                       type: string
 *                       example: "123 Business Street, NY"
 *       400:
 *         description: Validation errors or duplicate company
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /company/{id}:
 *   get:
 *     summary: Get a company by ID
 *     tags: [Company]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: Company details retrieved successfully
 *       404:
 *         description: Company not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/company:
 *   get:
 *     summary: Get all companies
 *     tags: [Company]
 *     responses:
 *       200:
 *         description: List of companies retrieved successfully
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/company/{id}:
 *   put:
 *     summary: Update a company by ID
 *     tags: [Company]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Updated Tech Solutions"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "newcontact@techsolutions.com"
 *               address:
 *                 type: string
 *                 example: "456 Updated Street, NY"
 *     responses:
 *       200:
 *         description: Company updated successfully
 *       404:
 *         description: Company not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/company/{id}:
 *   delete:
 *     summary: Delete a company by ID
 *     tags: [Company]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: Company deleted successfully
 *       404:
 *         description: Company not found
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * tags:
 *   name: Modules
 *   description: API for managing modules
 */

/**
 * @swagger
 * /api/modules:
 *   post:
 *     summary: Create a new module
 *     tags: [Modules]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               moduleName:
 *                 type: string
 *                 example: "User Management"
 *               description:
 *                 type: string
 *                 example: "Handles user roles and permissions"
 *               icon:
 *                 type: string
 *                 example: "user-icon.png"
 *               parentId:
 *                 type: integer
 *                 example: 1
 *               companyId:
 *                 type: integer
 *                 example: 101
 *     responses:
 *       201:
 *         description: Module created successfully
 *       400:
 *         description: Validation error or duplicate module name
 */
/**
             * @swagger
             * /api/modules:
             *   get:
             *     summary: Get all modules
             *     tags: [Modules]
             *     responses:
             *       200:
             *         description: List of modules retrieved successfully
             */
/**
 * @swagger
 * /api/module/{id}:
 *   get:
 *     summary: Get Module by ID
 *     tags: [Modules]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         example: 1
 *     responses:
 *       200:
 *         description: Module fetched successfully
 *       404:
 *         description: Module not found
 *       500:
 *         description: Internal server error
 */


             /**
             * @swagger
             * /api/modules/{id}:
             *   put:
             *     summary: Update a module
             *     tags: [Modules]
             *     parameters:
             *       - in: path
             *         name: id
             *         schema:
             *           type: integer
             *         required: true
             *         description: Module ID
             *     requestBody:
             *       required: true
             *       content:
             *         application/json:
             *           schema:
             *             type: object
             *             properties:
             *               moduleName:
             *                 type: string
             *               description:
             *                 type: string
             *               icon:
             *                 type: string
             *               parentId:
             *                 type: integer
             *               companyId:
             *                 type: integer
             *     responses:
             *       200:
             *         description: Module updated successfully
             *       404:
             *         description: Module not found
             */
             /**
             * @swagger
             * /api/modules/{id}:
             *   delete:
             *     summary: Delete a module
             *     tags: [Modules]
             *     parameters:
             *       - in: path
             *         name: id
             *         schema:
             *           type: integer
             *         required: true
             *         description: Module ID
             *     responses:
             *       200:
             *         description: Module deleted successfully
             *       404:
             *         description: Module not found
             */


             /**
 * @swagger
 * tags:
 *   name: SubModules
 *   description: API for managing sub-modules
 */

/**
 * @swagger
 * /api/submodules:
 *   post:
 *     summary: Create a new sub-module
 *     tags: [SubModules]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [subModuleName, description, icon, companyId]
 *             properties:
 *               subModuleName:
 *                 type: string
 *                 minLength: 2
 *                 maxLength: 255
 *                 example: "User Management"
 *               description:
 *                 type: string
 *                 minLength: 2
 *                 maxLength: 255
 *                 example: "Manages user roles"
 *               icon:
 *                 type: string
 *                 example: "user-icon.png"
 *               module_id:
 *                 type: integer
 *                 nullable: true
 *                 example: 1
 *               is_custom:
 *                 type: boolean
 *                 nullable: true
 *               companyId:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       201:
 *         description: SubModule created successfully
 *       400:
 *         description: Validation failed or Sub Module Name already exists
 */

/**
 * @swagger
 * /api/submodules:
 *   get:
 *     summary: Get all sub-modules
 *     tags: [SubModules]
 *     responses:
 *       200:
 *         description: List of sub-modules
 *       500:
 *         description: Internal server error
 */

/**
 * @swagger
 * /api/submodules/{id}:
 *   get:
 *     summary: Get a single sub-module by ID
 *     tags: [SubModules]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: SubModule details
 *       404:
 *         description: SubModule not found
 */

/**
 * @swagger
 * /api/submodules/{id}:
 *   put:
 *     summary: Update a sub-module
 *     tags: [SubModules]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               subModuleName:
 *                 type: string
 *                 example: "Updated Name"
 *               description:
 *                 type: string
 *                 example: "Updated description"
 *               icon:
 *                 type: string
 *                 example: "updated-icon.png"
 *               module_id:
 *                 type: integer
 *                 example: 1
 *               is_custom:
 *                 type: boolean
 *               companyId:
 *                 type: integer
 *                 example: 1
 *     responses:
 *       200:
 *         description: SubModule updated successfully
 *       404:
 *         description: SubModule not found
 */

/**
 * @swagger
 * /api/api/submodules/{id}:
 *   delete:
 *     summary: Delete a sub-module
 *     tags: [SubModules]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: SubModule deleted successfully
 *       404:
 *         description: SubModule not found
 */
/**
 * @swagger
 * tags:
 *   name: Module Groups
 *   description: API for managing module groups
 */

/**
 * @swagger
 * /api/module-groups:
 *   post:
 *     summary: Create a new Module Group
 *     tags: [Module Groups]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ModuleGroup'
 *     responses:
 *       201:
 *         description: Module Group created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/ModuleGroup'
 *       400:
 *         description: Validation error or duplicate module group name
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /api/module-groups:
 *   get:
 *     summary: Get all Module Groups
 *     tags: [Module Groups]
 *     responses:
 *       200:
 *         description: List of all module groups
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/ModuleGroup'
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /api/module-groups/{id}:
 *   get:
 *     summary: Get a single Module Group by ID
 *     tags: [Module Groups]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the module group
 *     responses:
 *       200:
 *         description: Module Group fetched successfully
 *       404:
 *         description: Module Group not found
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /api/module-groups/{id}:
 *   put:
 *     summary: Update a Module Group by ID
 *     tags: [Module Groups]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the module group
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ModuleGroup'
 *     responses:
 *       200:
 *         description: Module Group updated successfully
 *       404:
 *         description: Module Group not found
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /api/module-groups/{id}:
 *   delete:
 *     summary: Delete a Module Group by ID
 *     tags: [Module Groups]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID of the module group
 *     responses:
 *       200:
 *         description: Module Group deleted successfully
 *       404:
 *         description: Module Group not found
 *       500:
 *         description: Internal Server Error
 */

/**
 * @swagger
 * /api/rbac:
 *   get:
 *     summary: Retrieve Role-Based Access Control Data
 *     description: >
 *       Returns RBAC data for the authenticated user based on their user ID and associated company.
 *       The data is structured into groups with nested modules and sub-modules.
 *     tags:
 *       - RBAC
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved RBAC data.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Role-Based Access Control Data"
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       groupName:
 *                         type: string
 *                         example: "HRMS"
 *                       modules:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             moduleName:
 *                               type: string
 *                               example: "Employee"
 *                             moduleKey:
 *                               type: string
 *                               example: "dmlld19lbXBsb3llZQ=="
 *                             moduleIconName:
 *                               type: string
 *                               example: "cilHome"
 *                             subModules:
 *                               type: array
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   subModuleName:
 *                                     type: string
 *                                     example: "Add Employee"
 *                                   subModuleKey:
 *                                     type: string
 *                                     example: "YWRkX2VtcGxveWVl"
 *                                   subModuleIconName:
 *                                     type: string
 *                                     example: "cilSettings"
 *       400:
 *         description: Bad Request - Missing User ID or Company ID.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "User ID or Company ID is missing"
 *       404:
 *         description: User not found.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "User not found"
 *       500:
 *         description: Internal Server Error.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Internal Server Error"
 *                 error:
 *                   type: string
 *                   example: "Error message details"
 */

/**
 * @swagger
 * /api/form-fields/{id}:
 *   get:
 *     summary: Retrieve Form Fields for a SubModule
 *     description: Fetches dynamic form fields structure for a given sub-module based on the provided ID.
 *     tags:
 *       - Form Fields
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Encoded ID of the sub-module.
 *     responses:
 *       200:
 *         description: Successfully retrieved form fields.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   type: object
 *                   properties:
 *                     pageTitle:
 *                       type: string
 *                     formId:
 *                       type: string
 *                     sections:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           groupName:
 *                             type: string
 *                           groupId:
 *                             type: string
 *                           groupShow:
 *                             type: boolean
 *                           count:
 *                             type: integer
 *                           inputs:
 *                             type: array
 *                             items:
 *                               type: object
 *                               properties:
 *                                 id:
 *                                   type: string
 *                                 formKey:
 *                                   type: string
 *                                 type:
 *                                   type: string
 *                                 label:
 *                                   type: string
 *                                 placeholder:
 *                                   type: string
 *                                 required:
 *                                   type: boolean
 *                                 name:
 *                                   type: string
 *                                 defaultValue:
 *                                   type: string
 *                                 options:
 *                                   type: array
 *                                   items:
 *                                     type: object
 *                                     properties:
 *                                       id:
 *                                         type: string
 *                                       label:
 *                                         type: string
 *       400:
 *         description: Bad Request - Missing required parameters.
 *       404:
 *         description: SubModule or form structure not found.
 *       500:
 *         description: Internal Server Error.
 */

/**
 * @swagger
 * /api/form-fields-submission:
 *   post:
 *     summary: Submit Form Data
 *     description: Submits form data with form_id and field values.
 *     tags:
 *       - Form Fields
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               form_id:
 *                 type: integer
 *               fields:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     field_id:
 *                       type: integer
 *                     value:
 *                       type: string
 *     responses:
 *       200:
 *         description: Form submitted successfully.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 submission_id:
 *                   type: integer
 *       400:
 *         description: Invalid form data.
 *       404:
 *         description: Form ID not found.
 *       500:
 *         description: Internal Server Error.
 */
