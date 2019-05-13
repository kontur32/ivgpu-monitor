module namespace ivgpu = "ivgpu";

declare 
  %rest:path("/ivgpu/monitor/vkr")
  %rest:GET
  %rest:query-param( "sessionid", "{ $sessionid }",  "")
  %output:method( "xhtml" )
function ivgpu:monitor( $sessionid ){
let $r := http:send-request(
    <http:request method='get'
       href='{ "https://dp.ivgpu.com/teacher/vkr_department" }'>
      <http:header name="Cookie" value="{ 'sessionid=' || $sessionid }" />
    </http:request>
   )[2]//table[1]
   
let $rows := $r/tbody/tr
let $prep := distinct-values( $rows/td[2])
return 
  <html>
    <body>
      <div class="container">
      <div class="row">
        <div class="h3">Мониторинг загрузки ВКР кафедры ЭУФ</div>
      </div>
      <div class="row">
        <div class="text-center font-italic">по состоянию на { current-date() }</div>
      </div>
      <div class="table">
      <table class="table-striped">
        <tr class="text-center">
          <th>#</th>
          <th>Преподаватель</th>
          <th>Загружено ВКР</th>
        </tr>
      {
        for $p in $prep
        order by $p
        count $c
        return
          <tr>
            <td>{ $c }.</td>
            <td>{$p}</td>
            <td  class="text-center">{ count( $rows[td[2]/text() = $p ] ) } </td>
          </tr> ,
          <tr class="text-center font-bold">
            <td></td>
            <td>Всего:</td>
            <td>{count ( $rows )}</td>
          </tr>
        }</table>
        </div>
      </div>
     </body>
     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"></link>
   </html>
};