const jtffci = require("./lib/jtff-lib-ci");

const versionObject = jtffci.getVersion();
versionObject.releaseSuffix = "";

// console.log(jtffci.displayVersion(versionObject));
jtffci.setVersion(versionObject);
