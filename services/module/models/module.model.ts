
import { Company } from "../../company/models/company.model"; // Ensure this file exists
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from "typeorm";

@Entity("modules")
export class Module {
  @PrimaryGeneratedColumn()
  id: number | undefined;

  @Column({ type: "varchar", length: 191, nullable: false })
  module_name: string | undefined;

  @Column({ type: "varchar", length: 191, nullable: true })
  description?: string;

  @Column({ type: "varchar", length: 191, nullable: true })
  icon?: string;

  @Column({ type: "varchar", length: 191, nullable: true })
  route?: string;

  @Column({ type: "int", nullable: true })
  parent_id?: number;

  @ManyToOne(() => Company, (company) => company.modules, { onDelete: "RESTRICT", onUpdate: "RESTRICT", nullable: true })
  @JoinColumn({ name: "company_id" })
  company?: Company;

  @CreateDateColumn({ type: "timestamp", nullable: true })
  created_at: Date | undefined;

  @UpdateDateColumn({ type: "timestamp", nullable: true })
  updated_at: Date | undefined;
}
