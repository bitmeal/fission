#!/usr/bin/env node

// signal handler
function handle(signal) {
        // exit process with delay
        setTimeout(() => { process.exit(0); }, ...process.argv.slice(2));
}

// register handler
process.on('SIGINT', handle);
process.on('SIGTERM', handle);

// keep alive
const block = () => {
        setTimeout(block, 1000);
        // /* noop */

        // keep alive by reading stdin
        // process.stdin.resume();
};

block();