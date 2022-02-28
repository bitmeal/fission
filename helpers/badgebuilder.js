#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const { badgen } = require('badgen');

const { createSVGWindow } = require('svgdom');
const window = createSVGWindow();
const document = window.document;
const { SVG, registerWindow } = require('@svgdotjs/svg.js');
registerWindow(window, document);


const { library, icon, findIconDefinition } = require('@fortawesome/fontawesome-svg-core');
const { fab } = require('@fortawesome/free-brands-svg-icons');
library.add(fab);

// sanitize font-logo svg data
const { optimize } = require('svgo');

// config
const offset = 5;
const github_viewport_width = 830;


// font logo wrapper
const font_logo_vector_path = path.join(path.dirname(require.resolve('font-logos/package.json')), 'vectors');
function getFontLogoIcon(name) {
    const vectorPath = path.join(font_logo_vector_path, `${name}.svg`);
    return fs.existsSync(vectorPath) ?
        optimize(fs.readFileSync(vectorPath, {encoding: 'utf-8'}), {
            path: vectorPath,
            // multipass: true,
        }).data :
        undefined;
}

// load icon helper
const default_icon = 'linux';
function icon_resolver(name)
{
    const mapping = {
        opensuse: 'suse',
        amazonlinux: 'aws',
        'redhat-ubi8': 'redhat',
        rockylinux: 'rocky-linux'
    };
    return mapping[name] || name;
}

function get_icon(job) {
    return `data:image/svg+xml;base64,${
        Buffer.from(
            SVG(
                getFontLogoIcon(job['icon'] || icon_resolver(job.job)) ||
                icon(
                    findIconDefinition({iconName: job['icon'] || icon_resolver(job.job), prefix: 'fab'}) ||
                    findIconDefinition({iconName: 'linux', prefix: 'fab'})
                ).html[0]
            )
            .each((_i, child) => {
                child.attr('fill', 'white');
                child.css('fill', 'white');
            }, true)
            .svg()
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