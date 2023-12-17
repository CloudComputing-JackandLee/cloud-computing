# build step
FROM node:16.13.2-alpine as build
WORKDIR /cloud-computing
COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY . ./
RUN npm run start