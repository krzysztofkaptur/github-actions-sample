FROM node:20-alpine3.17 AS dev

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build

ENV HOST=0.0.0.0

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
# HOW TO RUN THE DEVELOPMENT BUILD
# docker build --target dev -t novo-notes-dev .
# docker run --name novo-notes-dev -p 3000:5173 novo-notes-dev

FROM nginx:alpine as final
EXPOSE 80
COPY --from=dev /app/dist/ /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
# HOW TO RUN THE PRODUCTION BUILD
# docker build -t novo-notes .
# docker run --rm -d --name novo-notes -p 8080:80 novo-notes

# ALTERNATIVELY, YOU CAN RUN WITH DOCKER COMPOSE
# docker-compose up
# docker-compose down

# HOW  TO PUSH TO DOCKERHUB
#docker tag novo-notes <repo-name>:<tagname>
#docker push <repo-name>:<tagname>