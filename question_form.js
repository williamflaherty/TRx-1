$(document).ready(function() {
  base_form = $('.initial_option').clone()
  $(':input', base_form).each(function() {
    var type = this.type;
    if (type == 'text') {
      this.value = "";
    }
  })


total_form_count = 0
  $('.option').each(function(d){ total_form_count+=1; });


function delete_callback() {
  total_form_count -= 1
  $(this).parents('.option').remove()

  $('.option').each(function(i,e) {
    $(this).children().children().each(function(){
      updateElementIndex(this, 'form', i)
    })
  });

  $("#id_" + 'form' + "-TOTAL_FORMS").val(total_form_count);
  return false;
}


if ($('#id_form-0-text').val() == '' && ($('#id_question_type') === 'fib' || $('#id_question_type').val() === '')) {
  $('#super_option').hide()
} else {
  console.log($('#id_form-0-text').val())
    console.log($('#id_question_type').val())
}

$('#id_question_type').change(function() {
  if ($(this).val() !== 'fib')  {
    $('#super_option').show()
  }
});


$('.delete').click(delete_callback);

$('#add').click(function() {
  type = $('#id_question_type').value;

  if (type != "fib") {
    form = $(base_form).clone()
  $(form).find('.delete').click(delete_callback)

  form.appendTo("#super_option")

  $(form).children().children().each(function() {
    updateElementIndex(this, 'form', total_form_count)
    $(this).val("");
  });

$("#id_" + 'form' + "-TOTAL_FORMS").val(total_form_count + 1);

total_form_count += 1
  }
  return false;
});


function updateElementIndex(el, prefix, i) {
  console.log("updating")
    var id_regex = new RegExp(prefix + '-\\d+-');
  var replacement = prefix + '-' + i + '-';
  if ($(el).attr("for")) $(el).attr("for", $(el).attr("for").replace(id_regex, replacement));
  if (el.id) el.id = el.id.replace(id_regex, replacement);
  if (el.name) el.name = el.name.replace(id_regex, replacement);
}


});
