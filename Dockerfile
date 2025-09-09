# Use Node.js 22 Alpine as base image
FROM node:22-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    openssh \
    openssl \
    graphicsmagick \
    tini \
    tzdata \
    ca-certificates \
    libc6-compat \
    jq \
    wget

# Install n8n globally
RUN npm install -g n8n

# Create n8n user and directory
RUN addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node && \
    mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node

# Set environment variables
ENV NODE_ENV=production
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_USER_FOLDER=/home/node/.n8n

# Expose port
EXPOSE 5678

# Switch to node user
USER node

# Set working directory
WORKDIR /home/node

# Start n8n
ENTRYPOINT ["tini", "--"]
CMD ["n8n", "start"]
