const core = require('@actions/core');
// const github = require('@actions/github');
const exec = require('@actions/exec');

function run() {
    // 1) Get some input values
    const bucket = core.getInput('bucket', { required: true });
    const bucketRegion = core.getInput('bucket-region', { required: true });
    const distFolder = core.getInput('dist-folder', { required: true });

    // 2) Upload files
    // const localFolder = distFolder
    const s3Uri = `s3://${bucket}`;
    // exec.exec(`aws s3 sync <local-folder> <s3-bucket>`)
    exec.exec(`aws s3 sync ${distFolder} ${s3Uri} --region ${bucketRegion}`);

    core.notice('Hello from my custom JavaScript Action!');

    // const websiteUrl = `http://${bucket}.s3-website-${bucketRegion}.amazonaws.com`;
    const websiteUrl = `${bucket}.s3-website-${bucketRegion}.amazonaws.com`;
    core.setOutput('website-url', websiteUrl); //setOutput
}

run();