$ ->
	$(".new-theme").click ->
		$(".form-div, .delete-this").hide()
		$(".form-div1").fadeIn(300)

	$(".find-theme").click ->
		$(".form-div, .delete-this").hide()
		$(".form-div2").fadeIn(300)

	$(".new-article").click ->
		$(".form-div, .delete-this").hide()
		$(".form-div3").fadeIn(300)

	$(".find-article").click ->
		$(".form-div, .delete-this").hide()
		$(".form-div4").fadeIn(300)

# Ajax запросы
##############

# Добавление темы
#################
	
	$("#new-theme").click ->
		$.ajax '/new_theme',
			type: "POST",
			data:
				new_theme_name: $("#new-theme-name").val()
				new_theme_discription: $("#new-theme-discription").val()
				image: $("#new-theme-image").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось добавить новую тему").delay(500).fadeOut(300)
			success: (data) ->
				$(".status-container .btn").fadeIn(300).text(data.data).delay(1000).fadeOut(500)

	$("#find-theme").click ->
		$.ajax '/find_theme',
			type: "POST",
			data:
				find_theme_text: $("#find-theme-text").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось найти тему").delay(500).fadeOut(300)
			success: (data) ->
				$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)
				$(".delete-this .title-theme").text(data.title)
				$(".delete-this p").text(data.description)
				$(".delete-this").fadeIn()

	$(".delete-btn1").click ->
		$.ajax '/remove_theme',
			type: "POST",
			data:
				new_theme_name: $("#find-theme-text").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось добавить новую тему").delay(500).fadeOut(300)
			success: (data) ->
				$(".status-container .btn").fadeIn(300).text(data.data).delay(1000).fadeOut(500)
				$(".delete-this .title-theme").text("")
				$(".delete-this p").text("")
				$(".delete-this").hide()

	$("#find-theme3").click ->
		$.ajax '/find_theme3',
			type: "POST",
			data:
				find_theme_text: $("#find-theme-text3").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось найти тему").delay(500).fadeOut(300)
			success: (data) ->
				$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)
				$(".theme-text3").text("Name of theme: " + data.title)

		$("#new-article").click ->
			alert("hello")
			$.ajax '/new_article',
				type: "POST",
				data:
					theme_name: $("#find-theme-text3").val()
					new_article_name: $("#new-article-name").val()
				error: ->
					$(".status-container .btn").fadeIn(300).text("Не удалось добавить новую тему").delay(500).fadeOut(300)
				success: (data) ->
					$(".status-container .btn").fadeIn(300).text(data.data).delay(1000).fadeOut(500)

	$("#find-theme2").click ->
		$.ajax '/find-theme2',
			type: "POST",
			data:
				theme_name: $("#find-theme-text2").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось добавить новую тему").delay(500).fadeOut(300)
			success: (data) ->
				$(".find-theme4").text(data.title)
				$(".id_theme").val(data.id)
				$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)

	$("#find-article2").click ->
		$.ajax '/find-article',
			type: "POST",
			data:
				article_name: $("#find-article-text2").val()
				id_theme: $(".id_theme").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось найти статью в данной теме").delay(500).fadeOut(300)
			success: (data) ->
				$(".find-article2").text(data.title)
				$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)
				$(".delete-this").fadeIn(300)

	$(".delete-btn2").click ->
		$.ajax '/remove_article',
			type: "POST",
			data:
				article_name: $("#find-article-text2").val()
				id_theme: $(".id_theme").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось удалить статью").delay(500).fadeOut(300)
			success: (data) ->
				if data.data == "Okay"
					$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)
					$(".find-article2").text()

	$(".btn-new-in-article").click ->
		if $(".check-image").prop("checked")
			v = "yes"
		else
			v = "no"
		$.ajax '/new_in_article',
			type: "POST"
			data:
				article_name: $("#find-article-text2").val()
				id_theme: $(".id_theme").val()
				checkbox: v
				content: $("#new-data").val()
			error: ->
				$(".status-container .btn").fadeIn(300).text("Не удалось удалить статью").delay(500).fadeOut(300)
			success: (data) ->
				if data.data == "Okay"
					$(".status-container .btn").fadeIn(300).text("Success!").delay(1000).fadeOut(500)
