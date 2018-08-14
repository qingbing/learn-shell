<?php
/**
 * 输出
 */
function output($data = [], $code = 0, $msg = "success")
{
    echo json_encode([
        'data' => $data,
        'code' => $code,
        'msg' => $msg,
    ]);
    exit;
}


$data = [];
$code = 0;
$msg = "success";
switch ($_GET['type']) {
    case 'reboot':
        $command = 'sudo init 6';
        exec($command, $return_array, $return_var);
        if (0 != $return_var) {
            $code = $return_var;
            $msg = 'reboot fail.';
        }
        break;
    case 'shutdown':
        $command = 'sudo init 0';
        exec($command, $return_array, $return_var);
        if (0 != $return_var) {
            $code = $return_var;
            $msg = 'shutdown fail.';
        }
        break;
    case 'addUser':
        $username = trim($_POST['username']);
        $password = trim($_POST['password']);
        if('' == $username || '' == $password) {
            $code = $return_var;
            $msg = '用户名和密码都不能为空.';
        } else {
            $command = "sudo useradd {$username}";
            exec($command, $return_array, $return_var);
            if (0 != $return_var) {
                $code = $return_var;
                $msg = 'add user fail.';
            } else {
                $command = "echo '{$password}' | sudo passwd --stdin {$username}";
                exec($command, $return_array, $return_var);
                if (0 != $return_var) {
                    $code = $return_var;
                    $msg = 'set password fail.';
                }
            }
        }
        break;
    case 'setPassword':
        $username = trim($_POST['username']);
        $password = trim($_POST['password']);
        if('' == $username || '' == $password) {
            $code = $return_var;
            $msg = '用户名和密码都不能为空.';
        } else {
            $command = "id {$username}";
            exec($command, $return_array, $return_var);
            if (0 != $return_var) {
                $code = $return_var;
                $msg = 'User is not exists.';
            } else {
                $command = "echo '{$password}' | sudo passwd --stdin {$username}";
                exec($command, $return_array, $return_var);
                if (0 != $return_var) {
                    $code = $return_var;
                    $msg = 'reset password fail.';
                }
            }
        }
        break;
    case 'deleteUser':
        $username = trim($_POST['id']);
        if('mysql' === $username){
            $code = 100;
            $msg = 'mysql cannot be deleted.';
        } else {
            $command = "sudo userdel -r {$username}";
            exec($command, $return_array, $return_var);
            if (0 != $return_var) {
                $code = $return_var;
                $msg = 'delete user fail.';
            }
        }
        break;
    case 'viewUser':
        $username = trim($_POST['id']);
        $command = "id {$username}";
        exec($command, $return_array, $return_var);
        if (0 != $return_var) {
            $code = $return_var;
            $msg = 'view user fail.';
        } else {
            $data = [
                'id' => $username,
                'info' => $return_array[0],
            ];
        }
        break;
    default:
            $code = 100;
            $msg = 'Unknown type.';
        break;
}
output($data, $code, $msg);
?>