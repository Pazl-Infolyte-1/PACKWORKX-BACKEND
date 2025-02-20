import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from "typeorm";
import { FormSubmission } from "./formsubmission.model";

@Entity("form_submission_values")
export class FormSubmissionValue {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int", nullable: false }) // ✅ Explicitly define as integer
    company_id!: number;

    @ManyToOne(() => FormSubmission, submission => submission.values, { onDelete: "CASCADE" })
    @JoinColumn({ name: "submission_id" }) // ✅ Explicit foreign key column
    submission!: FormSubmission;

    @Column({ type: "int", nullable: false }) // ✅ Explicitly define as integer
    field_id!: number;

    @Column("text", { nullable: true })
    value!: string;

    @CreateDateColumn()
    created_at!: Date;

    @UpdateDateColumn()
    updated_at!: Date;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status!: "active" | "inactive";
}
