# civic-tech-taxonomy

Standardized identifiers for categorizing civic technology projects and interests so we can better help people who want to work together find each other across the network

[Why is a topic taxonomy important?](https://insidegovuk.blog.gov.uk/2015/11/02/developing-a-subject-based-taxonomy-for-gov-uk/)

## Format

Data files are structured with YAML and sorted alphabetically for consistent versioning and comparison.

[i18n_yaml_sorter](https://github.com/redealumni/i18n_yaml_sorter) may be used to sort data files correctly:

    sort_yaml < topics.yml > topics.sorted.yml && mv topics.sorted.yml topics.yml
