import "reflect-metadata";
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { User } from "./user.model"; // Adjust the path based on your project structure

@Entity({ name: "api_logs", comment: "Table containing logs of API requests and responses" })
export class ApiLog {
    @PrimaryGeneratedColumn()
    id!: number;

    @ManyToOne(() => User, (user) => user.apiLogs, {
        nullable: true,
        onDelete: "SET NULL",
        onUpdate: "CASCADE",
    })
    user!: User | null;

    @Column({ type: "varchar", length: 255, nullable: false, comment: "HTTP method of the API request" })
    method!: string;

    @Column({ type: "varchar", length: 255, nullable: false, comment: "URL of the API request" })
    url!: string;

    @Column({ type: "int", nullable: false, comment: "HTTP status code of the API response" })
    statusCode!: number;

    @Column({ type: "text", nullable: true, comment: "Request body of the API request" })
    requestBody?: string;

    @Column({ type: "text", nullable: true, comment: "Header of the API request" })
    requestHeaders?: string;

    @Column({ type: "text", nullable: true, comment: "Response body of the API response" })
    responseBody?: string;

    @Column({ type: "text", nullable: true, comment: "Error message if the API request failed" })
    errorMessage?: string;

    @Column({ type: "text", nullable: true, comment: "Stack trace if the API request failed" })
    stackTrace?: string;

    @Column({ type: "int", nullable: true, comment: "Duration of the API request in milliseconds" })
    duration?: number;

    @CreateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP", comment: "Timestamp when the record was created" })
    createdAt!: Date;

    @UpdateDateColumn({ type: "timestamp", default: () => "CURRENT_TIMESTAMP", onUpdate: "CURRENT_TIMESTAMP", comment: "Timestamp when the record was last updated" })
    updatedAt!: Date;
}