const jtffci = require("./lib/jtff-lib-ci");
if (process.env.JTFF_FTP_SECRET_JSON) {
    const jtffcreds = JSON.parse(process.env.JTFF_FTP_SECRET_JSON);
    jtffci.uploadMizFiles(jtffcreds);
} else {
    console.error('no FTP credentials provided in JTFF_FTP_SECRET_JSON variable');
    process.exit(1);
}
