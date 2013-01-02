$(function () {
  var table, visualSearch

  visualSearch = VS.init({
    container : $('.visualsearch'),
    query     : '',
    callbacks : {
      search: function() {
        table.fnDraw()
      },
      facetMatches: function(callback) {
        callback(['strength', 'checking'])
      },
      valueMatches: function(facet, searchTerm, callback) {
        switch (facet) {
          case 'strength': callback(['strong', 'weak']);    break
          case 'checking': callback(['static', 'dynamic']); break
        }
      }
    }
  })

  table = $('table.languages').dataTable({
    bFilter: false,
    bSort: false,
    bInfo: false,
    bLengthChange: false,
    iDisplayLength: 100,
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: '/list.json',
    fnServerParams: function (aoData) {
      var facets = visualSearch.searchQuery.facets()

      $.each(facets, function (index, facet) {
        var name  = _.keys(facet)[0],
            value = _.values(facet)[0]

        aoData.push({
          name: 'search[' + name + '][]',
          value: value
        })
      })
    }
  })
})
