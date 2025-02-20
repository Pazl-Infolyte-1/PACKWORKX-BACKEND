import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from "typeorm";
import { FormSubmissionValue } from "./formSubmissionValue.model";

@Entity("form_submissions")
export class FormSubmission {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: "int", nullable: false }) // ✅ Explicitly define as integer
    company_id!: number;

    @Column({ type: "int", nullable: false }) // ✅ Explicitly define as integer
    form_id!: number;

    @CreateDateColumn()
    created_at!: Date;

    @UpdateDateColumn()
    updated_at!: Date;

    @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
    status: "active" | "inactive" | undefined;

    @OneToMany(() => FormSubmissionValue, value => value.submission, { cascade: true })
    values: FormSubmissionValue[] | undefined;
}
