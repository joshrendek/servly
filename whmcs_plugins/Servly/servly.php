<?php

function servly_ConfigOptions() {
	# Should return an array of the module options for each product - maximum of 24
    $configarray = array(
	 "Server Limit" => array( "Type" => "text", "Size" => "5", ),
	 "Alert Limit" => array( "Type" => "text", "Size" => "5" ),
	 "Url Monitor Limit" => array( "Type" => "text", "Size" => "5" ),
        "User Limit" => array( "Type" => "text", "Size" => "5"),
	);
	return $configarray;
}

function servly_CreateAccount($params) {

    # ** The variables listed below are passed into all module functions **

    $serviceid = $params["serviceid"]; # Unique ID of the product/service in the WHMCS Database
    $pid = $params["pid"]; # Product/Service ID
    $producttype = $params["producttype"]; # Product Type: hostingaccount, reselleraccount, server or other
    $domain = $params["domain"];
	$username = $params["username"];
	$password = $params["password"];
    $clientsdetails = $params["clientsdetails"]; # Array of clients details - firstname, lastname, email, country, etc...
    $customfields = $params["customfields"]; # Array of custom field values for the product
    $configoptions = $params["configoptions"]; # Array of configurable option values for the product

    # Product module option settings from ConfigOptions array above
    $configoption1 = $params["configoption1"];
    $configoption2 = $params["configoption2"];
    $configoption3 = $params["configoption3"];
    $configoption4 = $params["configoption4"];

    # Additional variables if the product/service is linked to a server
    $server = $params["server"]; # True if linked to a server
    $serverid = $params["serverid"];
    $serverip = $params["serverip"];
    $serverusername = $params["serverusername"];
    $serverpassword = $params["serverpassword"];
    $serveraccesshash = $params["serveraccesshash"];
    $serversecure = $params["serversecure"]; # If set, SSL Mode is enabled in the server config

	# Code to perform action goes here...

	if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_TerminateAccount($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_SuspendAccount($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_UnsuspendAccount($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_ChangePassword($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_ChangePackage($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

function servly_ClientArea($params) {
	$code = '<form action="http://'.$serverip.'/controlpanel" method="post" target="_blank">
<input type="hidden" name="user" value="'.$params["username"].'" />
<input type="hidden" name="pass" value="'.$params["password"].'" />
<input type="submit" value="Login to Control Panel" />
<input type="button" value="Login to Webmail" onClick="window.open(\'http://'.$serverip.'/webmail\')" />
</form>';
	return $code;
}

function servly_AdminLink($params) {
	$code = '<form action=\"http://'.$params["serverip"].'/controlpanel" method="post" target="_blank">
<input type="hidden" name="user" value="'.$params["serverusername"].'" />
<input type="hidden" name="pass" value="'.$params["serverpassword"].'" />
<input type="submit" value="Login to Control Panel" />
</form>';
	return $code;
}

function servly_LoginLink($params) {
	echo "<a href=\"http://".$params["serverip"]."/controlpanel?gotousername=".$params["username"]."\" target=\"_blank\" style=\"color:#cc0000\">login to control panel</a>";
}

function servly_AdminCustomButtonArray() {
	# This function can define additional functions your module supports, the example here is a reboot button and then the reboot function is defined below
    $buttonarray = array(
	 "Reboot Server" => "reboot",
	);
	return $buttonarray;
}

function servly_reboot($params) {

	# Code to perform action goes here...

    if ($successful) {
		$result = "success";
	} else {
		$result = "Error Message Goes Here...";
	}
	return $result;
}

?>

