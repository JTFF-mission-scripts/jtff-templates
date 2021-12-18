const jtffci = require("./lib/jtff-lib-ci");

if (process.env.GDRIVE_TOKEN_CACHE_JSON) {
    const gcreds = JSON.parse(process.env.GDRIVE_TOKEN_CACHE_JSON);
    jtffci.publishMizFiles(gcreds);
} else {
    console.error('no google drive credentials provided in GDRIVE_TOKEN_CACHE_JSON variable');
    process.exit(1);
}
