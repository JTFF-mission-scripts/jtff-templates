const jtffci = require("./lib/jtff-lib-ci");
const config = require("../../config.json");
const fs = require("fs");

fs.rmSync(config.general.missionFolder, { force: true, recursive: true })
