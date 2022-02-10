#!/usr/bin/env node

// signal handler
function handle(signal) {
        console.log('[stdout]', `[${signal}]`, ...process.argv.slice(2));
        console.error('[stderr]', `[${signal}]`, ...process.argv.slice(2));

        process.exit(0);
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