<?php

/**
 * 用户管理 : 查看，添加，删除，重设密码
 * 系统管理 ：系统平均负载，空间使用率，内存使用率
 * 重启系统 ，关闭系统 ：
 */

// 用户管理
// ls /home
// awk -F: '{print $1, $3, $4, $6, $7}' /etc/passwd
// useradd user1
// echo 123 | passwd --stdin user1
// userdel user1

// 系统管理
// uptime : 系统负载
// df -Th ：磁盘使用
// free -m ： 内存使用

// 重启系统 ： init 6
// 关闭系统 ： init 0


/**
 * php 操作shell
 */
function printArray ($array)
{
    echo "<pre>";
    print_r($array);
    echo "</pre>";
}

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

foreach ($homeUser as $value) {
    if(isset($allUser[$value])){
        print_r($allUser[$value]);
    }
}
exit;


// $command = 'whoami'; // 添加用户

// $return = exec($command, $return_array, $return_var);
// var_dump($return);

// $command = "id {$return}"; // 添加用户
// $return = exec($command, $return_array, $return_var);
// printArray($return_array);



// $command = 'sudo /usr/sbin/useradd user1'; // 添加用户
$command = 'sudo /usr/sbin/ifconfig'; // 添加用户
$return = exec($command, $return_array, $return_var);
printArray($return_array);
var_dump($return_var);


