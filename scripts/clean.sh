#!/bin/bash

# Remove all the tmp folders that can be found in several subdirectories
find . -name tmp -type d -exec rm -rf {} \;
