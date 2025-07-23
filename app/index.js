const express = require('express');
const app = express();
const port = 3000;

app.get('/status', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});