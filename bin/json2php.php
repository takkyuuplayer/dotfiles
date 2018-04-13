<?php
$input = '';

while($in = trim(fgets(STDIN))) {
    $input .= $in;
}

var_export(json_decode($input, true));
