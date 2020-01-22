#!/usr/bin/env node

const sortKeys = require('sort-keys');
const TOML = require('@iarna/toml');
const glob = require('mz-modules/glob');
const fs = require('mz/fs');

require('yargs')
    .command({
        command: '$0 <directory>',
        desc: 'Process all .toml files within directory and auto-format them',
        builder: {
            directory: {
                describe: 'Path of directory to scan'
            },
        },
        handler: async argv => {
            const { directory } = argv;
            const files = await glob(`${directory}/**/*.toml`);

            await Promise.all(files.map(
                filePath =>
                    fs.readFile(filePath, 'utf8')
                    .then(toml => TOML.parse(toml))
                    .then(data => {
                        for (const key in data) {
                            // delete empty arrays
                            if (Array.isArray(data[key]) && data[key].length == 0) {
                                delete data[key];
                            }
                        }

                        return data;
                    })
                    .then(data => TOML.stringify(sortKeys(data, { deep: true })))
                    .then(toml => fs.writeFile(filePath, toml, 'utf8'))
                    .then(console.log(`Formatted ${filePath}`))
            ));
        }
    })
    .demandCommand()
    .help()
    .argv;
