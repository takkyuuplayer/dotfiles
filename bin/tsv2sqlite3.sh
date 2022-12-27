#!/bin/bash

sqlite3 $1 ".import '|cat -' tbl"
