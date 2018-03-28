$('body').on('change', 'input[type=checkbox]', function(event) {
  var checkbox = event.target;
  $.ajax({
    url: '/items/' + checkbox.getAttribute('id'),
    type: 'PATCH',
    data: {
      is_checked: checkbox.checked
    },
    error: function(result) {
      alert('Error saving changes to item');
      checkbox.checked = !checkbox.checked;
    }
  });
});

$('.add-shopping-list').on('click', function(event) {
  var $link = $(event.target);
  var name = window.prompt('What is the name of your new Shopping List?', '');
  if (!name) return;
  $.ajax({
    url: '/shopping_lists',
    type: 'POST',
    headers: {
      accept: 'text/html',
      'content-type': 'application/json; charset=UTF-8'
    },
    processData: false,
    data: JSON.stringify({
      name: name
    }),
    success: function(response) {
      $(response).insertBefore($link);
    },
    error: function(result) {
      alert('Error Adding new Shopping List');
    }
  });
});

$('body').on('click', '.add-item', function(event) {
  var $shoppingList = $(event.target).parents('.shopping-list-card');
  var itemName = window.prompt('What item do you want to add to your shopping list?', '');
  if (!itemName) return;
  $.ajax({
    url: '/items',
    type: 'POST',
    headers: {
      accept: 'text/html',
      'content-type': 'application/json; charset=UTF-8'
    },
    processData: false,
    data: JSON.stringify({
      name: itemName,
      shopping_list__id: $shoppingList.attr('id')
    }),
    success: function(response) {
      $shoppingList.find('ul').append(response);
    },
    error: function(result) {
      alert('Error Adding item');
    }
  });
});

$('body').on('click', '.delete-item', function(event) {
  var $button = $(event.target);
  var $checkbox = $button.siblings('input');
  $.ajax({
    url: '/items/' + $checkbox.attr('id'),
    type: 'DELETE',
    success: function() {
      $checkbox.parent().remove();
    },
    error: function(result) {
      alert('Error deleting item');
    }
  });
});

$('body').on('click', '.delete-list', function(event) {
  var $button = $(event.target);
  var $shoppingList = $button.parents('.shopping-list-card');
  $.ajax({
    url: '/shopping_lists/' + $shoppingList.attr('id'),
    type: 'DELETE',
    success: function() {
      $shoppingList.remove();
    },
    error: function(result) {
      alert('Error deleting shopping list');
    }
  });
});

