<?php
	$ERROR_PAGE_HEADING = '500 Internal Server Error';
	$ERROR_PAGE_TEXT = 'An internal web server error occured.';
	require_once($_SERVER['DOCUMENT_ROOT'].'/../common/php/Config.php');
	include(Config::config('LIBRESIGNAGE_ROOT').'/errors/error.php');
