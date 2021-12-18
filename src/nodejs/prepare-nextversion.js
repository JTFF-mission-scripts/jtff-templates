const jtffci = require("./lib/jtff-lib-ci");

const versionObject = jtffci.getVersion();
versionObject.minor += 1;
versionObject.releaseSuffix = "snapshot";

jtffci.setVersionfromString(jtffci.displayVersion(versionObject));
