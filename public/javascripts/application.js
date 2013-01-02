$(function () {
  $('table.languages').dataTable({
    bFilter: false,
    bSort: false,
    bInfo: false,
    bLengthChange: false,
    iDisplayLength: 100,
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: '/list.json'
  })
})
