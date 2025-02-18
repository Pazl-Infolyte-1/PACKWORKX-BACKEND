import { Request, Response, NextFunction } from "express";
import { AppDataSource } from "../../../config/data-source"; // Adjust path as necessary
import { User } from "../../user/models/user.model";
import { Buffer } from "buffer";

interface CustomRequest extends Request {
    user?: {
        id: number;
        company?: {
            id: number;
            name: string;
        };
    };
}

export const rbac = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const customReq = req as CustomRequest;
        const userId: number | undefined = customReq?.user?.id;
        const companyId: number | undefined = customReq?.user?.company?.id;

        if (!userId || !companyId) {
            res.status(400).json({
                status: false,
                message: "User ID or Company ID is missing",
            });
        }

        // Ensure user exists in the database
        const UserRepository = AppDataSource.getRepository(User);
        const userDetails = await UserRepository.findOneBy({ id: userId });

        if (!userDetails) {
            res.status(404).json({
                status: false,
                message: "User not found",
            });
        }

        // Call the stored procedure safely
        const query = `CALL GetUserModules(?, ?)`; // Using placeholders
        console.log(userId, companyId)
        const result = await AppDataSource.query(query, [userId, companyId]); // Execute with parameters
        console.log(result)
        const rawData = result[0] || [];
        const groupedData = rawData.reduce((acc: any[], row: any) => {
            // Find the group by group_name
            let group = acc.find((g) => g.groupName === row.group_name);
            if (!group) {
                group = { groupName: row.group_name, modules: [] };
                acc.push(group);
            }
        
            // Find the module within the group
            let module = group.modules.find((m: { moduleName: string }) => m.moduleName === row.module_name);
            if (!module) {
                module = {
                    moduleName: row.module_name,
                    moduleKey: Buffer.from(row.module_key).toString("base64"),
                    moduleIconName: row.module_icon_name,
                    subModules: []
                };
                group.modules.push(module);
            }
        
            // Check if sub-module already exists (to prevent duplicates)
            const existingSubModule = module.subModules.find(
                (s: { subModuleKey: string }) => s.subModuleKey === Buffer.from(row.sub_module_key).toString("base64")
            );
        
            if (!existingSubModule) {
                module.subModules.push({
                    subModuleName: row.sub_module_name,
                    subModuleKey: Buffer.from(row.sub_module_key).toString("base64"),
                    subModuleIconName: row.sub_module_icon_name
                });
            }
        
            return acc;
        }, []);
        res.status(200).json({
            status: true,
            message: "Role-Based Access Control Data",
            data: groupedData,
        });

    } catch (error) {
        console.error("RBAC Error:", error);

        res.status(500).json({
            status: false,
            message: "Internal Server Error",
            error: error instanceof Error ? error.message : "Unknown error",
        });
    }
};
