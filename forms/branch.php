<?php 
session_start();

?>
<div class="row">
	<div style="margin: auto;" class="col-md-8">
                        <div class="ibox">
                            <div class="ibox-head">
                                <div class="ibox-title">Add Branch</div>
                             
                            </div>
                            <div class="ibox-body">
              <form class="form_data" action="tools/addbranch.php" method="post">
                               
                                    <div class="form-group">
                                        <label>Branch Name</label>
          <input class="form-control" name="a" type="text" placeholder="Enter branch Name">
                                    </div>


                                    <div class="form-group">
                                        <label>Branch Tell</label>
          <input class="form-control" name="b" type="text" placeholder="Enter Tell">
                                    </div>


                                    <div class="form-group">
                                        <label>Branch Address</label>
          <input class="form-control" name="c" type="text" placeholder="Enter Address">
                                    </div>


                                    <div class="form-group">
                                        <label>Branch Admin</label>
          <input class="form-control" name="d" type="text" placeholder="Enter Admin Name">
                                    </div>
                                
                                    <div class="form-group">
                                        <label>Admin Tell</label>
          <input class="form-control" name="e" type="text" placeholder="Enter Shift Name">
                                    </div>


                                    <div class="form-group">
                                        <label>Date</label>
          <input class="form-control" name="f" type="date" placeholder="Enter Shift Name">
                                    </div>
     <input type="hidden" value="<?php echo $_SESSION['user_id'] ?>" name="user_id">
                                    <div class="form-group">
                       <button class="btn btn-primary btn-block" type="submit">Save</button>
                                    </div>
                                </form>
                             <div>
                             	
                             </div>
                            </div>
                        </div>
                    </div>
</div>