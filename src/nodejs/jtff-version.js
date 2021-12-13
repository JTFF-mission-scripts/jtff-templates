const jtffci = require("./lib/jtff-lib-ci");

if (process.argv.slice(2).length > 0 ) {
    console.log('setting version to : ' + process.argv.slice(2)[0]);
    jtffci.setVersionfromString(process.argv.slice(2)[0]);
} else {
    console.log('getting version...');
    console.log((jtffci.getVersion()));
}

