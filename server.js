// Generated by CoffeeScript 1.12.2
(function() {
  var app, bodyParser, data, db, express, lSt, server, sqlite3;

  express = require("express");

  bodyParser = require("body-parser");

  lSt = require("localStorage");

  sqlite3 = require("sqlite3").verbose();

  db = new sqlite3.Database("sqlite.db");

  app = express();

  app.use(bodyParser.urlencoded({
    extended: true
  }));

  app.use(bodyParser.json());

  app.disable("x-powered-by");

  app.use(express["static"](__dirname + '/public'));

  app.set("view engine", "pug");

  data = {
    "/": "pages/index",
    "/theme/:id": "pages/theme",
    "/registration": "pages/registration",
    "/qCDA7w": "pages/admin"
  };

  app.route("/").get(function(req, res) {
    var login, password;
    console.log(lSt.getItem("login"));
    if (lSt.getItem("login")) {
      login = lSt.getItem("login");
    } else {
      login = "";
    }
    if (lSt.getItem("password")) {
      password = lSt.getItem("password");
    } else {
      password = "";
    }
    return db.serialize(function() {
      return db.all("SELECT * FROM themes", function(err, row) {
        var user;
        if (login !== "" && password !== "") {
          user = true;
        } else {
          user = false;
        }
        if (!err) {
          console.log(user);
          res.render("pages/index", {
            themes: row,
            user: user,
            login: login
          });
        }
        if (err) {
          return console.log(err);
        }
      });
    });
  }).post(function(req, res) {
    var login, password;
    login = req.body.login;
    password = req.body.password;
    if (login === "" || password === "") {
      res.send("<p> Пожалуйста заполните поля login и пароль, прежде чем нажимать кнопку ВОЙТИ! Ты же это и так понимаешь, что тупить то?</p>");
    }
    return db.serialize(function() {
      return db.all("SELECT * FROM users WHERE (login=$login) AND (password=$password)", {
        $login: login,
        $password: password
      }, function(err, rows) {
        if (err) {
          return console.log(err);
        } else if (!rows[0]) {
          return res.send("<p>Тут что-то не то... Введён либо неверный логин, либо неверный пароль, либо вы вообще не зарегестрированны и просто пытаетесь взломать какого-то пользователя, чтобы пошутить, ах хитрец. Так поступать нельзя, как тебе совесть то позволяет, кошмар какой! Ух!</p>");
        } else {
          lSt.setItem("login", login);
          lSt.setItem("password", password);
          return res.redirect("/");
        }
      });
    });
  });

  app.get("/getBack", function(req, res) {
    lSt.removeItem("login");
    lSt.removeItem("password");
    return res.redirect("/");
  });

  app.route("/theme/:name/:id").get(function(req, res) {
    var id, login, name, password;
    name = req.params.name;
    id = req.params.id;
    if (lSt.getItem("login")) {
      login = lSt.getItem("login");
    } else {
      login = "";
    }
    if (lSt.getItem("password")) {
      password = lSt.getItem("password");
    } else {
      password = "";
    }
    console.log("to theme with number " + id + " and name " + name);
    return db.serialize(function() {
      return db.each("SELECT * FROM articles WHERE id_theme=$id ORDER BY id DESC", {
        $id: id
      }, function(err, rows) {
        return db.each("SELECT images FROM themes WHERE title=$name", {
          $name: name
        }, function(err, row) {
          return db.all("SELECT * FROM articles WHERE id_theme=$id_theme", {
            $id_theme: id
          }, function(err, ro) {
            return db.all("SELECT * FROM content WHERE article_id=$id", {
              $id: rows.id
            }, function(err, r) {
              var user;
              if (err) {
                console.log(err);
              }
              if (login !== "" && password !== "") {
                user = true;
              } else {
                user = false;
              }
              return res.render("pages/theme", {
                article: rows,
                name_theme: name,
                img: row.images,
                articles: ro,
                content: r,
                user: user
              });
            });
          });
        });
      });
    });
  }).post(function(req, res) {
    var id, login, name, password;
    name = req.params.name;
    id = req.params.id;
    login = req.body.login;
    password = req.body.password;
    if (login === "" || password === "") {
      res.send("<p> Пожалуйста заполните поля login и пароль, прежде чем нажимать кнопку ВОЙТИ! Ты же это и так понимаешь, что тупить то?</p>");
    }
    return db.serialize(function() {
      return db.all("SELECT * FROM users WHERE (login=$login) AND (password=$password)", {
        $login: login,
        $password: password
      }, function(err, rows) {
        if (err) {
          return console.log(err);
        } else if (!rows[0]) {
          return res.send("<p>Тут что-то не то... Введён либо неверный логин, либо неверный пароль, либо вы вообще не зарегестрированны и просто пытаетесь взломать какого-то пользователя, чтобы пошутить, ах хитрец. Так поступать нельзя, как тебе совесть то позволяет, кошмар какой! Ух!</p>");
        } else {
          lSt.setItem("login", login);
          lSt.setItem("password", password);
          return res.redirect("/theme/" + name + "/" + id);
        }
      });
    });
  });

  app.get("/theme/:name/:id/:id_article", function(req, res) {
    var id, id_article, name;
    name = req.params.name;
    id = req.params.id;
    id_article = req.params.id_article;
    console.log("to theme with number " + id + " and name " + name);
    return db.serialize(function() {
      return db.each("SELECT * FROM articles WHERE id_theme=$id ORDER BY id DESC", {
        $id: id
      }, function(err, rows) {
        return db.each("SELECT images FROM themes WHERE title=$name", {
          $name: name
        }, function(err, row) {
          return db.all("SELECT * FROM articles WHERE id=$id_article", {
            $id_article: id_article
          }, function(err, ro) {
            return db.all("SELECT * FROM content WHERE article_id=$id", {
              $id: rows.id
            }, function(err, r) {
              if (err) {
                console.log(err);
              }
              return res.render("pages/theme", {
                article: rows,
                name_theme: name,
                img: row.images,
                articles: ro,
                content: r
              });
            });
          });
        });
      });
    });
  });

  app.route("/registration").get(function(req, res) {
    return res.render("pages/registration");
  }).post(function(req, res) {
    var login, password, repeat_password;
    login = req.body.login;
    password = req.body.password;
    repeat_password = req.body.repeat_password;
    return db.serialize(function() {
      console.log(login);
      return db.all("SELECT * FROM users WHERE login=$login", {
        $login: login
      }, function(err, rows) {
        var t;
        if (err) {
          console.log(err);
          return res.send("error");
        } else if (!rows[0]) {
          if (password === repeat_password) {
            db.run("INSERT INTO users(login, password) VALUES($login, $password)", {
              $login: login,
              $password: password
            }, function(err) {
              return console.log(err);
            });
            t = '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">' + '<div class="container">' + ("<h2>Ваши данные</h2>login: " + login + " <br>password: " + password + " <br> <a href=\"/\" class=\"btn btn-primary\">на гавную</a>") + '<div class="container"';
            return res.send(t);
          } else {
            return res.send("пароли не совпадают");
          }
        } else {
          return res.send('<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">' + '<div class="container">' + 'логин не доступен, потому что... потому<br> <a href="/registration" class="btn btn-default">Назад к регистрации</a>' + '</div>');
        }
      });
    });
  });

  app.get("/qCDA7w", function(req, res) {
    return res.render("pages/admin");
  });

  app.post("/new_theme", function(req, res) {
    var description_theme, image, name_theme;
    name_theme = req.body.new_theme_name;
    description_theme = req.body.new_theme_discription;
    image = req.body.image;
    db.serialize(function() {
      return db.run("INSERT INTO themes(title, description, images) VALUES ($title, $description, $image)", {
        $title: name_theme,
        $description: description_theme,
        $image: image
      }, function(err) {
        return console.log("hey!new_posts --> " + err);
      });
    });
    return res.json({
      data: "Okay"
    });
  });

  app.post("/find_theme", function(req, res) {
    return db.serialize(function() {
      return db.each("SELECT * FROM themes WHERE title=$name", {
        $name: req.body.find_theme_text
      }, function(err, rows) {
        res.json({
          title: rows.title,
          description: rows.description
        });
        return console.log("hey!finde some theme " + err);
      });
    });
  });

  app.post("/remove_theme", function(req, res) {
    db.serialize(function() {
      return db.run("DELETE FROM themes WHERE title=$name", {
        $name: req.body.new_theme_name
      }, function(err) {
        return console.log("hey!new_posts --> " + err);
      });
    });
    return res.json({
      data: "Okay"
    });
  });

  app.post("/find_theme3", function(req, res) {
    return db.serialize(function() {
      return db.each("SELECT * FROM themes WHERE title=$name", {
        $name: req.body.find_theme_text
      }, function(err, rows) {
        res.json({
          title: rows.title
        });
        return console.log("hey!finde some theme " + rows.title);
      });
    });
  });

  app.post("/new_article", function(req, res) {
    var d;
    d = new Date;
    return db.serialize(function() {
      return db.each("SELECT id FROM themes WHERE title=$name", {
        $name: req.body.theme_name
      }, function(err, row) {
        db.run("INSERT INTO articles(title, dtime, id_theme) VALUES ($title, $dtime, $id_theme)", {
          $title: req.body.new_article_name,
          $dtime: (d.getDate()) + ":" + (d.getMonth() + 1) + ":" + (d.getFullYear()),
          $id_theme: row.id
        }, function(err) {
          return console.log("hey!new article --> " + err);
        }, res.json({
          data: "Okay"
        }));
        if (err) {
          console.log("hey!can't to find id of theme!");
        }
        return console.log("hey!can't all right!");
      });
    });
  });

  app.post("/find-theme2", function(req, res) {
    return db.serialize(function() {
      return db.each("SELECT title, id FROM themes WHERE title=$name", {
        $name: req.body.theme_name
      }, function(err, row) {
        res.json({
          title: row.title,
          id: row.id
        });
        if (err) {
          return console.log("hey! -- > " + err);
        }
      });
    });
  });

  app.post("/find-article", function(req, res) {
    return db.serialize(function() {
      return db.each("SELECT * FROM articles WHERE title=$name AND id_theme=$id", {
        $name: req.body.article_name,
        $id: req.body.id_theme
      }, function(err, row) {
        if (err) {
          console.log(err);
        }
        return res.json({
          title: row.title,
          id: row.id
        });
      });
    });
  });

  app.post("/remove_article", function(req, res) {
    return db.serialize(function() {
      return db.run("DELETE FROM articles WHERE title=$name AND id_theme=$id", {
        $name: req.body.article_name,
        $id: req.body.id_theme
      }, function(err) {
        if (err) {
          console.log(err);
        }
        return res.json({
          data: "Okay"
        });
      });
    });
  });

  app.post("/new_in_article", function(req, res) {
    return db.serialize(function() {
      return db.each("SELECT id FROM articles WHERE title=$name AND id_theme=$id", {
        $name: req.body.article_name,
        $id: req.body.id_theme
      }, function(err, row) {
        var id, status;
        if (err) {
          console.log(err);
        }
        id = row.id;
        if (req.body.checkbox === "yes") {
          status = 1;
        } else if (req.body.checkbox === "1") {
          status = 2;
        } else if (req.body.checkbox === "3") {
          status = 3;
        } else if (req.body.checkbox === "no") {
          status = 0;
        }
        return db.run("INSERT INTO content(content, article_id, status) VALUES($content, $article_id, $status)", {
          $content: req.body.content,
          $article_id: id,
          $status: status
        }, function(err) {
          if (err) {
            console.log(err);
          }
          return res.json({
            data: "Okay"
          });
        });
      });
    });
  });

  server = app.listen(80, function() {
    return console.log("Server is started on port 8080");
  });

}).call(this);
