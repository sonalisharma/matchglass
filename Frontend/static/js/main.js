$( document ).ready(function() {
  
  console.log("ready");
  var fname = "";
  var bird_face = "";
$( "#button" ).click(function() {
	$( "#left" ).css("display","none");
	$( "#question" ).css("display","none");
	$( "#statusmsg" ).show(300);
  	$( "#colors" ).show(300);});

//$( "#sub" ).click(function() {
// 	console.log($('#fname').attr("name"));

 //});


	// jQuery('#form_oz').submit(function(evt){
	// 	evt.preventDefault();

	// 	//var val_fname = jQuery('#idfname').val();

	// 	console.log("fname:", fname);
	// });

});