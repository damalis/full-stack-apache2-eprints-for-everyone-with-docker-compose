#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
print $q->header('text/html');

print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to Perl Website</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #333; }
        p { color: #666; }
    </style>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>This is a simple website generated using Perl and CGI.</p>
</body>
</html>
HTML
