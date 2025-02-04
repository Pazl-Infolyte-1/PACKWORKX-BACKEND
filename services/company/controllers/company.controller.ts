import { Request, Response, NextFunction } from "express";
import { AppDataSource } from '../../../config/data-source'; // Adjust path as necessary
import { Company } from './../models/company.model'; // Adjust path as necessary
import Joi from "joi";



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

export const company = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const companyRepository = AppDataSource.getRepository(Company);

        switch (req.method) {
            case 'POST': {
                const companySchema = Joi.object({
                    name: Joi.string().min(2).max(255).required().messages({
                        "string.empty": "Company name is required",
                        "string.min": "Company name must be at least 2 characters",
                        "string.max": "Company name cannot exceed 255 characters",
                    }),
                    email: Joi.string().email().required().messages({
                        "string.empty": "Email is required",
                        "string.email": "Invalid email format",
                    }),
                    address: Joi.string().max(255).optional().messages({
                        "string.max": "Address cannot exceed 255 characters",
                    }),
                });
                const { error } = companySchema.validate(req.body, { abortEarly: false });
                if (error) {
                    res.status(400).json({
                        status: false,
                        message: "Validation failed",
                        errors: error.details.map((err) => err.message),
                    });
                    return;
                }
                // Check if the company name already exists
                const existingCompany = await companyRepository.findOne({ where: { name: req.body.name } });
                if (existingCompany) {
                    res.status(400).json({
                        status: true,
                        message: 'Company already exists',
                        data: [],
                    });
                    return;
                }

                // Create and save the new company
                const newCompany = companyRepository.create(req.body);
                await companyRepository.save(newCompany);
                res.status(200).json({
                    status: true,
                    message: 'New company created successfully',
                    data: newCompany,  // ✅ Corrected: Sending an array instead of an undefined `item`
                });

                break;
            }

            case 'GET': {
                if (req.params.id) {
                    // Fetch a single company by ID
                    const company = await companyRepository.findOneBy({ id: Number(req.params.id) });
                    if (!company) {
                        res.status(404).json({
                            status: true,
                            message: 'Company not found',
                            data: [],
                        });
                        return;
                    }
                    res.status(200).json({
                        status: true,
                        message: 'company fetch successfully',
                        data: company,  // ✅ Corrected: Sending an array instead of an undefined `item`
                    });
                } else {
                    // Fetch all companies from the database
                    const companies = await companyRepository.find();
                    res.status(200).json({
                        status: true,
                        message: 'company fetch successfully',
                        data: companies,  // ✅ Corrected: Sending an array instead of an undefined `item`
                    });
                }
                break;
            }

            case 'PUT': {
                const company = await companyRepository.findOneBy({ id: Number(req.params.id) });
                if (!company) {
                    res.status(404).json({
                        status: true,
                        message: 'Company not found',
                        data: [],
                    });
                    return;
                }

                // Merge and update the company
                companyRepository.merge(company, req.body);
                await companyRepository.save(company);

                res.status(200).json({
                    status: true,
                    message: 'company fetch successfully',
                    data: company,  // ✅ Corrected: Sending an array instead of an undefined `item`
                });
                break;
            }

            case 'DELETE': {
                const company = await companyRepository.findOneBy({ id: Number(req.params.id) });
                if (!company) {
                    res.status(404).json({
                        status: true,
                        message: 'Company not found',
                        data: [],
                    });
                    return;
                }

                // Remove the company
                await companyRepository.remove(company);
                res.status(200).json({
                    status: true,
                    message: 'Company deleted successfully',
                    data: [],
                });

                break;
            }

            default:
                res.status(405).json({
                    status: true,
                    message: 'Method not allowed',
                    data: [],
                });
                break;
        }
    } catch (error) {
        const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

        res.status(500).json({
            status: false,
            message: "Internal Server Error",
            error: error instanceof Error ? error.message : "Unknown error",
            filePath: __filename, // Gets current file path
            lineNumber: stackTrace, // Extracts line number from stack trace
        });
    }
};
