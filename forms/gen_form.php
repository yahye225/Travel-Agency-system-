<?php 
session_start();
require("../tools/function.php");
require("../tools/conn.php");
$sql = "select * from forms where id=$_GET[form_id]";
$ress= $conn->query($sql);
$f = $ress->fetch_array();
?>
<div class="row">
	<div style="margin: auto;" class="col-md-8">
                        <div class="ibox">
                            <div class="ibox-head">
                                <div class="ibox-title"><?php echo $f['name'] ?></div>
                             
                            </div>
                            <div class="ibox-body">
<form class="form_data" action="<?php echo $f['form_action'] ?>" method="post" enctype="multipart/form-data">

  <input type="hidden" name="sp" value="<?php echo $f['sp_name'] ?>">
<?php 
require("../tools/conn.php");
$sql1 = "select * from form_input where form_id=$_GET[form_id]";
$res = $conn->query($sql1);
while($row = $res->fetch_array()){
  extract($row);
  if($type == "user_id"){
?>
<input type="hidden" name="<?php echo $name ?>" value="<?php echo $_SESSION['user_id'] ?>">

<?php 
  }elseif($type == "dropdown"){
?>

<div class="form-group">
<label><?php echo $label ?></label>
<select class="form-control" name="<?php echo $name ?>">
  <option selected=" " disabled="">Chose One</option>
  <?php get_dropdown($action) ?>
</select>
</div>

<?php

}elseif($type == "search"){
?>
<div class="form-group">
<label><?php echo $label ?></label>
<input class="form-control search" action="<?php echo $action ?>" type="<?php echo $type ?>" placeholder="<?php echo $placeholder ?>">
<ul style="list-style: none" class="hide ">
  
</ul>
<input type="hidden" name="<?php echo $name ?>">

<style>
  .hide{
    display: none;
  }
</style>
</div>
<?php 
}else if($type == "file"){
?>
  <div class="form-group">
<label><?php echo $label ?></label>
<input type="hidden" class="set_path" name="<?php echo $name ?>">
<input class="form-control get_path " name="_image" type="<?php echo $type ?>" placeholder="<?php echo $placeholder ?>">
</div>
<?php
}else if($type == 'checkbox' || $type == 'radio'){

?>
<div class="form-group">
<label><?php echo $label ?></label><br>

<?php checkbox_radio($type,$name,$is_required,$action) ?>
</div>
<?php

}else{
?>
<div class="form-group">
<label><?php echo $label ?></label>
<input class="form-control " name="<?php echo $name ?>" type="<?php echo $type ?>" <?php echo $is_required ?> placeholder="<?php echo $placeholder ?>">
</div>
<?php 
}
}
?>                              
  <div class="form-group">
    <button class="btn btn-primary btn-block" type="submit"><?php echo $f['button'] ?></button>
  </div>
    </form>
  <div>
                             	
                             </div>
                            </div>
                        </div>
                    </div>
</div>

<script type="text/javascript">
  $("body").delegate(".get_path","change",function(){
   var path = $(this).val();

   $(".set_path").val('uploads/'+path.replace(/C:\\fakepath\\/, ''));
  })
</script>