# import-all

Updates snapshots of tracked external taxonomies stored in secondary branches

## Usage

1. Ensure local copies of all branches match current remote version:

    ```bash
    git fetch origin '+refs/heads/sites/*:refs/heads/sites/*'
    ```

2. Run all-sites importer:

    ```bash
    script/import-all
    ```

3. Push all updates:

    ```bash
    git push origin 'refs/heads/sites/*:refs/heads/sites/*'
    ```
