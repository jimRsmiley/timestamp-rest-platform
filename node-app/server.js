'use strict';

const express = require('express');

// Constants
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';

const STATIC_TEXT = process.env.APP_STATIC_TEXT || 'Automate all the things!';

// App
const app = express();
app.get('/', (req, res) => {
  res.send(JSON.stringify({
    message: STATIC_TEXT,
    timestamp: Date.now()
  }));
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
