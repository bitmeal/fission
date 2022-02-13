#!/usr/bin/env node

const fs = require('fs');

const { badgen } = require('badgen');

const { createSVGWindow } = require('svgdom');
const window = createSVGWindow();
const document = window.document;
const { SVG, registerWindow } = require('@svgdotjs/svg.js');
registerWindow(window, document);

const offset = 5;

// read [ { job: <name>, success: <truthy> }] from stdin
const matrix = JSON.parse(fs.readFileSync(process.stdin.fd, 'utf-8'));

// build badges
const badges = matrix
    .map((job) => {
        return badgen({
            label: job.job,
            status: job.success ? 'passing' : 'failing',
            color: job.success ? 'green' : 'red',
            style: 'flat'
        });
    })
    .reduce((doc, badge, idx) => {
        const badge_svg = SVG(badge);
        doc.add(badge_svg.move((doc.bbox().width - doc.bbox().x) + (idx ? 1 : 0)*offset, 0));

        return doc;
    }, SVG());

const viewbox = badges.bbox();
badges.viewbox(
    viewbox.x,
    viewbox.y,
    viewbox.width,
    viewbox.height
);

// print horizontal badge row svg to stdout
console.log(badges.svg());