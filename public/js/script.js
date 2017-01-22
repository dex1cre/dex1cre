if (!localStorage["password"]) {
  var result = prompt("give me your password, bitch");

  if (result != "molodecmoloko123456789lolka123456789") {
    document.location.href = "/";
  }

  localStorage["password"] = true;
}