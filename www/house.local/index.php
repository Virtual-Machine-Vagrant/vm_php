<?php

function getProjectFolders()
{
//path to directory to scan
    $ignoreFolders = array('html');
    $directory = "/var/www/*";

    $folders = array();
    foreach (glob($directory) as $item) {
        if (is_dir($item) && !in_array(basename($item), $ignoreFolders)) {
            $folders[] = array(
                'url' => 'http://' . basename($item),
                'title' => basename($item),
                'icon' => file_exists($item . '/web/favicon.ico') ? 'http://' . basename($item) . '/favicon.ico' : ''
            );
        }
    }
    return $folders;
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>House.local</title>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"
          integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>

<div class="container">

    <!-- The justified navigation menu is meant for single line per list item.
         Multiple lines will require custom code not provided by Bootstrap. -->
    <div class="masthead">
        <h3 class="text-muted">House.local - PHP Web Development</h3>
        <nav>
            <ul class="nav nav-justified">
                <li class="active"><a href="#">Home</a></li>
                <li class=""><a href="/tools/adminer/latest-mysql.php">MySQL Admin</a></li>
                <li class=""><a href="/tools/mongoWebAdmin/">MongoDB Admin</a></li>
                <li class=""><a href="/tools/elasticsearch-HQ/?url=http://house.local:9200">Elasticsearch
                        Admin</a></li>
                <li class=""><a href="/tools/beanstalk/public/">Beanstalk Admin</a></li>
                <li class=""><a href="http://house.local:8025">Mailhog</a></li>
                <li class=""><a href="/info.php">PHP Info</a></li>
                <li class=""><a href="/gd.php">PHP GD Info</a></li>
                <li class=""><a href="/status.html">PHP Status</a></li>
            </ul>
        </nav>
    </div>

    <!-- Jumbotron -->
    <div class="jumbotron">
        <h1>House.local</h1>
        <h2>PHP Web Development</h2>
        <p class="lead"></p>
    </div>
    <!-- Example row of columns -->
    <div class="row">
        <div class="col-lg-8">
            <h2>A great community makes great work!</h2>

            <div class="media">
                <div class="media-left media-middle">
                    <a href="https://www.vagrantup.com/">
                        <img class="media-object" src="/img/vagrant.png" alt="...">
                    </a>
                </div>
                <div class="media-body">
                    <h4 class="media-heading">Vagrant</h4>
                </div>
            </div>

            <div class="media">
                <div class="media-left media-middle">
                    <a href="https://puphpet.com/">
                        <img class="media-object" src="/img/puphpet.jpg" alt="puPHPet">
                    </a>
                </div>
                <div class="media-body">
                    <h4 class="media-heading">PuPHPet</h4>
                </div>
            </div>

            <div class="media">
                <div class="media-left media-middle">
                    <a href="https://github.com/phpbrew/phpbrew">
                        <img class="media-object" src="/img/github.png" alt="PHPBrew">
                    </a>
                </div>
                <div class="media-body">
                    <h4 class="media-heading">PHPBrew</h4>
                </div>
            </div>

            <h2>Contribute</h2>
            <p><a class="btn btn-primary" href="https://github.com/roman-1983/vm_php" role="button">php_vm @ github</a>
            </p>

        </div>
        <div class="col-lg-4">
            <h2>Projects</h2>
            <?php
            $projects = getProjectFolders();
            foreach ($projects as $project) {

                echo '<div class="media"><div class="media-left media-middle">';
                echo '<a href="' . $project['url'] . '">';
                if ($project['icon']) {
                    echo '<img class="media-object" style="width: 32px;" src="' . $project['icon'] . '" alt="' . $project['title'] . '" data-pin-nopin="true">';
                } else {
                    echo '<span style="width: 32px; display: block;"></span>';
                }
                echo '</div>';
                echo '<div class="media-body"><h4 class="media-heading">' . $project['title'] . '</h4></a></div></div>';
            }
            ?>
        </div>
    </div>
</div> <!-- /container -->

<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
        integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS"
        crossorigin="anonymous"></script>
</body>
</html>

