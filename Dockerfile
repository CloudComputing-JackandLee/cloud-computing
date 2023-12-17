# build step
FROM node:16.13.2-alpine as build
WORKDIR /cloud-computing
COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY . ./
RUN npm run build

#start socket
FROM node:16.13.2-alpine as socket
WORKDIR /cloud-computing/Server
COPY package.json ./
RUN npm install
COPY . ./
EXPOSE 3001
CMD cd .Server
CMD npm devStart


# release step
FROM nginx:latest as release
COPY --from=build /cloud-computing/build /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

