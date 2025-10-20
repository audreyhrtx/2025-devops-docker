FROM node:24-bullseye

WORKDIR ./
COPY ./broken-app ./
RUN npm install

RUN useradd -ms /bin/bash audrey
USER audrey

EXPOSE 3000
CMD ["npm", "start"]
