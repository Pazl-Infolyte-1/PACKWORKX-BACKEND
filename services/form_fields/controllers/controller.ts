import { Request, Response, NextFunction } from "express";
import { AppDataSource } from "../../../config/data-source";
import { User } from "../../user/models/user.model";
import { Buffer } from "buffer";
import { Module } from "../../module/models/module.model";
import { SubModule } from "../../module/models/sub_module.model";

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

        const submoduleRepository = AppDataSource.getRepository(SubModule);
        const moduleRepository = AppDataSource.getRepository(Module);
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
            const subModuleId = submoduleDetails.id;
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
                        formKey: field.formKey,
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