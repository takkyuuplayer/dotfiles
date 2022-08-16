#!/bin/bash

sqlite3 -tabs $1 ".import '|cat -' tbl"
