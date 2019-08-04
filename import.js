#!/usr/bin/env node

const sortKeys = require('sort-keys');
const TOML = require('@iarna/toml');
const axios = require('axios');
const ProgressBar = require('progress');
const { Repo } = require('hologit/lib');

require('yargs')
    .command({
        command: '$0 <source-type> <source>',
        desc: 'Import taxonomy data from a source',
        builder: {
            sourceType: {
                describe: 'Type of source being imported',
                choices: ['laddr']
            },
            source: {
                describe: 'Host/URL for source. Format varies by source_type'
            },
            append: {
                describe: 'Whether to layer imported data on top of current',
                boolean: true,
                default: false
            },
            'commit-to': {
                describe: 'A target branch/ref to commit the imported tree to',
                type: 'string'
            },
            'commit-message': {
                describe: 'A commit message to use if commit-branch is specified',
                type: 'string'
            },
        },
        handler: async argv => {
            const { commitTo, commitMessage, sourceType, source, append } = argv;

            const repo = await Repo.getFromEnvironment();
            const tree = repo.createTree();

            if (append) {
                // TODO: load an existing tree instead
                throw new Error('append is not yet implemented');
            }

            let outputHash;
            try {
                outputHash = await importTaxonomy(tree, argv);
                console.error('tree ready');
            } catch (err) {
                console.error('failed to import taxonomy:', err);
                process.exit(1);
            }

            if (commitTo) {
                const commitRef = commitTo == 'HEAD' || commitTo.startsWith('refs/')
                    ? commitTo
                    : `refs/heads/${commitTo}`;

                const parents = [
                    await repo.resolveRef(commitRef)
                ];

                const git = await repo.getGit();

                outputHash = await git.commitTree(
                    {
                        p: parents,
                        m: commitMessage || `🔁 imported ${sourceType} from ${source}`
                    },
                    outputHash
                );

                await git.updateRef(commitRef, outputHash);
                console.warn(`committed new tree to "${commitRef}": ${parents.join('+')}->${outputHash}`);
            }

            console.log(outputHash);
        }
    })
    .demandCommand()
    .help()
    .argv;

async function importTaxonomy(tree, argv) {
    if (argv.sourceType == 'laddr') {
        return importLaddr(tree, argv);
    } else {
        throw new Error('Unsupported source type');
    }
}

async function importLaddr(tree, { source }) {
    const { data: { data } } = await axios.get(`http://${source}/tags`, { params: { format: 'json' } });
    const tagsByPrefix = {};


    // load and organize tags
    let tagsCount = 0;
    for (const { Handle, Title } of data ) {
        const [prefix, tag] = Handle.split('.', 2);

        if (!tag) {
            console.warn(`skipping unprefixed tag: ${Handle}`);
            continue;
        } else if (prefix == 'event') {
            // silently skip event tags
            continue;
        } else if (prefix != 'tech' && prefix != 'topic') {
            console.warn(`skipping unhandled tag prefix: ${prefix}`);
            continue;
        }

        if (!tagsByPrefix[prefix]) {
            tagsByPrefix[prefix] = {};
        }

        tagsByPrefix[prefix][tag] = {
            handle: Handle,
            title: Title
        };
        tagsCount++;
    }


    // build tree
    const progressBar = new ProgressBar('building tree :percent [:bar] :rate/s :etas', { total: tagsCount });

    for (const prefix in tagsByPrefix) {
        const tags = tagsByPrefix[prefix];

        for (const tag in tags) {
            const tagData = {
                ...tags[tag],
                handle: null
            };
            const toml = TOML.stringify(sortKeys(tagData, { deep: true }));
            const blob = await tree.writeChild(`${prefix}/${tag}.toml`, toml);

            progressBar.tick();
        }
    }

    // write tree
    return await tree.write();
}
