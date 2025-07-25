const express = require('express');
const app = express();
const port = 3000;

app.get('/status', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App listening on port ${port}`);
});