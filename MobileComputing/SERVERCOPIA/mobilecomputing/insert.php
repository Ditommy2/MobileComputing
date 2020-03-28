<?php
$con = mysqli_connect('127.0.0.1:3306','root','', 'mobilecomputing') or die("Error connecting to database");;

$Name = $_GET['name'];
$Password = $_GET['password'];

$sql = "INSERT INTO user (Name,Password) VALUES ('$Name','$Password')";

mysqli_query($con,$sql) or die (mysqli_error($con));

?>
