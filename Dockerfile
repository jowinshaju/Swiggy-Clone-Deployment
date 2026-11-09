# Stage 1: Build the React application
FROM node:22-bookworm-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build


# Stage 2: Serve the React application using Nginx
FROM nginx:stable-alpine

# Upgrade zlib to the patched Alpine package version
RUN apk upgrade --no-cache zlib

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
