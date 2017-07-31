document.addEventListener("turbolinks:load", function() {
    $input = $("[data-behavior='autocomplete']")

    var options = {
        getValue: "name",
        url: function(phrase) {
            return "/search.json?q=" + phrase;
        },
        categories: [
            {
                listLocation: "players"
            }
        ],
        list: {
                maxNumberOfElements: 10,
            onChooseEvent: function() {
                var url = $input.getSelectedItemData().url
                $input.val("")
                Turbolinks.visit(url)
            }
        },
        theme: "blue"
    }

    $input.easyAutocomplete(options)
});
