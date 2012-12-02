// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function hide_agents(){
    jQuery('#linux').hide();
    jQuery('#bsd').hide();
    jQuery('#solaris').hide();
    jQuery('#osx').hide();
    jQuery('#windows').hide();
}

jQuery(document).ready(function(){
  jQuery('#service_service_type').change(function(){
    var mindex = jQuery('#service_service_type').val();
    if(mindex == 'server'){
      jQuery('#service_variable').empty();
      jQuery('#service_variable').append('Service variable from servly_services.py');
    }else if(mindex == 'tcp'){
      jQuery('#service_variable').empty();
      jQuery('#service_variable').append('Service TCP Port to check (Integer)');
    }
  });
});

function delete_server_service(server_id, id){
  if( confirm("Are you sure you want to delete this service monitor?") )
  {
    jQuery('.ss'+id).fadeOut();
    jQuery.post( '/servers/' + server_id + '/server_services/' + id,
            {
              type: 'POST',
              '_method': 'delete'
            }, function(data){   });
  }
}
