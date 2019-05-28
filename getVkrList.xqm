module namespace ivgpu = "ivgpu";

declare 
  %rest:path("/ivgpu/monitor/vkr")
  %rest:GET
  %rest:query-param( "sessionid", "{ $sessionid }",  "")
  %rest:query-param( "year", "{ $year }",  "2018")
  %output:method( "xhtml" )
function ivgpu:monitor( $sessionid as xs:string, $year as xs:string ){
let $r := http:send-request(
    <http:request method='get'
       href='{ "https://dp.ivgpu.com/teacher/vkr_department" }'>
      <http:header name="Cookie" value="{ 'sessionid=' || $sessionid }" />
    </http:request>
   )[2]//table[1]
   
let $rows := $r/tbody/tr[ td[7]  = $year ]
let $prep := sort( distinct-values( $rows/td[ 2 ] ) )
let $napr := sort( distinct-values( $rows/td[ 5 ] ) )
let $href := "/ivgpu/monitor/vkr?sessionid=" || $sessionid || "&amp;year="

let $result := 
  <html>
    <body>
      <div class="container">
        <div class="row">
          <div class="h3">Мониторинг загрузки ВКР кафедры ЭУФ за { $year }</div>
         </div>
        
        <div class="row">
          <p class="font-weight-bold mr-3">Данные по годам:</p>
          <p>
            <a href='{$href || "2017"}'>2017</a>,
            <a href='{$href || "2018"}'>2018</a>,
            <a href='{$href || "2019"}'>2019</a>
          </p> 
        </div>
        
      <div class="row">
        <div class="text-center font-italic">по состоянию на { current-date() }</div>
      </div>
      
      <div class="table">
      {
        ivgpu:table( $rows, $prep, $napr )
      }
      </div>
     </div>
      
   </body>
     
     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"></link>
   </html>
   
   return $result
};

declare function ivgpu:table( $rows, $prep, $napr ){
      <table class="table-striped">
        <tr class="text-center">
          <th>#</th>
          <th>Преподаватель</th>
          <th>Загружено ВКР всего</th>
          
          {
            for $n in $napr
            return
              <th>{ $n }</th>
          }
        </tr>
      {
        for $p in $prep
        count $c
        return
          <tr>
            <td>{ $c }.</td>
            <td>{$p}</td>
            <td  class="text-center">{ count( $rows[td[2]/text() = $p ] ) }</td>
            {
              for $n in $napr
              return
                <td class="text-center">{  count( $rows[ td[2]/text() = $p and  td[5]/text() = $n ] ) }</td>
            }
          </tr> ,
          <tr class="text-center font-bold">
            <th></th>
            <th>Всего:</th>
            <th>{ count ( $rows ) }</th>
            {
              for $n in $napr
              return
                <th class="text-center">
                  { count( $rows[ td[ 5 ]/text() = $n ] ) }
                </th> 
            }
          </tr>
        }</table>
};