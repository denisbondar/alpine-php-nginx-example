<?php
file_put_contents(
    '/logs/demo.log',
    sprintf("%s | Demo log data\n", date("Y-m-d H:i:s")),
    FILE_APPEND | LOCK_EX
);

phpinfo();
