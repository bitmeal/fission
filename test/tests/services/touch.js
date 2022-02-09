#!/usr/bin/env node

const fs = require('fs').promises;
const path = require('path');


const fpath = process.argv[2];
const dpath = path.dirname(fpath);

const block = () => {
    setTimeout(block, 1000);
    // /* noop */

    // keep alive by reading stdin
    // process.stdin.resume();
};

fs.mkdir(dpath, {recursive: true})
.then(() => {
        return fs.open(fpath, 'w');
})
.then((f) => {
        return f.close();
})
.then(() => {
    block();
});