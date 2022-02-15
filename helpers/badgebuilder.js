#!/usr/bin/env node

const fs = require('fs');

const { badgen } = require('badgen');

const { createSVGWindow } = require('svgdom');
const window = createSVGWindow();
const document = window.document;
const { SVG, registerWindow } = require('@svgdotjs/svg.js');
registerWindow(window, document);


const { library, icon, findIconDefinition } = require('@fortawesome/fontawesome-svg-core');
const { fab } = require('@fortawesome/free-brands-svg-icons');
library.add(fab);


// config
const offset = 5;
const github_viewport_width = 830;


// load icon helper
const default_icon = 'linux';
function icon_resolver(name)
{
    const mapping = {
        opensuse: 'suse',
        amazonlinux: 'aws',
        'redhat-ubi8': 'redhat'
    };
    return mapping[name] || name;
}

function get_icon(job) {
    return `data:image/svg+xml;base64,${
        Buffer.from(
            SVG(
                icon(
                    findIconDefinition({iconName: job['icon'] || icon_resolver(job.job), prefix: 'fab'}) ||
                    findIconDefinition({iconName: 'linux', prefix: 'fab'})
                ).html[0]
            ).get(0)
            .attr('fill', 'white')
            .root().svg()
        ).toString('base64')
    }`;
}



// read [ { job: <name>, success: <truthy> }] from stdin
const matrix = JSON.parse(fs.readFileSync(process.stdin.fd, 'utf-8'));

// build badges
const badges = matrix
    .map((job) => {
        return badgen({
            label: job.job,
            status: job.success ? 'passing' : 'failing',
            color: job.success ? 'green' : 'red',
            style: 'flat',
            icon: get_icon(job)
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
).size(viewbox.width, viewbox.height);

// print horizontal badge row svg to stdout
console.log(badges.svg());