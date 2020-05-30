<?php
$con = mysqli_connect('localhost','id13097986_supercafoni','2QM{-&[Yfev|J=Jk', 'id13097986_appmcdata') or die("Error connecting to database");;

$File = $_FILES['userfile']
$idfile = $_FILES['userfile']['name']
$temp = explode('$$', $_FILES['userfile']['name']);
$ext = $temp[1];

$sql = "INSERT INTO Partita (id,Giocatore, FilePartita) VALUES ('$idfile','$ext','$File')";

mysqli_query($con,$sql) or die (mysqli_error($con));

?>
