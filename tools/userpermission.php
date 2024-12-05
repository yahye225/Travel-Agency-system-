<?php 
session_start();
if($_POST['_user_id'] == '%'){
	echo "<div style='background: orange;padding: 10px;color: red'>Fadlan Doro User</div>";
	return false;
}

require("conn.php");
$sql = "call show_permission_sp($_POST[_user_id],'menu','')";
$ress = $conn->query($sql);

?>

<div class="row">
<?php 
while($row = $ress->fetch_array()){
	?>
	<div class="col-4 check">
		<?php echo $row['name'] ?>&nbsp;
			<input type="checkbox" class="check_all">
		<ul style="list-style: none">
		<?php 
require("conn.php");
  $sq = "call show_permission_sp($_POST[_user_id],'$row[action]',$row[id])";
$res = $conn->query($sq);
if($res){
	echo $conn->error;
}
while($r = $res->fetch_array()){
		?>
<li style="margin: 5px">
	<input class="save_permission" form_id="<?php echo $r['id'] ?>"
	       user_id="<?php echo $_POST['_user_id'] ?>"
	       granted="<?php echo $_SESSION['user_id'] ?>"
	       action="<?php echo $r['action'] ?>"
	<?php echo  $r['cb'] == 'checked' ? 'checked' : '' ?> type="checkbox" >&nbsp;<?php echo $r['name'] ?></li>

<?php 
}
?>
	</div>
<?php 
}
?>
</ul>
</div>