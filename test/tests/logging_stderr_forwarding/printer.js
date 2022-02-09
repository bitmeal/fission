#!/usr/bin/env node

// setup
const prefix_stdout = '[stdout]';
const prefix_stderr = '[stderr]';

// print function
const printer = (timeout) => {
    setTimeout(() => { printer(timeout); }, timeout);
    console.log(prefix_stdout, ...(process.argv.slice(2)));
    console.error(prefix_stderr, ...(process.argv.slice(2)));
};


// run
printer(1000);
