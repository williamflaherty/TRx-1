


// Should be executed anytime user navigates away from page
// and wishes their changes should be saved
function save_order(target_url,target_id) {
  var used_ids = []

  // is the following definitely in the right order?
  // maybe not, because of javascript asynchronous functions.
  // Is there an each method for only the first match?
  // Or some method that implies only one match exists?
  $('#stack li').each(function(j,i){
    if ($(this).attr(target_id) !== undefined) {
      used_ids[j] = $(this).attr(target_id)
    }
  });

  $('#super_option li').each(function(j,i){
    if ($(this).attr(target_id) !== undefined) {
      used_ids[j] = $(this).attr(target_id)
    }
  });

  // Couldn't get the following to work. Should have
  // been sorted, though.
  //user_ids = $('#stack').sortable('serialize')

  var dict = {"used_ids": used_ids}
  $.ajax({
    data: dict,
    type: 'POST',
    url: target_url,
  });

  return false; // to prevent page redirection
}


// Hackish, and doesn't really separate controller from view.
// Would be better if unselected color and selected color were
// stored in variables that were referenced by both the css and this
function update_selected(new_selected) {
  var previously_selected_item = $( "body" ).data("selected");
  if (previously_selected_item !== new_selected) {
      $( "body" ).data("selected", new_selected);
      new_selected.style.backgroundColor = 'green';
  } else if (previously_selected_item == new_selected) {
      $( "body" ).removeData("selected");
  }

  if (previously_selected_item !== undefined) {
    previously_selected_item.style.backgroundColor = 'lightgrey';
  }
}


function redirect_to_edit_page(target_url, form_source, target_id) {
  var currently_selected_item = $( "body" ).data("selected");
  if (currently_selected_item !== undefined) {
    console.log(currently_selected_item)
    
    form_source.action = target_url+(currently_selected_item.attributes[target_id].value)+'/'
      console.log(form_source.action);
    return true;
  } else {
    return false;
  }
}

function confirm_and_delete(target_url, form_source, target_id) {
  var retval = confirm("Are you sure you wish to delete?");
  if (retval == true) {
    redirect_to_edit_page(target_url,form_source, target_id);
  }
}



