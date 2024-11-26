#!/usr/bin/env bash

odin build main_release -out:bin/game_release.bin -strict-style -vet -no-bounds-check -o:speed
