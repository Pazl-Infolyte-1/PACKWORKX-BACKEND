// user.routes.ts
import { Router } from "express";
import { formFields } from "../controllers/controller"; // Ensure correct import

const router = Router();


router.route('/form-fields/:id').get(formFields)
router.route('/form-fields-submission').post(formFields)

export default router;
