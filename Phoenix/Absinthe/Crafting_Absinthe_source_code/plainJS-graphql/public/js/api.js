function fetchMenuItems() {
  return window.fetch('http://localhost:4000/api', {
    method: 'POST',
    mode: 'cors',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({query: '{ menuItems { name price } }'})
  }).then(function(response) { return response.json(); });
}

function displayFetchError(response) {
  let element = document.createElement('p');
  element.innerHTML = 'API call failed.';
  console.error("fetch error", response);
  document.body.appendChild(element);
}

function displayMenuItems(result) {
  let element;
  if (result.errors) {
    element = document.createElement('p');
    element.innerHTML = 'NO MENU ITEMS';
    console.error("GraphQL errors", result.errors);
  } else if (result.data.menuItems) {
    element = document.createElement('ul');
    result.data.menuItems.forEach(function(item) {
      let itemElement = document.createElement('li');
      itemElement.innerHTML = item.name + " ($" + item.price + ")";
      element.appendChild(itemElement);
    });
  }
  document.body.appendChild(element);
}

document.addEventListener('DOMContentLoaded', () => fetchMenuItems()
                                                      .then(displayMenuItems)
                                                      .catch(displayFetchError)
);
