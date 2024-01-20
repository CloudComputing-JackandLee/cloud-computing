# build step
FROM node:16.13.2-alpine as start_socket
WORKDIR /socket
COPY package.json ./

RUN npm install
COPY . ./
EXPOSE 3001
#RUN npm start
#CMD ["node", "server.js"]
CMD ["npm", "run", "start"]