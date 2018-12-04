<?php
// 從 gitlab 傳來的 token 資訊
$valid_token = '需要修改的token';
//var_dump($valid_token);
//这里填你的gitlab服务器ip , 需要修改, 可以加上擋 ip 的功能限制
$valid_ip = array('1111.229.232.183', '1111.33.201.242');
//var_dump($valid_ip);

$client_token = NULL;
if(isset($_SERVER['HTTP_X_GITLAB_TOKEN'])) {
  $client_token = $_SERVER['HTTP_X_GITLAB_TOKEN'];
  //var_dump($client_token);
}

$client_ip = NULL;
if(isset($_SERVER['REMOTE_ADDR'])) {
  $client_ip = $_SERVER['REMOTE_ADDR'];
  //var_dump($client_ip);
}

if(isset($_GET['debug']) AND $_GET['debug'] == 1) {
  $debug = 1;
}else{    
  if ($client_token !== $valid_token) die('Token mismatch!');
  if (!in_array($client_ip, $valid_ip)) die('Ip mismatch!');
}

// ?a=requ
if(isset($_GET['a']) AND $_GET['a'] == 'requ') {
    $WORKPWD="/usr/share/nginx/html/jutainetflow/requ/";
    $GITPWD ="/usr/share/nginx/html/jutainetflow/requ/.git/";
    $CMDLOG ="/usr/share/nginx/html/jutainetflow/webhook/update_requ.log 2>&1";
}elseif(isset($_GET['a']) AND $_GET['a'] == 'flow') {
    $WORKPWD="/usr/share/nginx/html/jutainetflow/flow/";
    $GITPWD ="/usr/share/nginx/html/jutainetflow/flow/.git/";
    $CMDLOG ="/usr/share/nginx/html/jutainetflow/webhook/update_flow.log 2>&1";    
}elseif(isset($_GET['a']) AND $_GET['a'] == 'stru') {
    $WORKPWD="/usr/share/nginx/html/jutainetflow/stru/";
    $GITPWD ="/usr/share/nginx/html/jutainetflow/stru/.git/";
    $CMDLOG ="/usr/share/nginx/html/jutainetflow/webhook/update_stru.log 2>&1";    
}elseif(isset($_GET['a']) AND $_GET['a'] == 'case') {    
    $WORKPWD="/usr/share/nginx/html/jutainetflow/case/";
    $GITPWD ="/usr/share/nginx/html/jutainetflow/case/.git/";
    $CMDLOG ="/usr/share/nginx/html/jutainetflow/webhook/update_case.log 2>&1";    
}else{
    die('Webhook error!!');
}

// run git cmd
$GITCMD ="/usr/bin/git";
$CMDDATE= date(DATE_RFC2822);

$systemcmd = "echo '$CMDDATE' > $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$ss = json_encode($_SERVER);
$systemcmd = "echo '$ss' >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$systemcmd = "$GITCMD --git-dir=$GITPWD --work-tree=$WORKPWD status >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$systemcmd = "$GITCMD --git-dir=$GITPWD --work-tree=$WORKPWD fetch origin master >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$systemcmd = "$GITCMD --git-dir=$GITPWD --work-tree=$WORKPWD merge FETCH_HEAD >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$systemcmd = "$GITCMD --git-dir=$GITPWD --work-tree=$WORKPWD log -n 1 >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

$systemcmd = "$GITCMD --git-dir=$GITPWD --work-tree=$WORKPWD status >> $CMDLOG ;";
echo $systemcmd."\n";
system($systemcmd);

echo 'ok done.';
?>
