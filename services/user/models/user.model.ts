import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  JoinColumn,
  OneToMany,
} from "typeorm";
import { Company } from "../../company/models/company.model"; // Ensure this file exists
import { ApiLog } from "./apilogs.model";

@Entity({ name: "Users" })
export class User {
  validatePassword(password: any) {
      throw new Error("Method not implemented.");
  }
  @PrimaryGeneratedColumn()
  id!: number;


  @Column({ type: "varchar", length: 255, nullable: false })
  name!: string;

  @Column({ type: "varchar", length: 255, unique: true, nullable: false })
  @Index()
  email!: string;

  @Column({ type: "varchar", length: 255, nullable: false })
  password!: string;

  @Column({ type: "varchar", length: 10, unique: true, nullable: true })
  @Index()
  phoneNumber?: string;

  @Column({ type: "varchar", length: 50, nullable: false })
  role!: string;

  @Column({ type: "enum", enum: ["active", "inactive"], default: "active" })
  status!: "active" | "inactive";

  @Column({ type: "enum", enum: ["enable", "disable"], default: "enable" })
  login!: "enable" | "disable";

  @Column({ type: "enum", enum: ["enable", "disable"], default: "enable" })
  email_notifications!: "enable" | "disable";

  @Column({ type: "timestamp", nullable: true })
  last_login?: Date;

  @Column({ type: "enum", enum: ["male", "female", "other"], default: "male" })
  gender!: "male" | "female" | "other";

  @Column({ type: "date", nullable: true })
  dob?: Date;

  @Column({ type: "varchar", length: 255, nullable: true })
  address?: string;

  @Column({ type: "varchar", length: 100, nullable: true })
  city?: string;

  @Column({ type: "varchar", length: 100, nullable: true })
  state?: string;

  @Column({ type: "varchar", length: 100, nullable: true })
  country?: string;

  @Column({ type: "varchar", length: 20, nullable: true })
  zip?: string;

  @Column({ type: "varchar", length: 3, nullable: true })
  countryCode?: string;

  @Column({ type: "varchar", length: 255, nullable: true })
  image?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
  
  @ManyToOne(() => Company, (company) => company.users, { onDelete: "CASCADE", nullable: false })
  @JoinColumn({ name: 'company_id' }) // This defines the foreign key column in the User table
  company!: Company;

  @OneToMany(() => ApiLog, (apiLog: ApiLog) => apiLog.user)
  apiLogs!: ApiLog[];
}
