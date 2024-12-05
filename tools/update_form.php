<div class="row">
<div  class="col-md-11">
<?php 
require("conn.php");
extract($_POST);
$sql = "call search_row('$action','$val')";
$ress  = $conn->query($sql);
$cols = @$ress->fetch_fields();
while(@$row = $ress->fetch_assoc()){

?>
<?php 
foreach($cols as $key){
	$k = explode("~",$key->name);
	$label = @$k[0];
	$type = @$k[1];
	if($type == "dropdown"){
?>

<form class="form_data update" action="insert_anny.php" method="post">

<div class="form-group">
<label><?php echo $label ?></label>
<select class="form-control">
	<option></option>
</select>
</div>
 </form>                            
 <?php
}else{
	?>
	<form class="form_data update" action="tools/insert_anny.php" method="post">

	<input type="hidden" name="sp" value="edit_sp">
	<input type="hidden" name="table" value="<?php echo $key->orgtable ?>">
	<input type="hidden" name="set_col" value="<?php echo $key->orgname ?>">
	<input type="hidden" name="wherecol" value="<?php echo $col ?>">
	<input type="hidden" name="val" value="<?php echo $val ?>">
<div class="row">
<div class="col-10">
	<div class="form-group">
<label><?php echo $label ?></label>
<input class="form-control update_field" value="<?php echo $row[$key->name] ?>" name="dd" type="<?php echo $type ?>" >
<input type="hidden" name="user_id" value="<?php echo $_SESSION['user_id'] ?>">
</div>
</div>

<div class="col-2">
	<button type="submit" style="margin-top: 30px" class="btn btn-primary hide update-btn" >Update</button>
</div>
</form>
</div>

	<?php
}
}
?>

<?php 
}
?>

  </div>
  	<div class="update_res"></div>
</div>



<style type="text/css">
	.hide{
		display: none;
	}
</style>