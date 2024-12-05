<?php 

//print_r($_FILES);
require("conn.php");
require("function.php");
 $sql =  gen_sql($_POST);
$ress = $conn->query($sql);

if(!$ress){
	echo $conn->error;
}



$r = $ress->fetch_array();
$msg = explode("|",$r[0]);

if($msg[0] == "success"){
	$folder = "../uploads/";
$target = $folder .basename(@$_FILES['_image']['name']);
move_uploaded_file(@$_FILES['_image']['tmp_name'],$target);

}
echo $r[0];
?>