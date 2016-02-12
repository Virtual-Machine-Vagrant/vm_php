<?php

function getVersions() {
	system('./versions.sh');
	$file = file('phpversions.txt');

	$versions = array();

	foreach ($file as $key => $line) {
		$line = trim(str_replace('php-', '', $line));
		if (substr($line, 0, 1) == '*') {
			$activeVersion = $key;
			$line = str_replace('* ', '', $line);
		}
		$versions[$key] = $line;
	}	
	return array(
		'versions' => $versions,
		'activeId' => $activeVersion,
		);
}

$versions = getVersions();

echo '<form method="post"><select>';
foreach($versions['versions'] as $key => $version) {
	echo '<option value="$version" '.($versions['activeId'] == $key ? 'selected="selected"' : '').'>'. $key . ' ' .$version.'</option>';
}
echo '</select><input type="submit"></form>';
?>
