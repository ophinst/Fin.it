FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json
RUN npm install pm2 && npm install

COPY . .

RUN npm run start

CMD ["node", "dist/app.js"]
