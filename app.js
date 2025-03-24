const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello, Kubernetes!');
});

app.listen(port, () => {
  console.log(`Hello from the other side, you've reached pod logs. Your app is running on port ${port}`);
});
