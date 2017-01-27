#Подключаем модули и создаём окружение
######################################
express = require "express"
bodyParser = require "body-parser"
lSt = require "localStorage"
sqlite3 = require("sqlite3").verbose()
db = new sqlite3.Database "sqlite.db"
app = express()

#Настраиваем окружение
######################
app.use bodyParser.urlencoded 
	extended: true
app.use bodyParser.json()

app.disable "x-powered-by"

app.use express.static __dirname + '/public'
app.set "view engine", "pug"

# Страницы
##########

data = {
	"/": "pages/index",
	"/theme/:id": "pages/theme",
	"/registration": "pages/registration",
	"/qCDA7w": "pages/admin"
}

#Маршрутизация
##############
app.route "/"
	.get (req, res) ->
		console.log lSt.getItem "login"
		if lSt.getItem "login"
			login = lSt.getItem "login"
		else
			login = ""

		if lSt.getItem "password"
			password = lSt.getItem "password"
		else
			password = ""
		db.serialize ->
			db.all "SELECT * FROM themes", (err, row) ->
				if login != "" and password != ""
					user = true
				else
					user = false

				if !err
					console.log user
					res.render "pages/index", 
						themes: row
						user: user
						login: login

				console.log err if err
	.post (req, res) ->
		login = req.body.login
		password = req.body.password
		if login == "" or password == ""
			res.send "<p> Пожалуйста заполните поля login и пароль, прежде чем нажимать кнопку ВОЙТИ! Ты же это и так понимаешь, что тупить то?</p>"
		db.serialize ->
			db.all "SELECT * FROM users WHERE (login=$login) AND (password=$password)",
				$login: login
				$password: password
				, (err, rows) ->
					if err
						console.log err
					else if !rows[0]
						res.send "<p>Тут что-то не то... Введён либо неверный логин, либо неверный пароль, либо вы вообще не зарегестрированны и просто пытаетесь взломать какого-то пользователя, чтобы пошутить, ах хитрец. Так поступать нельзя, как тебе совесть то позволяет, кошмар какой! Ух!</p>"
					else
						lSt.setItem "login", login
						lSt.setItem "password", password
						res.redirect "/"

app.get "/getBack", (req, res) ->
	lSt.removeItem "login"
	lSt.removeItem "password"
	res.redirect "/"

app.route "/theme/:name/:id"
	.get (req, res) ->
		name = req.params.name
		id = req.params.id
		if lSt.getItem "login"
			login = lSt.getItem "login"
		else
			login = ""

		if lSt.getItem "password"
			password = lSt.getItem "password"
		else
			password = ""
		console.log "to theme with number #{id} and name #{name}"
		db.serialize ->
			db.each "SELECT * FROM articles WHERE id_theme=$id ORDER BY id DESC",
				$id: id
				, (err, rows) ->
					db.each "SELECT images FROM themes WHERE title=$name",
						$name: name
						, (err, row) ->
							db.all "SELECT * FROM articles WHERE id_theme=$id_theme",
								$id_theme: id
								, (err, ro) ->
									db.all "SELECT * FROM content WHERE article_id=$id",
										$id: rows.id
										, (err, r) ->
											if err
												console.log err

											if login != "" and password != ""
												user = true
											else
												user = false

											res.render "pages/theme",
												article: rows
												name_theme: name
												img: row.images
												articles: ro
												content: r
												user: user

	.post (req, res) ->
		name = req.params.name
		id = req.params.id
		login = req.body.login
		password = req.body.password
		if login == "" or password == ""
			res.send "<p> Пожалуйста заполните поля login и пароль, прежде чем нажимать кнопку ВОЙТИ! Ты же это и так понимаешь, что тупить то?</p>"
		db.serialize ->
			db.all "SELECT * FROM users WHERE (login=$login) AND (password=$password)",
				$login: login
				$password: password
				, (err, rows) ->
					if err
						console.log err
					else if !rows[0]
						res.send "<p>Тут что-то не то... Введён либо неверный логин, либо неверный пароль, либо вы вообще не зарегестрированны и просто пытаетесь взломать какого-то пользователя, чтобы пошутить, ах хитрец. Так поступать нельзя, как тебе совесть то позволяет, кошмар какой! Ух!</p>"
					else
						lSt.setItem "login", login
						lSt.setItem "password", password
						res.redirect "/theme/" + name + "/" + id

app.rout "/theme/:name/:id/:id_article"
	.get (req, res) ->
		name = req.params.name
		id = req.params.id
		id_article = req.params.id_article
		console.log "to theme with number #{id} and name #{name}"
		db.serialize ->
			db.each "SELECT * FROM articles WHERE id=$id_article",
				$id_article: id_article
				, (err, rows) ->
					db.each "SELECT images FROM themes WHERE title=$name",
						$name: name
						, (err, row) ->
							db.all "SELECT * FROM articles WHERE id_theme=$id_theme",
								$id_theme: id
								, (err, ro) ->
									db.all "SELECT * FROM content WHERE article_id=$id",
										$id: rows.id
										, (err, r) ->
											if err
												console.log err
											res.render "pages/theme",
												article: rows
												name_theme: name
												img: row.images
												articles: ro
												content: r
	.post (req, res) ->
		name = req.params.name
		id = req.params.id
		login = req.body.login
		password = req.body.password
		if login == "" or password == ""
			res.send "<p> Пожалуйста заполните поля login и пароль, прежде чем нажимать кнопку ВОЙТИ! Ты же это и так понимаешь, что тупить то?</p>"
		db.serialize ->
			db.all "SELECT * FROM users WHERE (login=$login) AND (password=$password)",
				$login: login
				$password: password
				, (err, rows) ->
					if err
						console.log err
					else if !rows[0]
						res.send "<p>Тут что-то не то... Введён либо неверный логин, либо неверный пароль, либо вы вообще не зарегестрированны и просто пытаетесь взломать какого-то пользователя, чтобы пошутить, ах хитрец. Так поступать нельзя, как тебе совесть то позволяет, кошмар какой! Ух!</p>"
					else
						lSt.setItem "login", login
						lSt.setItem "password", password
						res.redirect "/theme/" + name + "/" + id

