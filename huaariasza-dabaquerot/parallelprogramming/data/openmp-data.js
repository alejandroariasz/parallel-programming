$(document).ready(function() 
{
    var offset = 0;
    plot();

    function plot() 
    {
        var options = 
        {
            series: 
            {
                lines: { show: true },
                points: { show: true }
            },
            grid: { hoverable: true },
            yaxis: 
            {
                min: 0,
                max: 8000
            },
            tooltip: true,
            tooltipOpts: 
            {
                content: "Time with %x threads is %y ms"
            }
        };

        var kernelo3 = [[1, 242],[2, 380],[4, 568],[8, 549],[16, 538]],
            kernelo5 = [[1, 488],[2, 553],[4, 938],[8, 947],[16, 938]],
            kernelo9 = [[1, 1319],[2, 1745],[4, 2595],[8, 2598],[16, 2526]],
            kernelo13 = [[1, 2874],[2, 3499],[4, 5424],[8, 5405],[16, 5136]],
            kernelo15 = [[1, 3834],[2, 4215],[4, 7161],[8, 7166],[16, 6686]];        

        var plotObj = $.plot($("#time-chart"), [
            {
                data: kernelo3,
                label: "kernel 3"
            }, 
            {
                data: kernelo5,
                label: "kernel 5"
            }, 
            {
                data: kernelo9,
                label: "kernel 9"
            }, 
            {
                data: kernelo13,
                label: "kernel 13"
            }, 
            {
                data: kernelo15,
                label: "kernel 15"
            }
        ], options);
    }
});