import { Request, Response, NextFunction } from 'express';
import { AppDataSource } from '../config/data-source'; // TypeORM Data Source
import { ApiLog } from '../services/user/models/apiApiLogs.model';
import emailQueue from './emailQueue';

export const ApiLogRequestResponse = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const { method, url, body, headers, user } = req as any; // Assuming `user` is added to `req`
    const userId: number | null = user?.id || null; // Default to null if no user is found
    const startTime: number = Date.now();

    const ApiLogRepository = AppDataSource.getRepository(ApiLog);

    let ApiLogEntry: ApiLog | null = null;

    try {
        ApiLogEntry = ApiLogRepository.create({
            user: userId ? { id: userId } : null,
            method,
            url,
            requestBody: JSON.stringify(body),
            requestHeaders: JSON.stringify(headers),
            responseBody: '',
            errorMessage: '',
            stackTrace: '',
            duration: 0,
            statusCode: 200,
        });

        await ApiLogRepository.save(ApiLogEntry);
    } catch (error) {
        console.error('Failed to ApiLog request:', error);
    }

    const originalSend = res.send;

    res.send = async function (this: Response, data: any): Promise<void> {
        const duration: number = Date.now() - startTime;

        try {
            if (ApiLogEntry) {
                ApiLogEntry.statusCode = res.statusCode;
                ApiLogEntry.responseBody = data.toString();
                ApiLogEntry.duration = duration;
                await ApiLogRepository.save(ApiLogEntry);
            }

            if (res.statusCode === 500) {
                await emailQueue.add({
                    to: 'ananda.s@pazl.info',
                    subject: 'Buzz Application Error Notification',
                    text: `An error occurred in the application:\n\nUser: ${userId}\nMethod: ${method}\nURL: ${url}\nResponse: ${data}`,
                });
            }
        } catch (error) {
            console.error('Failed to update response ApiLog:', error);
        }

        return originalSend.apply(this, arguments as any);
    };

    res.on('finish', async () => {
        if (res.statusCode >= 400 && res.statusCode !== 500) {
            const errorMessage: string = `Error with status code ${res.statusCode}`;
            const stackTrace: string = new Error().stack || '';

            try {
                if (ApiLogEntry) {
                    ApiLogEntry.statusCode = res.statusCode;
                    ApiLogEntry.errorMessage = errorMessage;
                    ApiLogEntry.stackTrace = stackTrace;
                    await ApiLogRepository.save(ApiLogEntry);
                }

                await emailQueue.add({
                    to: 'ananda.s@pazl.info',
                    subject: 'Buzz Application Error Notification',
                    text: `An error occurred in the application:\n\nUser: ${userId}\nMethod: ${method}\nURL: ${url}\nError: ${errorMessage}\nStack Trace:\n${stackTrace}`,
                });
            } catch (error) {
                console.error('Failed to update error ApiLog or enqueue email:', error);
            }
        }
    });

    next();
};
