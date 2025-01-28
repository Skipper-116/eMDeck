#!/bin/bash
set -e

# Start the app
./scripts/setup.sh
./scripts/clean.sh
python main.py
