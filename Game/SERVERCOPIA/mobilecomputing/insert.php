<?php
$conn = new mysqli("localhost", "id13097986_supercafoni", "2QM{-&[Yfev|J=Jk", "id13097986_appmcdata") or die("Error connecting to database");

$Name = $_GET['name'];
$Password = $_GET['password'];

$sql = "INSERT INTO Utente (username,password) VALUES ('" . $Name . "', '" . $Password . "')";

mysqli_query($conn,$sql) or die (mysqli_error($conn));

?>
