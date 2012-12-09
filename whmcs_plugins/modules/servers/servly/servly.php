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
    $server_limit = $params["configoption1"];
    $alert_limit = $params["configoption2"];
    $url_monitor_limit = $params["configoption3"];
    $user_limit = $params["configoption4"];
    $subdomain = $params["customfields"]["Subdomain"];

    # Additional variables if the product/service is linked to a server
    $server = $params["server"]; # True if linked to a server
    $serverid = $params["serverid"];
    $serverip = $params["serverip"];
    $serverusername = $params["serverusername"];
    $serverpassword = $params["serverpassword"];
    $serveraccesshash = $params["serveraccesshash"];
    $serversecure = $params["serversecure"]; # If set, SSL Mode is enabled in the server config

	# Code to perform action goes here...

    $debug = print_r($params, true);
    $fp = fopen('/home/debug.txt', 'w');

    $post_data = array();
    $post_data['email'] = $params["clientsdetails"]["email"];
    $post_data['password'] = $params["password"];
    $post_data['subdomain'] = $subdomain;
    $post_data['server_limit'] = $server_limit;
    $post_data['alert_limit'] = $alert_limit;
    $post_data['url_monitor_limit'] = $url_limit;
    $post_data['user_limit'] = $user_limit;
    $post_data['key'] = "CqICmQ9qw7sCKfNDsQIrcnqxMiGecqv";
    $url = "http://api.servly.com/api/add_user"; 
    $o="";
    foreach ($post_data as $k=>$v)
    {
      $o.= "$k=".utf8_encode($v)."&";
    } 
    $post_data=substr($o,0,-1);
                           
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_URL, $url);   
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
    $http_result = curl_exec($ch);
    fwrite($fp, $http_result);
    fwrite($fp, $debug);
    fclose($fp);
            
    if($http_result == "User account created."){
      $successful = true;
    }else{
      $result = $http_result;
    }
    
    if ($successful) {
      $result = "success";
    } else {
      // result set above
      //$result = "Error Message Goes Here...";
    }
    
    return $result;
}

function servly_TerminateAccount($params) {

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
    $server_limit = $params["configoption1"];
    $alert_limit = $params["configoption2"];
    $url_monitor_limit = $params["configoption3"];
    $user_limit = $params["configoption4"];
    $subdomain = $params["customfields"]["Subdomain"];

    # Additional variables if the product/service is linked to a server
    $server = $params["server"]; # True if linked to a server
    $serverid = $params["serverid"];
    $serverip = $params["serverip"];
    $serverusername = $params["serverusername"];
    $serverpassword = $params["serverpassword"];
    $serveraccesshash = $params["serveraccesshash"];
    $serversecure = $params["serversecure"]; # If set, SSL Mode is enabled in the server config

	# Code to perform action goes here...

    $debug = print_r($params, true);
    $fp = fopen('/home/debug.txt', 'w');

    $post_data = array();
    $post_data['email'] = $params["clientsdetails"]["email"];
    $post_data['password'] = $params["password"];
    $post_data['subdomain'] = $subdomain;
    $post_data['key'] = "CqICmQ9qw7sCKfNDsQIrcnqxMiGecqv";
    $url = "http://api.servly.com/api/terminate"; 
    $o="";
    foreach ($post_data as $k=>$v)
    {
      $o.= "$k=".utf8_encode($v)."&";
    } 
    $post_data=substr($o,0,-1);
                           
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_URL, $url);   
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
    $http_result = curl_exec($ch);
    fwrite($fp, $http_result);
    fwrite($fp, $debug);
    fclose($fp);
            
    if($http_result == "Domain marked terminated."){
      $successful = true;
    }else{
      $result = $http_result;
    }


    if ($successful) {
		$result = "success";
	} else {
	}
	return $result;
}

function servly_SuspendAccount($params) {

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
    $server_limit = $params["configoption1"];
    $alert_limit = $params["configoption2"];
    $url_monitor_limit = $params["configoption3"];
    $user_limit = $params["configoption4"];
    $subdomain = $params["customfields"]["Subdomain"];

    # Additional variables if the product/service is linked to a server
    $server = $params["server"]; # True if linked to a server
    $serverid = $params["serverid"];
    $serverip = $params["serverip"];
    $serverusername = $params["serverusername"];
    $serverpassword = $params["serverpassword"];
    $serveraccesshash = $params["serveraccesshash"];
    $serversecure = $params["serversecure"]; # If set, SSL Mode is enabled in the server config

	# Code to perform action goes here...

    $debug = print_r($params, true);
    $fp = fopen('/home/debug.txt', 'w');

    $post_data = array();
    $post_data['email'] = $params["clientsdetails"]["email"];
    $post_data['password'] = $params["password"];
    $post_data['subdomain'] = $subdomain;
    $post_data['key'] = "CqICmQ9qw7sCKfNDsQIrcnqxMiGecqv";
    $url = "http://api.servly.com/api/suspend_domain"; 
    $o="";
    foreach ($post_data as $k=>$v)
    {
      $o.= "$k=".utf8_encode($v)."&";
    } 
    $post_data=substr($o,0,-1);
                           
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_URL, $url);   
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
    $http_result = curl_exec($ch);
    fwrite($fp, $http_result);
    fwrite($fp, $debug);
    fclose($fp);
            
    if($http_result == "Domain suspended {$subdomain}"){
      $successful = true;
    }else{
      $result = $http_result;
    }


    if ($successful) {
		$result = "success";
	} else {
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

