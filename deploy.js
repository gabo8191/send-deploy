const { Client } = require('ssh2');
const fs = require('fs');
const path = require('path');

const conn = new Client();

const SSH_CONFIG = {
  host: '192.1.1.1.1',
  port: 443,
  username: 'osboxes',
  agent: process.env.SSH_AUTH_SOCK,
};

const LOCAL_SCRIPT_PATH = path.join(__dirname, 'deploy_script.sh');
const REMOTE_SCRIPT_PATH = '/tmp/deploy_script.sh';

function deploy() {
  return new Promise((resolve, reject) => {
    conn.on('ready', () => {
      console.log('SSH Connection ready.');

      conn.sftp((err, sftp) => {
        if (err) return reject(err);

        sftp.fastPut(LOCAL_SCRIPT_PATH, REMOTE_SCRIPT_PATH, (err) => {
          if (err) return reject(err);
          console.log('Script uploaded to remote server.');

          conn.exec(`bash ${REMOTE_SCRIPT_PATH}`, (err, stream) => {
            if (err) return reject(err);

            stream.on('close', (code, signal) => {
              console.log(`Stream closed with code: ${code}, signal: ${signal}`);
              conn.end();
              resolve();
            }).on('data', (data) => {
              console.log('STDOUT: ' + data);
            }).stderr.on('data', (data) => {
              console.error('STDERR: ' + data);
            });
          });
        });
      });
    }).on('error', (err) => {
      console.error('Connection Error:', err);
      reject(err);
    }).connect(SSH_CONFIG);
  });
}

module.exports = deploy;
