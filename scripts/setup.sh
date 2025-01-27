#!/bin/bash
find . -name "*.example" | while read example_file; do
    target_file="${example_file%.example}"
    if [ ! -f "$target_file" ]; then
        cp "$example_file" "$target_file"
    fi
done
