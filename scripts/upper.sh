#!/bin/bash

echo $1 | awk '{print toupper($0)}'
