<?php 
function get_val($sql){
	require("conn.php");
	$ress = $conn->query($sql);
	$r = $ress->fetch_array();
	return $r[0];
}
function get_company($col){
	require("conn.php");
	$sql = "select $col from company";
	$ress = $conn->query($sql);
	$r = $ress->fetch_array();

	return $r[0];
}

function gen_sql($post){
$c = count($post);
$i = 0;
$sql = "call ";
foreach($post as $key => $val){
	$i++;

		if(is_array($val)){
	    $val = implode(",", $val);
	    }
	
	//$val = addslashes($val); 

	if($i == 1){
		$sql.= $val."(";
	}elseif($i == $c){
		$sql.= "'".$val."')";
	}else{
		$sql .= "'".$val."',";
	}
}

return $sql;
}


function get_dropdown($action){
	require("conn.php");
	$sql = "call get_dropdown_sp('$action')";
	$ress = $conn->query($sql);
	if(@$ress->num_rows > 0){
        while($row = $ress->fetch_array()){
        	?>
<option value="<?php echo $row[0] ?>"><?php echo $row[1] ?></option>

        	<?php
        }
	}else{
		echo "<option>No Data to display go to get_dropdown_sp and add action</option>";
	}
}

function checkbox_radio($type,$name,$required,$action){
	require("conn.php");
	$sql = "call get_dropdown_sp('$action')";
	$ress = $conn->query($sql);
	if(@$ress->num_rows > 0){
        while($row = $ress->fetch_array()){
        	?>

<label class="ui-<?php echo $type == 'checkbox' ? 'checkbox' : 'radio' ?> ui-<?php echo $type == 'checkbox' ? 'checkbox' : 'radio' ?>-inline">
 <input value="<?php echo $row[0] ?>" name="<?php echo $type == 'checkbox' ? $name.'[]' : $name ?>" type="<?php echo $type == 'checkbox' ? 'checkbox' : 'radio' ?>">
<span class="input-span"></span><?php echo $row[1] ?>
</label>
        	<?php
        }
	}else{
		echo "No Data to display";
	}
}
function table_row($ress){
	$col = $ress->fetch_fields();
?>
<thead>
	<tr>
		<?php 
		foreach($col as $columname){
			$k = explode("~",$columname->name);
		?>
         <th class="<?php echo @$k[1] ?>"><?php echo $k[0] ?></th>

		<?php 
	    }
		?>


	</tr>
</thead>



<tbody>
	<?php 
  while($row = $ress->fetch_assoc()){
  	?>
<tr>
	<?php 
foreach($row as $name =>$val){
	$q = explode("~",$name);
	if(@$q[1] == 'image'){
	?>
    <td <?php echo @$q[2] ?> class="<?php echo @$q[1] ?>">
    	<img style="width: 50px;" src="<?php echo $val ?>"></td>
<?php
}else{
		?>
    <td <?php echo @$q[2] ?> class="<?php echo @$q[1] ?>"><?php echo $val ?></td>
<?php
}
}
?>
</tr>


  	<?php 
  }
	?>
</tbody>
<?php

}
?>


