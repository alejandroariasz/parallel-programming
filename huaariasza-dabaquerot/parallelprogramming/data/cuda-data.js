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
                max: 800
            },
            tooltip: true,
            tooltipOpts: 
            {
                content: "Time with %x threads is %y ms"
            }
        };

        var kernel1c3 = [[192, 263],[384, 242],[768, 234],[1536, 219],[3072, 218],[6144, 221]],
            kernel1c5 = [[192, 298],[384, 264],[768, 248],[1536, 219],[3072, 220],[6144, 219]],
            kernel1c13 = [[192, 640],[384, 474],[768, 398],[1536, 219],[3072, 221],[6144, 221]],
            kernel1c15 = [[192, 792],[384, 564],[768, 459],[1536, 220],[3072, 219],[6144, 220]]

            kernel2c3 = [[192, 241],[384, 228],[768, 224],[1536, 226],[3072, 222],[6144, 218]],
            kernel2c5 = [[192, 255],[384, 238],[768, 229],[1536, 237],[3072, 220],[6144, 219]],
            kernel2c13 = [[192, 409],[384, 320],[768, 277],[1536, 324],[3072, 218],[6144, 219]],
            kernel2c15 = [[192, 478],[384, 356],[768, 298],[1536, 358],[3072, 218],[6144, 218]];        

        var plotObj = $.plot($("#time-chart"), 
        [
            {
                data: kernel1c3,
                label: "kernel 3 1 block"
            }, 
            {
                data: kernel1c5,
                label: "kernel 5 1 block"
            }, 
            {
                data: kernel1c13,
                label: "kernel 13 1 block"
            }, 
            {
                data: kernel1c15,
                label: "kernel 15 1 block"
            },
            {
                data: kernel2c3,
                label: "kernel 3 2 blocks"
            }, 
            {
                data: kernel2c5,
                label: "kernel 5 2 blocks"
            }, 
            {
                data: kernel2c13,
                label: "kernel 13 2 blocks"
            }, 
            {
                data: kernel2c15,
                label: "kernel 15 2 blocks"
            }
        ], options);
    }
});