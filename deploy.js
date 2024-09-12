
const { Client } = require('ssh2');

const conn = new Client();

const SSH_CONFIG = {
  host: '192.1',
  port: 443,
  username: 'osboxes',
};

const SCRIPT_PATH = '/path/to/your/script/deploy.sh';
function deploy() {
  return new Promise((resolve, reject) => {
    conn.on('ready', () => {
      console.log('SSH Connection ready.');

      conn.exec(`bash ${SCRIPT_PATH}`, (err, stream) => {
        if (err) return reject(err);

        stream.on('close', (code, signal) => {
          console.log(`Stream :: close :: code: ${code}, signal: ${signal}`);
          conn.end();
          resolve();
        }).on('data', (data) => {
          console.log('STDOUT: ' + data);
        }).stderr.on('data', (data) => {
          console.error('STDERR: ' + data);
        });
      });
    }).connect(SSH_CONFIG);
  });
}

module.exports = deploy;
