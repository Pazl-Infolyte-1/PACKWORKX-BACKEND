import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from "typeorm";

@Entity("forms")
export class Form {
    @PrimaryGeneratedColumn({ type: "int", unsigned: true })
    id!: number;

    @Column({ type: "int" })
    company_id!: number;

    @Column({ type: "int", unsigned: true })
    sub_module_id!: number;

    @Column({ type: "varchar", length: 255 })
    name!: string;

    @Column({ type: "text", nullable: true })
    description?: string;

    @Column({ type: "longtext", nullable: true })
    config?: string;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
    created_at!: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP", onUpdate: "CURRENT_TIMESTAMP" })
    updated_at!: Date;
}
