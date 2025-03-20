
FROM node:alpine

WORKDIR /usr/src/app
# Copying just package and package lock JSON files before npm install will lead to quick dependency update
COPY package*.json ./ 

# Install dependencies
RUN npm install

COPY . .

EXPOSE 3000

# Define the command to run the app
CMD ["node", "app.js"]
