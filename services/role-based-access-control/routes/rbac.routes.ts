// user.routes.ts
import { Router } from "express";
import { rbac } from "../controllers/rbac.controller"; // Ensure correct import

const router = Router();


router.route('/role-based-access-control').get(rbac)

export default router;
