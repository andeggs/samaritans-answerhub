
<div id="container" class="highcharts-container" style="height:410px; margin: 10px 0 0 0; clear:both; width: 700px">
<script type="text/javascript">
var chart;
$(document).ready(function() {
   chart = new Highcharts.Chart({
      chart: {
         renderTo: 'container',
         zoomType: 'x',
         spacingRight: 20
      },
       title: {
           <#if !currentUser?? || currentUser.id != profileUser.id>
                   text: '${profileUser.username?html}\'s Reputation'
            <#else>
                   text: 'Your Reputation'
            </#if>
      },
       subtitle: {
         text: document.ontouchstart === undefined ?
            'Click and drag in the graph to zoom in' :
            'Drag your finger over the graph to zoom in'
      },
      xAxis: {
         type: 'datetime',
         maxZoom: 24 * 3600000, // 1 day
         title: {
            text: null
         }
      },
      yAxis: {
         title: {
            text: 'Reputation'
         },
         min: 0.6,
         startOnTick: false,
         showFirstLabel: false
      },
      tooltip: {
         shared: true
      },
      legend: {
         enabled: false
      },
      plotOptions: {
         area: {
            fillColor: {
               linearGradient: [0, 0, 0, 300],
               stops: [
                  [0, Highcharts.theme.colors[0]],
                  [1, 'rgba(2,0,0,0)']
               ]
            },
            lineWidth: 1,
            marker: {
               enabled: false,
               states: {
                  hover: {
                     enabled: true,
                     radius: 5
                  }
               }
            },
            shadow: false,
            states: {
               hover: {
                  lineWidth: 1
               }
            }
         }
      },

      series: [{
         type: 'area',
         name: 'Reputation Earned',
         pointInterval: 24 * 3600 * 1000,
         pointStart: Date.UTC(${createYear},${createMonth}, ${createDay}), // This is the start date of the user
         data: [<#if reputationHistory?size == 0>0<#else><#list reputationHistory as history>
           ${history[1]}<#if history_has_next>,</#if>
            </#list></#if>
         ]
      }]
   });


});</script>

<#--<div id="placeholder" style="width:600px;height:300px;"></div>
<script type="text/javascript">
    var d = [
        <#list reputationHistory as history>
        ['${history[0]}', ${history[1]}]<#if history_has_next>,</#if>
        </#list>
    ];

    $.plot($("#placeholder"), [d], {
//        xaxis: {
//            mode: "time",
//            minTickSize: [1, "day"],
//        }
    });
</script>-->
