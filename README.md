# civic-tech-taxonomy

Standardized identifiers for categorizing civic technology projects and interests so we can better help people who want to work together find each other across the network

- [Project documentation](https://codeforamerica.github.io/civic-tech-taxonomy/)
- [Discuss on Discourse: Common projects taxonomy](https://discourse.codeforamerica.org/t/common-projects-taxonomy/308)

## Taxonomy sets needed

- Technologies Used
- Topics/Interests
- Skills Needed
- Project Roles

## Draft User Interface
[taxonomy](taxonomy.html)

## Project goals

- Publish via this repository several lists of terms that describe the tools, topics, and techniques of civic technology
- Establish community standards for the data format, language conventions, and organizational strategies of these taxonomies
- Provide a user-friendly way to generate a pull request for adding a term
- Automate as much of the review for pull requests as possible to help things move quickly
- Automatically publish merged changes in a variety of formats for easy consumptions: plaintext, CSV, YAML, JSON
- Provide hosted search endpoints with CORS enabled and example implementations of integrated inputs in a variety of html/javascript frameworks

## Open questions

- What sort of hierarchy is needed? Should the taxonomy lists be flat, organized within a single level of categories, or support any level of nesting?
  - Concensus _seems_ to

## Use cases

- Brigades use various CMS tools for keeping track of their projects. The taxonomy could be imported into such a system or a dynamic input field embedded that suggests official topics for end users and moderators categorizing projects
- A network-wide site could index local projects and take advantage of the official taxonomy to provide a better browsing/search experience
- Brigade members could set up a profile indicating what topics they're interested in, and be alerted in the future when projects in their interest area(s) are started or have updates

## Format

Tags defined within the repository are stored in the [gitsheets format](https://docs.gitsheets.com/), and can be read with any [TOML](https://toml.io/en/) parser or higher-level gitsheets interface.

See [project documentation](https://codeforamerica.github.io/civic-tech-taxonomy/) for more information

## Related work and reading

- https://github.com/designforsf/brigade-matchmaker/blob/master/docs/taxonomy.md
- https://blogs.microsoft.com/on-the-issues/2016/04/27/towards-taxonomy-civic-technology/
- [Why is a topic taxonomy important?](https://insidegovuk.blog.gov.uk/2015/11/02/developing-a-subject-based-taxonomy-for-gov-uk/)
