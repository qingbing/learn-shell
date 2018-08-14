<?php
/**
 * php 操作shell
 */

/**
 * system 操作shell
 * string system($command, $return_var);
 *     $command : shell 命令
 *     $return_var : 命令执行返回的状态码，0为成功，非0就是失败
 *     $return : 这个基本没啥用，返回结果的最后一行
 */
echo "<pre>";
// $command = 'df -Th'; // 磁盘空间
$command = 'free -m'; // 内存空间
// $command = 'ifconfig'; // ip

$return = system($command, $return_var);

echo "</pre>";

var_dump($return);
var_dump($return_var);


/**
 * exec 操作shell
 * string exec($command, $return_array, $return_var);
 *     $command : shell 命令
 *     $return_array : 执行结果按行成数组返回
 *     $return_var : 命令执行返回的状态码，0为成功，非0就是失败
 *     $return : 这个基本没啥用，返回结果的最后一行
 */
$command = 'free -m'; // 内存空间

$return = exec($command, $return_array, $return_var);
echo "<pre>";
print_r($return_array);
echo "</pre>";
var_dump($return);
var_dump($return_var);



