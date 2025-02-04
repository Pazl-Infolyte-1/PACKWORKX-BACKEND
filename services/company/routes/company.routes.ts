// company.routes.ts
import { Router } from "express";
import { company } from "../controllers/company.controller"; // Ensure correct import

const router = Router();

router.route('/company')
    .post(company)
    .get(company);
router.route('/company/:id')
    .put(company)
    .get(company)
    .delete(company);

export default router;
