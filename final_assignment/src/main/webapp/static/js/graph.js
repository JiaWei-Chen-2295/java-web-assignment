/**
 * Note App — 知识图谱（ECharts 力导向图）
 */
(function () {
    'use strict';

    var chart = null;
    var container = null;
    var dragMoved = false;
    var pressOnNode = null;

    function contextPath() {
        return window.contextPath || '';
    }

    function init() {
        container = document.getElementById('graph-container');
        if (!container) return;

        fetchAndRender();
        window.addEventListener('resize', handleResize);
    }

    function fetchAndRender() {
        var cp = contextPath();
        fetch(cp + '/api/graph')
            .then(function (resp) {
                if (!resp.ok) throw new Error('HTTP ' + resp.status);
                return resp.json();
            })
            .then(function (data) {
                if (!data || !data.nodes || data.nodes.length === 0) {
                    showEmptyState();
                    return;
                }
                renderGraph(data);
                updateStats(data);
            })
            .catch(function (err) {
                console.error('Failed to load graph data:', err);
                showEmptyState();
            });
    }

    function getNodeId(data) {
        if (!data) return null;
        if (data.noteId != null) return data.noteId;
        if (data.id != null) return data.id;
        return null;
    }

    function navigateToNote(data) {
        var id = getNodeId(data);
        if (id == null) return;
        window.location.href = contextPath() + '/note/edit?id=' + id;
    }

    function bindNodeNavigation() {
        if (!chart) return;

        function tryNavigate(params) {
            if (!params || params.dataType !== 'node' || !params.data) return;
            navigateToNote(params.data);
        }

        chart.off('click');
        chart.off('dblclick');
        chart.off('mousedown');
        chart.off('mouseup');
        chart.off('globalout');

        chart.on('click', tryNavigate);
        chart.on('dblclick', function (params) {
            tryNavigate(params);
        });

        // draggable 时单击常被当成拖拽，用「按下/抬起且未移动」补一次点击
        chart.on('mousedown', function (params) {
            dragMoved = false;
            if (params.dataType === 'node' && params.data) {
                pressOnNode = params.data;
            } else {
                pressOnNode = null;
            }
        });

        chart.on('mouseup', function (params) {
            if (!dragMoved && pressOnNode) {
                if (params.dataType === 'node' && params.data &&
                    String(getNodeId(params.data)) === String(getNodeId(pressOnNode))) {
                    navigateToNote(params.data);
                } else {
                    navigateToNote(pressOnNode);
                }
            }
            pressOnNode = null;
            dragMoved = false;
        });

        chart.on('globalout', function () {
            pressOnNode = null;
            dragMoved = false;
        });

        var zr = chart.getZr();
        if (zr && !zr.__graphDragHook) {
            zr.__graphDragHook = true;
            zr.on('mousemove', function () {
                if (pressOnNode) dragMoved = true;
            });
        }
    }

    function renderGraph(data) {
        if (typeof echarts === 'undefined') {
            container.innerHTML =
                '<div class="empty-state"><p>未加载 ECharts，请检查网络后刷新页面。</p></div>';
            return;
        }

        var nodes = data.nodes.map(function (node) {
            var linkCount = node.links || 0;
            var noteId = node.id;
            return {
                id: String(noteId),
                noteId: noteId,
                name: node.title || ('笔记 ' + noteId),
                symbolSize: Math.sqrt(linkCount) * 10 + 10,
                value: linkCount,
                cursor: 'pointer',
                label: {
                    show: true,
                    fontSize: 12,
                    color: '#1F2329'
                },
                itemStyle: {
                    color: getNodeColor(linkCount),
                    borderColor: '#fff',
                    borderWidth: 2
                }
            };
        });

        var edges = (data.edges || []).map(function (edge) {
            return {
                source: String(edge.source),
                target: String(edge.target),
                lineStyle: {
                    color: '#DEE0E3',
                    width: 1.5,
                    curveness: 0.2
                }
            };
        });

        if (chart) {
            chart.dispose();
            chart = null;
        }
        chart = echarts.init(container, null, { renderer: 'canvas' });

        chart.setOption({
            tooltip: {
                trigger: 'item',
                formatter: function (params) {
                    if (params.dataType === 'node') {
                        return '<strong>' + params.name + '</strong><br/>链接数：' + (params.value || 0) +
                            '<br/><span style="color:#8F959E;font-size:12px">单击或双击打开笔记</span>';
                    }
                    return '';
                },
                backgroundColor: '#fff',
                borderColor: '#DEE0E3',
                borderWidth: 1,
                textStyle: { color: '#1F2329', fontSize: 13 },
                padding: [8, 12]
            },
            animationDuration: 1000,
            animationEasingUpdate: 'quinticInOut',
            series: [
                {
                    type: 'graph',
                    layout: 'force',
                    roam: true,
                    draggable: true,
                    data: nodes,
                    links: edges,
                    force: {
                        repulsion: 220,
                        edgeLength: [80, 180],
                        gravity: 0.08
                    },
                    emphasis: {
                        focus: 'adjacency',
                        scale: true,
                        lineStyle: {
                            width: 3,
                            color: '#3370FF'
                        },
                        itemStyle: {
                            borderColor: '#3370FF',
                            borderWidth: 3,
                            shadowBlur: 10,
                            shadowColor: 'rgba(51,112,255,0.3)'
                        }
                    },
                    label: {
                        show: true,
                        position: 'bottom',
                        fontSize: 12,
                        color: '#646A73',
                        distance: 5
                    },
                    lineStyle: {
                        opacity: 0.6
                    },
                    select: {
                        disabled: true
                    }
                }
            ]
        });

        bindNodeNavigation();
    }

    function getNodeColor(linkCount) {
        if (linkCount >= 10) return '#3370FF';
        if (linkCount >= 5) return '#5B8DEF';
        if (linkCount >= 2) return '#85ABF5';
        return '#B3CCFA';
    }

    function updateStats(data) {
        var statsEl = document.getElementById('graph-stats');
        if (!statsEl) return;
        var noteCount = data.nodes ? data.nodes.length : 0;
        var linkCount = data.edges ? data.edges.length : 0;
        statsEl.innerHTML = '<i class="bi bi-diagram-3"></i> ' + noteCount + ' 篇笔记 · ' + linkCount + ' 条链接';
    }

    function showEmptyState() {
        var cp = contextPath();
        container.innerHTML =
            '<div class="empty-state">' +
            '  <div class="empty-state-icon"><i class="bi bi-diagram-3"></i></div>' +
            '  <h3>还没有可展示的链接</h3>' +
            '  <p>创建多篇笔记，在正文中使用 [[标题]] 引用其他笔记后，图谱会自动出现连线</p>' +
            '  <a href="' + cp + '/note/new" class="btn btn-primary"><i class="bi bi-plus-lg"></i> 新建笔记</a>' +
            '</div>';
    }

    function handleResize() {
        if (chart) chart.resize();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    window.GraphView = {
        refresh: fetchAndRender,
        getChart: function () { return chart; }
    };
})();
