<?php 
require("conn.php");
extract($_POST);
 $sql = "call search_sp('$text','$action')";
$ress = $conn->query($sql);
if(@$ress->num_rows == 0){
	echo "<div>Not Found</div>";
	return false;
}
while($row = $ress->fetch_array()){
	?>

<li class="list-group-item" id="<?php echo $row[0] ?>"><?php echo $row[1] ?></li>
	<?php
}
?>




  <style type="text/css">
  	*{
  	margin: 0;
  	padding: 0;
  	}
  	.list-group-item:hover{
       cursor: pointer;
       background: #f2f2f2;
  	}
  </style>