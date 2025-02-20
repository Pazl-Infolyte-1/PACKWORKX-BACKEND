import { Request, Response, NextFunction } from 'express';
import { Buffer } from 'buffer';

/**
 * Helper function to decode a Base64 string multiple times.
 * @param encoded - The encoded string.
 * @param times - How many times to decode.
 * @returns The decoded string.
 */
const decodeBase64Multiple = (encoded: string, times: number): string => {
  let decoded = encoded;
  for (let i = 0; i < times; i++) {
    decoded = Buffer.from(decoded, 'base64').toString('utf8');
  }
  return decoded;
};

/**
 * Middleware to decode the incoming request payload that has been encoded in Base64 5 times,
 * and to decode the outgoing response payload that is encoded in Base64 5 times.
 */
export const requestEncodeResponseDecode = (req: Request, res: Response, next: NextFunction): void => {
    console.log("requestEncodeResponseDecode middleware")
  // --- Decode Incoming Request Payload ---
  if (req.body && req.body.data) {
    console.log("requestEncodeResponseDecode Inside if")
    try {
        console.log("requestEncodeResponseDecode Inside try")
      // Assume req.body.data is a stri
      // ng encoded in Base64 5 times.
      const decodedData = decodeBase64Multiple(req.body.data, 5);
      // Replace the request body with the decoded object.
      req.body = JSON.parse(decodedData);
      console.log("request Body after decoding",req.body)
      return next();
    } catch (error) {
      console.error('Error decoding request payload:', error);
      res.status(400).json({
        status: false,
        message: 'Invalid encoded payload',
        data: [],
    });
      return next();
    }
  }else{
    console.log("No data in request body")
    // return next();
    // res.status(400).json({
    //     status: false,
    //     message: 'Invalid encoded payload',
    //     data: [],
    // });
  }

  // --- Intercept and Decode Outgoing Response Payload ---
  const originalSend = res.send.bind(res);
  res.send = (body?: any): Response => {
    try {
      // Convert the response to a string (if it isn't already)
      let responseString: string = typeof body === 'object' ? JSON.stringify(body) : String(body);
      // Decode the response string 5 times.
      const decodedResponse = decodeBase64Multiple(responseString, 5);
      return originalSend(decodedResponse);
    } catch (error) {
      console.error('Error decoding response payload:', error);
      return originalSend(body);
    }
  };

  next();
};
