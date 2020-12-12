# Command line

This guide introduces working with taxonomy data from your command line

## Install gitsheets

The `git sheet` command can be installed to your system via NPM:

```bash
npm install -g gitsheets
```

## Reading to a spreadsheet

```bash
git sheet query issues --format=csv > /tmp/issues.csv
```

## Reading to a JSON file

```bash
git sheet query issues > /tmp/issues.json
```

## Formatting with jq

```bash
git sheet query issues | jq
```

## Extract a list of IDs

```bash
git sheet query issues | jq -r '.[].id'
```

## Get display name for a given ID

```bash
tag="covid-19"
display_name=$(git sheet query issues --filter.id="${tag}" | jq -r '.[].display_name')
echo "${tag} => ${display_name}"
```
