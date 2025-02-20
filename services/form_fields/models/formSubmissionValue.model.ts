import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from "typeorm";
import { FormSubmission } from "./formsubmission.model";

@Entity("form_submission_values")
export class FormSubmissionValue {
    @PrimaryGeneratedColumn()
    id: number | undefined;

    @Column()
    company_id: number | undefined;

    @ManyToOne(() => FormSubmission, submission => submission.values, { onDelete: "CASCADE" })
    submission: FormSubmission | undefined;

    @Column()
    field_id: number | undefined;

    @Column("text", { nullable: true })
    value: string | undefined;

    @CreateDateColumn()
    created_at: Date | undefined;

    @UpdateDateColumn()
    updated_at: Date | undefined;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status: "active" | "inactive" | undefined;
}
