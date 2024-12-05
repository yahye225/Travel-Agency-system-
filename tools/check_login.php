<?php 
session_start();
require("conn.php");
extract($_POST);
$sql = "call login_sp('$username','$password')";
$ress = $conn->query($sql);
$r = $ress->fetch_array();

if($r['error']){
	header("location: ../index.php?error= $r[0]");
}else{
	
	foreach($r as $name => $value){
     $_SESSION[$name] = $value;
	}


	header("location: ../home.php");
}
?>