app.route "/registration"
	.get (req, res) ->
		res.render "pages/registration"
	.post (req, res) ->
		login = req.body.login
		password = req.body.password
		repeat_password = req.body.repeat_password
		db.serialize ->
			console.log login
			db.all "SELECT * FROM users WHERE login=$login",
				$login: login
				, (err, rows) ->
					if err
						console.log err
						res.send "error"
					else if !rows[0]
						if password == repeat_password
							db.run "INSERT INTO users(login, password) VALUES($login, $password)",
								$login: login
								$password: password
								, (err) ->
									console.log err
							t = '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">' + '<div class="container">' + "<h2>Ваши данные</h2>login: #{login} <br>password: #{password} <br> <a href=\"/\" class=\"btn btn-primary\">на гавную</a>" + '<div class="container"'
							res.send t
						else
							res.send "пароли не совпадают"
					else
						res.send '<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">' + '<div class="container">' + 'логин не доступен, потому что... потому<br> <a href="/registration" class="btn btn-default">Назад к регистрации</a>' + '</div>'

app.get "/qCDA7w", (req, res) ->
		res.render "pages/admin"

#Работа с админ панелью
#######################
app.post "/new_theme", (req, res) ->
	name_theme = req.body.new_theme_name
	description_theme = req.body.new_theme_discription
	image = req.body.image

	db.serialize ->
		db.run "INSERT INTO themes(title, description, images)
			VALUES ($title, $description, $image)",
			$title: name_theme
			$description: description_theme
			$image: image
			, (err) ->
				console.log "hey!new_posts --> #{err}"
	res.json
		data: "Okay"

app.post "/find_theme", (req, res) ->
	db.serialize ->
		db.each "SELECT * FROM themes WHERE title=$name",
			$name: req.body.find_theme_text
			, (err, rows) ->
				res.json 
					title: rows.title
					description: rows.description
				console.log "hey!finde some theme #{err}"

app.post "/remove_theme", (req, res) ->
	db.serialize ->
		db.run "DELETE FROM themes WHERE title=$name",
			$name: req.body.new_theme_name
			, (err) ->
				console.log "hey!new_posts --> #{err}"
	res.json
		data: "Okay"

app.post "/find_theme3", (req, res) ->
	db.serialize ->
		db.each "SELECT * FROM themes WHERE title=$name",
			$name: req.body.find_theme_text
			, (err, rows) ->
				res.json 
					title: rows.title
				console.log "hey!finde some theme #{rows.title}"

app.post "/new_article", (req, res) ->
	d = new Date
	db.serialize ->
		db.each "SELECT id FROM themes WHERE title=$name",
			$name: req.body.theme_name
			, (err, row) ->
				db.run "INSERT INTO articles(title, dtime, id_theme)
					VALUES ($title, $dtime, $id_theme)",
					$title: req.body.new_article_name
					$dtime: "#{d.getDate()}:#{d.getMonth() + 1}:#{d.getFullYear()}"
					$id_theme: row.id
					, (err) ->
						console.log "hey!new article --> #{err}"
					res.json
						data: "Okay"
				console.log "hey!can't to find id of theme!" if err
				console.log "hey!can't all right!"

app.post "/find-theme2", (req, res) ->
	db.serialize ->
		db.each "SELECT title, id FROM themes WHERE title=$name",
			$name: req.body.theme_name
			, (err, row) ->
				res.json
					title: row.title
					id: row.id
				console.log "hey! -- > #{err}" if err
				# console.log "hey! -- > #{row.title}"

app.post "/find-article", (req, res) ->
	db.serialize ->
		db.each "SELECT * FROM articles WHERE title=$name AND id_theme=$id",
			$name: req.body.article_name
			$id: req.body.id_theme
			, (err, row) ->
				if err
					console.log err
				res.json
					title: row.title
					id: row.id

app.post "/remove_article", (req, res) ->
	db.serialize ->
		db.run "DELETE FROM articles WHERE title=$name AND id_theme=$id",
			$name: req.body.article_name
			$id: req.body.id_theme
			, (err) ->
				if err
					console.log err
				res.json
					data: "Okay"

app.post "/new_in_article", (req, res) ->
	db.serialize ->
		db.each "SELECT id FROM articles WHERE title=$name AND id_theme=$id",
			$name: req.body.article_name
			$id: req.body.id_theme
			, (err, row) ->
				if err
					console.log err
				id = row.id
				if req.body.checkbox == "yes"
					status = 1
				else if req.body.checkbox == "1"
					status = 2
				else if req.body.checkbox == "3"
					status = 3
				else if req.body.checkbox == "no"
					status = 0
				db.run "INSERT INTO content(content, article_id, status)
					VALUES($content, $article_id, $status)",
					$content: req.body.content
					$article_id: id
					$status: status
					, (err) ->
						if err
							console.log err
						res.json
							data: "Okay"

server = app.listen 80, ->
	console.log "Server is started on port 8080"