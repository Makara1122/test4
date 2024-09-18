# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS builder

RUN apk add --no-cache libc6-compat

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json files to the container
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy all other project files to the working directory
COPY . .

# If you use sharp for image optimization
RUN npm i sharp

# Build the Next.js project
RUN npm run build

# Multi-stage build process
FROM node:18-alpine

# Install dumb-init for graceful process handling
RUN apk add --no-cache dumb-init

# Add a non-root user
RUN adduser -D nextuser

# Set work directory
WORKDIR /app

# Copy only the necessary build files from the builder stage
COPY --from=builder /app/.next/ ./.next/
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Change ownership to the non-root user
RUN chown -R nextuser:nextuser /app

# Use non-root user
USER nextuser

EXPOSE 3000

# Set environment variables for production
ENV HOST=0.0.0.0 PORT=3000 NODE_ENV=production

# Start the Next.js application
CMD ["dumb-init", "npm", "start"]

