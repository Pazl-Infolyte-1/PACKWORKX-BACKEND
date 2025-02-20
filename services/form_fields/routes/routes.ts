// user.routes.ts
import { Router } from "express";
import { formFields } from "../controllers/controller"; // Ensure correct import

const router = Router();


router.route('/form-fields/:id').get(formFields)

export default router;
