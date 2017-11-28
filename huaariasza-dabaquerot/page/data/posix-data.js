$(document).ready(function() {
    var offset = 0;
    plot();

    function plot() {
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

        var kernelp3 = [[1, 117], [2, 368], [4, 553], [8, 537], [16, 518]],
            kernelp5 = [[1, 468], [2, 884], [4, 983], [8, 952], [16, 922]],
            kernelp9 = [[1, 1309], [2, 1606], [4, 2735], [8, 2663], [16, 2535]],
            kernelp13 = [[1, 2843], [2, 3089], [4, 5767], [8, 5573], [16, 5169]],
            kernelp15 = [[1, 3744], [2, 4140], [4, 7674], [8, 7387], [16, 6769]];

        var plotObj = $.plot($("#time-chart"), 
        [
            {
                data: kernelp3,
                label: "kernel 3"
            }, 
            {
                data: kernelp5,
                label: "kernel 5"
            }, 
            {
                data: kernelp9,
                label: "kernel 9"
            }, 
            {
                data: kernelp13,
                label: "kernel 13"
            }, 
            {
                data: kernelp15,
                label: "kernel 15"
            }
        ], options);
    }
});