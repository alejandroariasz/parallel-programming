//Flot Line Chart
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

        var kernelp3_su = [[1, 117], [2, 368], [4, 553], [8, 537], [16, 518]],
            kernelp5_su = [[1, 468], [2, 884], [4, 983], [8, 952], [16, 922]],
            kernelp9_su = [[1, 1309], [2, 1606], [4, 2735], [8, 2663], [16, 2535]],
            kernelp13_su = [[1, 2843], [2, 3089], [4, 5767], [8, 5573], [16, 5169]],
            kernelp15_su = [[1, 3744], [2, 4140], [4, 7674], [8, 7387], [16, 6769]];

        var plotObj = $.plot($("#speedup-chart"), 
        [
            {
                data: kernelp3_su,
                label: "kernel 3"
            }, 
            {
                data: kernelp5_su,
                label: "kernel 5"
            }, 
            {
                data: kernelp9_su,
                label: "kernel 9"
            }, 
            {
                data: kernelp13_su,
                label: "kernel 13"
            }, 
            {
                data: kernelp15_su,
                label: "kernel 15"
            }
        ], options);

        var kernelo3 = [[1, 242],[2, 380],[4, 568],[8, 549],[16, 538]],
            kernelo5 = [[1, 488],[2, 553],[4, 938],[8, 947],[16, 938]],
            kernelo9 = [[1, 1319],[2, 1745],[4, 2595],[8, 2598],[16, 2526]],
            kernelo13 = [[1, 2874],[2, 3499],[4, 5424],[8, 5405],[16, 5136]],
            kernelo15 = [[1, 3834],[2, 4215],[4, 7161],[8, 7166],[16, 6686]];

        var plotObj = $.plot($("#time-chart"), 
        [
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
                label: "kernel 3 1 bloque"
            }, 
            {
                data: kernel1c5,
                label: "kernel 5 1 bloque"
            }, 
            {
                data: kernel1c13,
                label: "kernel 13 1 bloque"
            }, 
            {
                data: kernel1c15,
                label: "kernel 15 1 bloque"
            },
            {
                data: kernel2c3,
                label: "kernel 3 2 bloques"
            }, 
            {
                data: kernel2c5,
                label: "kernel 5 2 bloques"
            }, 
            {
                data: kernel2c13,
                label: "kernel 13 2 bloques"
            }, 
            {
                data: kernel2c15,
                label: "kernel 15 2 bloques"
            }
        ], options);
    }
});