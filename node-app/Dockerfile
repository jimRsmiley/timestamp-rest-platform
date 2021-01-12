FROM node:12-alpine

WORKDIR /opt/timestamp-app

# leverage Docker layering to avoid rebuilding npm packages anytime the custom code changes
COPY package.json .
RUN npm install

COPY server.js .

CMD ["npm", "start"]
