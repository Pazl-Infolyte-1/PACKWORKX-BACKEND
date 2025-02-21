import { Request, Response, NextFunction } from "express";
import { AppDataSource } from "../../../config/data-source";
import { User } from "../../user/models/user.model";
import { Buffer } from "buffer";
import { Module } from "../../module/models/module.model";
import { SubModule } from "../../module/models/sub_module.model";
import { FormSubmission } from "../models/formsubmission.model";
import { FormSubmissionValue } from "../models/formSubmissionValue.model";
import { FormField } from "../models/formField.ts.model";
import { Form } from "../models/forms.model";

interface CustomRequest extends Request {
    user?: {
        id: number;
        company?: {
            id: number;
            name: string;
        };
    };
}

export const formFields = async (req: Request, res: Response, next: NextFunction): Promise<void> => {

    try {
        const customReq = req as CustomRequest;
        const userId: number | undefined = customReq?.user?.id;
        const companyId: number | undefined = customReq?.user?.company?.id;

        if (!userId || !companyId) {
            res.status(400).json({
                status: false,
                message: "User ID or Company ID is missing",
            });
            return;
        }

        const UserRepository = AppDataSource.getRepository(User);
        const userDetails = await UserRepository.findOneBy({ id: userId });

        if (!userDetails) {
            res.status(404).json({
                status: false,
                message: "User not found",
            });
            return;
        }

        const id = req.params.id;
        switch (req.method) {
            case 'GET': {
                try {
                    const submoduleRepository = AppDataSource.getRepository(SubModule);
                    const moduleRepository = AppDataSource.getRepository(Module);

                    const formKey = Buffer.from(id, "base64").toString("utf-8");

                    const submoduleDetails = await submoduleRepository.findOne({
                        where: { key: formKey, status: 'active' },
                        select: ['form_type', 'id']
                    });

                    if (!submoduleDetails) {
                        res.status(404).json({
                            status: false,
                            message: "SubModule not found",
                        });
                        return;
                    }

                    if (submoduleDetails.form_type === 'add') {
                        // const subModuleId = submoduleDetails.id;
                        const query = `CALL GetFormStructure(?)`;

                        const result = await AppDataSource.manager.query(query, [formKey]);
                        const rawData = result[0] || [];
                        if (rawData.length === 0) {
                            res.status(404).json({
                                status: false,
                                message: "No form structure found",
                            });
                            return;
                        }

                        const pageTitle = rawData[0]?.pageTitle || "Default Title";
                        const formId = rawData[0]?.formId || "Default Form ID";

                        const groupedFields = rawData.reduce((acc: any[], field: any) => {
                            let group = acc.find((g) => g.groupId === field.groupId);

                            if (!group) {
                                group = {
                                    groupName: field.groupName,
                                    groupId: field.groupId,
                                    groupShow: true,
                                    count: 0,
                                    inputs: [],
                                };
                                acc.push(group);
                            }

                            let input = group.inputs.find((i: any) => i.id === field.inputName);

                            if (!input) {
                                input = {
                                    id: field.inputName,
                                    fieldId: field.formKey,
                                    type: field.inputType,
                                    label: field.inputLabel,
                                    placeholder: field.inputPlaceholder,
                                    required: Boolean(field.inputRequired),
                                    name: field.inputName,
                                    defaultValue: field.inputDefaultValue,
                                    options: [],
                                };
                                group.inputs.push(input);
                                group.count++;
                            }

                            if (field.optionId) {
                                input.options.push({
                                    id: field.optionId,
                                    label: field.optionLabel,
                                });
                            }

                            return acc;
                        }, []);

                        res.status(200).json({
                            status: true,
                            message: "Form fields retrieved successfully",
                            data: {
                                pageTitle,
                                formId,
                                sections: groupedFields,
                            },
                        });
                    } else {
                        //VIEW FUNCTION HERE

                    }

                } catch (error) {
                    const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

                    res.status(500).json({
                        status: false,
                        message: "Internal Server Error",
                        error: error instanceof Error ? error.message : "Unknown error",
                        filePath: __filename,
                        lineNumber: stackTrace,
                    });
                }
                break


            }
            case 'POST': {
                try {
                    const formSubmissionRepo = AppDataSource.getRepository(FormSubmission);
                    const submissionValuesRepo = AppDataSource.getRepository(FormSubmissionValue);
                    const formFieldRepo = AppDataSource.getRepository(FormField); // Assuming SubModule stores form fields
                    const formRepo = AppDataSource.getRepository(Form);
                    console.log(req.body);
                    // Get form_id and fields from request body
                    const { form_id, fields } = req.body;

                    if (!form_id || !Array.isArray(fields) || fields.length === 0) {
                        res.status(400).json({
                            status: false,
                            message: "Invalid form data. Please provide form_id and fields.",
                        });
                        return;
                    }

                    // Validate form_id exists
                    const formExists = await formRepo.findOne({ where: { id: form_id } });
                    if (!formExists) {
                        res.status(404).json({
                            status: false,
                            message: `Form ID ${form_id} not found.`,
                        });
                        return;
                    }

                    // Fetch valid field IDs for the given form_id
                    const validFields = await AppDataSource.manager.query(
                        "SELECT id AS field_id FROM form_fields WHERE form_id = ?",
                        [form_id]
                    );

                    const validFieldIds = validFields.map((field: any) => field.field_id);

                    // Validate if all submitted field_ids belong to this form_id
                    for (const field of fields) {
                        if (!validFieldIds.includes(field.field_id)) {
                            res.status(400).json({
                                status: false,
                                message: `Invalid field_id: ${field.field_id} for form_id: ${form_id}`,
                            });
                            return;
                        }
                    }

                    // Create a new form submission entry
                    const newSubmission = formSubmissionRepo.create({
                        company_id: companyId,
                        form_id,
                    });
                    await formSubmissionRepo.save(newSubmission);

                    // Prepare and save form submission values
                    const valuesToSave = fields.map((field: { field_id: number; value: string }) => {
                        return submissionValuesRepo.create({
                            company_id: companyId,
                            submission: newSubmission, // Using relation
                            field_id: field.field_id,
                            value: field.value,
                        });
                    });

                    await submissionValuesRepo.save(valuesToSave);

                    res.json({
                        status: true,
                        message: "Form submitted successfully",
                        submission_id: newSubmission.id,
                    });

                } catch (error) {
                    const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

                    res.status(500).json({
                        status: false,
                        message: "Internal Server Error",
                        error: error instanceof Error ? error.message : "Unknown error",
                        filePath: __filename,
                        lineNumber: stackTrace,
                    });
                }
            }
                break;



            default:
                res.status(405).json({
                    status: false,
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
            filePath: __filename,
            lineNumber: stackTrace,
        });
    }
};


export const formFieldsSubmissionValue = async (req: Request, res: Response, next: NextFunction): Promise<void> => {


    try {
        const customReq = req as CustomRequest;
        const userId: number | undefined = customReq?.user?.id;
        const companyId: number | undefined = customReq?.user?.company?.id;

        if (!userId || !companyId) {
            res.status(400).json({
                status: false,
                message: "User ID or Company ID is missing",
            });
            return;
        }

        const UserRepository = AppDataSource.getRepository(User);
        const userDetails = await UserRepository.findOneBy({ id: userId });

        if (!userDetails) {
            res.status(404).json({
                status: false,
                message: "User not found",
            });
            return;
        }

        const id = req.params.id;
        switch (req.method) {
            case 'GET': {
                try {
                    const submoduleRepository = AppDataSource.getRepository(SubModule);
                    const moduleRepository = AppDataSource.getRepository(Module);

                    const formKey = Buffer.from(id, "base64").toString("utf-8");

                    const submoduleDetails = await submoduleRepository.findOne({
                        where: { key: formKey, status: 'active' },
                        select: ['form_type', 'id']
                    });

                    if (!submoduleDetails) {
                        res.status(404).json({
                            status: false,
                            message: "SubModule not found",
                        });
                        return;
                    }

                    if (submoduleDetails.form_type === 'add') {
                        // const subModuleId = submoduleDetails.id;
                        const query = `CALL GetFormStructure(?)`;

                        const result = await AppDataSource.manager.query(query, [formKey]);
                        const rawData = result[0] || [];
                        if (rawData.length === 0) {
                            res.status(404).json({
                                status: false,
                                message: "No form structure found",
                            });
                            return;
                        }

                        const pageTitle = rawData[0]?.pageTitle || "Default Title";
                        const formId = rawData[0]?.formId || "Default Form ID";

                        const groupedFields = rawData.reduce((acc: any[], field: any) => {
                            let group = acc.find((g) => g.groupId === field.groupId);

                            if (!group) {
                                group = {
                                    groupName: field.groupName,
                                    groupId: field.groupId,
                                    groupShow: true,
                                    count: 0,
                                    inputs: [],
                                };
                                acc.push(group);
                            }

                            let input = group.inputs.find((i: any) => i.id === field.inputName);

                            if (!input) {
                                input = {
                                    id: field.inputName,
                                    fieldId: field.formKey,
                                    type: field.inputType,
                                    label: field.inputLabel,
                                    placeholder: field.inputPlaceholder,
                                    required: Boolean(field.inputRequired),
                                    name: field.inputName,
                                    defaultValue: field.inputDefaultValue,
                                    options: [],
                                };
                                group.inputs.push(input);
                                group.count++;
                            }

                            if (field.optionId) {
                                input.options.push({
                                    id: field.optionId,
                                    label: field.optionLabel,
                                });
                            }

                            return acc;
                        }, []);

                        res.status(200).json({
                            status: true,
                            message: "Form fields retrieved successfully",
                            data: {
                                pageTitle,
                                formId,
                                sections: groupedFields,
                            },
                        });
                    } else {
                        //VIEW FUNCTION HERE

                    }

                } catch (error) {
                    const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

                    res.status(500).json({
                        status: false,
                        message: "Internal Server Error",
                        error: error instanceof Error ? error.message : "Unknown error",
                        filePath: __filename,
                        lineNumber: stackTrace,
                    });
                }
                break


            }
            case 'POST': {
                try {
                    const formSubmissionRepo = AppDataSource.getRepository(FormSubmission);
                    const submissionValuesRepo = AppDataSource.getRepository(FormSubmissionValue);
                    const formFieldRepo = AppDataSource.getRepository(FormField); // Assuming SubModule stores form fields
                    const formRepo = AppDataSource.getRepository(Form);
                    console.log(req.body);
                    // Get form_id and fields from request body
                    const { form_id, fields } = req.body;

                    if (!form_id || !Array.isArray(fields) || fields.length === 0) {
                        res.status(400).json({
                            status: false,
                            message: "Invalid form data. Please provide form_id and fields.",
                        });
                        return;
                    }

                    // Validate form_id exists
                    const formExists = await formRepo.findOne({ where: { id: form_id } });
                    if (!formExists) {
                        res.status(404).json({
                            status: false,
                            message: `Form ID ${form_id} not found.`,
                        });
                        return;
                    }

                    // Fetch valid field IDs for the given form_id
                    const validFields = await AppDataSource.manager.query(
                        "SELECT id AS field_id FROM form_fields WHERE form_id = ?",
                        [form_id]
                    );

                    const validFieldIds = validFields.map((field: any) => field.field_id);

                    // Validate if all submitted field_ids belong to this form_id
                    for (const field of fields) {
                        if (!validFieldIds.includes(field.field_id)) {
                            res.status(400).json({
                                status: false,
                                message: `Invalid field_id: ${field.field_id} for form_id: ${form_id}`,
                            });
                            return;
                        }
                    }

                    // Create a new form submission entry
                    const newSubmission = formSubmissionRepo.create({
                        company_id: companyId,
                        form_id,
                    });
                    await formSubmissionRepo.save(newSubmission);

                    // Prepare and save form submission values
                    const valuesToSave = fields.map((field: { field_id: number; value: string }) => {
                        return submissionValuesRepo.create({
                            company_id: companyId,
                            submission: newSubmission, // Using relation
                            field_id: field.field_id,
                            value: field.value,
                        });
                    });

                    await submissionValuesRepo.save(valuesToSave);

                    res.json({
                        status: true,
                        message: "Form submitted successfully",
                        submission_id: newSubmission.id,
                    });

                } catch (error) {
                    const stackTrace = (error instanceof Error && error.stack) ? error.stack.split("\n")[1].trim() : "Unknown";

                    res.status(500).json({
                        status: false,
                        message: "Internal Server Error",
                        error: error instanceof Error ? error.message : "Unknown error",
                        filePath: __filename,
                        lineNumber: stackTrace,
                    });
                }
            }
                break;



            default:
                res.status(405).json({
                    status: false,
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
            filePath: __filename,
            lineNumber: stackTrace,
        });
    }

}