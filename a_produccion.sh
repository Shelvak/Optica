#!/bin/bash
git add .
git commit -a -m "a produccion"
git push
cap deploy
