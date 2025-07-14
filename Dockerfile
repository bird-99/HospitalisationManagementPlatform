# Stage 1: Build the Vue app
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Run the Node.js server
FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Copy only the built files and server code
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server.js ./
COPY --from=builder /app/routes ./routes
COPY --from=builder /app/db ./db

# Set environment variables if needed
ENV PORT=3000
EXPOSE 3000
CMD ["node", "server.js"]