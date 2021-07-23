FROM node:14

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 8081
CMD [ "node", "server.js" ]
