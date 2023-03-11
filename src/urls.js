const { ipcRenderer } = require('electron');

// Navigate to URLs passed to a running instance
ipcRenderer.on('open-url', (event, url) => {
	location.assign(url);
});