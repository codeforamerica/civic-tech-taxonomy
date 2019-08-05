#!/bin/bash -e

node ./import.js laddr codeforphilly.org --commit-to=sites/codeforphilly.org
node ./import.js laddr codeforcroatia.org --commit-to=sites/codeforcroatia.org
node ./import.js laddr brigade.opencharlotte.org --commit-to=sites/opencharlotte.org
node ./import.js laddr www.codeforcary.org --commit-to=sites/codeforcary.org
node ./import.js matchmaker --commit-to=sites/codeforsanfrancisco.org
