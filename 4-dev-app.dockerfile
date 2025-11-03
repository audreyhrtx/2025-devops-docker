FROM node:24-bullseye

WORKDIR ./
COPY ./ ./
RUN npm install

RUN useradd audrey
USER audrey

EXPOSE 3000
CMD ["npm", "start"]
