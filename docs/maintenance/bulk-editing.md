# Bulk Editing

## Dynamically with JavaScript

Open an interactive node shell:

```bash
cd ~/Repositories/civic-tech-taxonomy
npm install
node
```

And paste a script to transform records:

```js
(async () => {
    const Repository = require('gitsheets/lib/Repository')
    const repo = await Repository.getFromEnvironment({ working: true })

    // open sheets
    const sheets = await repo.openSheets()
    console.log(`loaded sheets: ${Object.keys(sheets).join(', ')}`)

    // process each sheet
    for (const sheetName in sheets) {
        console.log(`processing ${sheetName} sheet`)
        const sheet = sheets[sheetName]

        // process each record
        for await (const tag of sheet.query()) {
            tag.upper_name = (tag.display_name || tag.id).toUpperCase()

            // upsert modified record to save
            await sheet.upsert(tag)
        }
    }

    // write changes to working tree
    console.log('writing to working tree...')
    const workspace = await repo.getWorkspace()
    await workspace.writeWorkingChanges()
    console.log('done')
})()
```

## Via shell scripting

With [the gitsheets CLI set up](https://codeforamerica.github.io/civic-tech-taxonomy/getting-started/cli/#install-gitsheets), you can use shell commands like `find` and `jq` to make bulk changes to the taxonomy:

```bash
find issues skills statuses technologies -name '*.toml' | while read record_path; do
    record_id=$(basename "${record_path}" .toml)
    record_sheet=$(dirname "${record_path}")
    echo "Initializing id=${record_id} for ${record_path} in ${record_sheet}"

    git sheet read "${record_path}" \
        | jq ".id = \"${record_id}\"" \
        | git sheet upsert "${record_sheet}"
done
```
