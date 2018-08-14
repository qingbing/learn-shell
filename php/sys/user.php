<?php include("head.php");?>
<?php
function getHomeUser()
{
    $command = "ls /home";
    $return = exec($command, $return_array, $return_var);
    return $return_array;
}

function getAllUser ()
{
    $command = "awk -F: '{print $1, $3, $4, $6, $7}' /etc/passwd";
    $return = exec($command, $return_array, $return_var);
    $R = [];
    foreach ($return_array as $value) {
        $ta = explode(' ', $value);
        $R[$ta[0]] = $ta;
    }
    return $R;
}

// /etc/passwd 下用户信息
$allUser = getAllUser();

// 根目录下用户
$homeUser = getHomeUser();
?>

<p><button class="btn btn-primary" id="addUser">Add</button></p>
<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <tr>
            <th>Username</th>
            <th>Uid</th>
            <th>Gid</th>
            <th>Home</th>
            <th>Login shell</th>
            <th>Operate</th>
        </tr>
        <?php foreach ($homeUser as $name) {
            if(!isset($allUser[$name])){
                continue;
            }
            $user = $allUser[$name];
        ?>
        <tr data-id="<?php echo $user[0]; ?>">
            <td><?php echo $user[0]; ?></td>
            <td><?php echo $user[1]; ?></td>
            <td><?php echo $user[2]; ?></td>
            <td><?php echo $user[3]; ?></td>
            <td><?php echo $user[4]; ?></td>
            <td>
                <a href="#" class="btn btn-info btn-xs viewUser">View</a>
                <a href="#" class="btn btn-warning btn-xs resetPassword">Reset password</a>
                <a href="#" class="btn btn-danger btn-xs deleteUser">Delete</a>
            </td>
        </tr>
        <?php
}
?>
    </table>
</div>

<div class="modal fade" id="userAddModal" role="dialog">
    <div class="modal-dialog" role="document" aria-hidden="true">
        <form action="#" class="form-horizontal" id="addUserForm">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="close" data-dismiss="modal">&times;</div>
                    <h3 class="modal-title">Add User</h3>
                </div>
                <div class="modal-body">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-group">
                                <label>username : </label>
                                <input type="text" name="username" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>password : </label>
                                <input type="text" name="password" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="addUserSave">Save User</button>
                    <button type="button" class="btn btn-warning" data-dismiss="modal">Close</button>
                </div>
            </div>
        </form>
    </div>
</div>
<div class="modal fade" id="resetPasswordModal" role="dialog">
    <div class="modal-dialog" role="document" aria-hidden="true">
        <form action="#" class="form-horizontal" id="setPasswordForm">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="close" data-dismiss="modal">&times;</div>
                    <h3 class="modal-title">Reset Password</h3>
                </div>
                <div class="modal-body">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-group">
                                <label>username : </label>
                                <div class="form-control-static" id="setPassword-view-username"></div>
                                <input type="hidden" name="username" id="setPassword-username">
                            </div>
                            <div class="form-group">
                                <label>password : </label>
                                <input type="text" name="password" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="resetPasswordSave">Save</button>
                    <button type="button" class="btn btn-warning" data-dismiss="modal">Close</button>
                </div>
            </div>
        </form>
    </div>
</div>
<div class="modal fade" id="viewModal" role="dialog">
    <div class="modal-dialog" role="document" aria-hidden="true">
        <form action="#" class="form-horizontal">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="close" data-dismiss="modal">&times;</div>
                    <h3 class="modal-title">View User</h3>
                </div>
                <div class="modal-body">
                    <div class="panel">
                        <div class="panel-body">
                            <div class="form-group">
                                <label>username : </label>
                                <div class="form-control-static" id="view-username"></div>
                            </div>
                            <div class="form-group">
                                <label>Information </label>
                                <div class="form-control-static"><pre id="view-info"></pre></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal">Close</button>
                </div>
            </div>
        </form>
    </div>
</div>


<script type="text/javascript">
    (function ($) {
        // 添加按钮弹出框
        $('#addUser').on('click', function () {
            $('#addUserForm')[0].reset();
            $('#userAddModal').modal("show");
            return false;
        });
        // 添加用户
        $('#addUserSave').on('click', function () {
            $.post('ajax.php?type=addUser', $('#addUserForm').serialize(), function (rs) {
                if (0 === rs.code) {
                    alert("add user success.");
                    window.location.reload();
                } else {
                    alert(rs.msg);
                }
            }, 'json');
            return false;
        });
        // 重置密码弹出框
        $('.resetPassword').on('click', function () {
            $('#setPasswordForm')[0].reset();
            var id = $(this).closest('tr').data('id');
            $('#setPassword-view-username').text(id);
            $('#setPassword-username').val(id);
            $('#resetPasswordModal').modal("show");
            return false;
        });
        // 重置密码
        $('#resetPasswordSave').on('click', function () {
            $.post('ajax.php?type=setPassword', $('#setPasswordForm').serialize(), function (rs) {
                if (0 === rs.code) {
                    alert("set password success.");
                    $('#resetPasswordModal').modal("hide");
                } else {
                    alert(rs.msg);
                }
            }, 'json');
            return false;
        });
        // 查看用户弹出框
        $('.viewUser').on('click', function () {
            var id = $(this).closest('tr').data('id');
            $.post('ajax.php?type=viewUser', {id : id}, function (rs) {
                if (0 === rs.code) {
                    $('#view-username').text(rs.data.id);
                    $('#view-info').text(rs.data.info);
                } else {
                    alert(rs.msg);
                }
            }, 'json');

            $('#viewModal').modal("show");
            return false;
        });
        // 删除用户
        $('.deleteUser').on('click', function () {
            var id = $(this).closest('tr').data('id');
            if (window.confirm("Are you sure you want to delete the user!")) {
                $.post('ajax.php?type=deleteUser', {id : id}, function (rs) {
                    if (0 === rs.code) {
                        alert("delete user success.");
                        window.location.reload();
                    } else {
                        alert(rs.msg);
                    }
                }, 'json');
            }
            return false;
        });
    })(jQuery);
</script>

<?php include("foot.php");?>