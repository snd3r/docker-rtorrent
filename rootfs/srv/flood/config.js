const CONFIG = {
  baseURI: process.env.FLOOD_BASE_URI || '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/flood-db/',
  floodServerHost: '0.0.0.0',
  floodServerPort: process.env.FLOOD_PORT || 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: process.env.FLOOD_SECRET || 'secret',
  scgi: {
    host: 'localhost',
    socket: true,
    host: 'localhost',
    port: 5000,
    socketPath: process.env.SCGI_PATH || '/tmp/rtorrent.sock'
  }
};

module.exports = CONFIG;
