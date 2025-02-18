
import { Company } from "../../company/models/company.model"; // Ensure this file exists
import { Module } from "./module.model";
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from "typeorm";

@Entity("module_groups")
export class ModuleGroup {
  @PrimaryGeneratedColumn()
  id: number | undefined;

  @Column({ type: "varchar", length: 191, nullable: false })
  group_name?: string | undefined;

  @ManyToOne(() => Company, (company) => company.modules, { onDelete: "RESTRICT", onUpdate: "RESTRICT", nullable: true })
  @JoinColumn({ name: "company_id" })
  company?: Company;

  /** ✅ One-to-Many relation with Module **/
  @OneToMany(() => Module, (module) => module.module_group)
  modules: Module[] | undefined;

  @CreateDateColumn({ type: "timestamp", nullable: true })
  created_at: Date | undefined;

  @UpdateDateColumn({ type: "timestamp", nullable: true })
  updated_at: Date | undefined;

  @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
  status!: "active" | "inactive";
}
