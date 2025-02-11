# Use official Node.js LTS image
FROM node:22

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Build TypeScript files
RUN npm run build

# Expose the port your service runs on
EXPOSE 3002

# Start the microservice
CMD ["node", "dist/services/user/app.js"]
