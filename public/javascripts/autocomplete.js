function ac(data) {
    $(function() {
        function split( val ) {
            return val.split( /,\s*/ );
        }
        function extractLast( term ) {
            return split( term ).pop();
        }
        $( "#tag_name" )
            .bind("keydown", function(event) {
                if (event.keyCode === $.ui.keyCode.TAB && $(this).data("autocomplete").menu.active) {
                    event.preventDefault();
                }
            })
            .autocomplete({
                minLength: 1,
                source: function( request, response ) {
                    // autocomplete()のsourceに渡すデータには
                    // labelかvalueが含まれていないといけないので、新しく配列を作ることにした。
                    var renamed_data = [];
                    $.each(data, function (k,v) {
                        renamed_data.push({label: v.phonetic_name, value: v.name});
                    });
                    response($.ui.autocomplete.filter(renamed_data, extractLast(request.term)));
                },
                focus: function(event, ui) {
                    return false;
                },
                select: function( event, ui ) {
                    var terms = split( this.value );
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push( ui.item.value );
                    // add placeholder to get the comma-and-space at the end
                    terms.push( "" );
                    this.value = terms.join( ", " );
                    return false;
                }
            })
            .data("autocomplete")._renderItem = function( ul, item ) {
                return $( "<li></li>" )
                    .data( "item.autocomplete", item )
                    .append( "<a>" + item.value + "</a>" )
                    .appendTo( ul );
            };
    });
}