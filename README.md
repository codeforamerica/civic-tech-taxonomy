# civic-tech-taxonomy

[![Build Status](https://travis-ci.org/CosmicWebServices/civic-tech-taxonomy.svg?branch=master)](https://travis-ci.org/CosmicWebServices/civic-tech-taxonomy)

Standardized identifiers for categorizing civic technology projects

## Format

Data files are structured with YAML and sorted alphabetically for consistent versioning and comparison.

[i18n_yaml_sorter](https://github.com/redealumni/i18n_yaml_sorter) may be used to sort data files correctly:

    sort_yaml < topics.yml > topics.sorted.yml && mv topics.sorted.yml topics.yml
