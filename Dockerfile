# Estágio 1
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Estágio 2
FROM node:20-alpine
WORKDIR /app
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    mkdir -p /etc/todos && \
    chown -R appuser:appgroup /etc/todos /app
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package*.json ./
COPY --from=builder --chown=appuser:appgroup /app/src ./src
USER appuser
EXPOSE 3000
CMD ["node", "src/index.js"]