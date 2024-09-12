
const express = require('express');
const app = express();
const port = 3000;
const deploy = require('./deploy');

app.use(express.static('public'));

app.get('/deploy', async (req, res) => {
  try {
    await deploy();
    res.send('Deployment started. Check the server logs for details.');
  } catch (error) {
    console.error('Error during deployment:', error);
    res.status(500).send('Deployment failed');
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
