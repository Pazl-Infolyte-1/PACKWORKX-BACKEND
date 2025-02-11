# Step 1: Use the official Node.js image as the base image
FROM node:22

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Step 4: Install the app dependencies inside the container
RUN npm install


# Step 5: Copy the rest of the application files to the container's working directory
COPY . .

# Delete old dist/ folder if it exists
# RUN rm -rf dist

# Manually build TypeScript files
RUN npm run build

# Expose the port
EXPOSE 3001

# Start the microservice
CMD ["node", "dist/services/company/app.js"]
