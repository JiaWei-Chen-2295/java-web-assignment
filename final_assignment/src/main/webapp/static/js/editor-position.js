/**
 * EditorPosition — 浮窗/下拉菜单智能定位模块
 * 统一使用 position:fixed + 视口相对坐标，支持底部翻转和左右边界检查
 */
(function (global) {
    'use strict';

    /**
     * 将浮窗元素智能定位到锚点附近
     * @param {HTMLElement} el    - 浮窗 DOM 元素
     * @param {ClientRect} rect  - 锚点的视口坐标 (由 getBoundingClientRect() 返回)
     * @param {Object}      opts - 选项
     *   opts.width     预估浮窗宽度 (用于左边界钳制), 默认 280
     *   opts.maxHeight 浮窗最大高度 (用于判断是否翻转), 默认 320
     *   opts.gap       锚点与浮窗的间距, 默认 6
     *   opts.preferBelow 优先在下方显示, 默认 true
     */
    function place(el, rect, opts) {
        if (!el || !rect) return;
        opts = opts || {};
        var width = opts.width || 280;
        var maxHeight = opts.maxHeight || 320;
        var gap = opts.gap || 6;
        var preferBelow = opts.preferBelow !== false;

        el.style.position = 'fixed';

        // --- 垂直方向 ---
        var topBelow = rect.bottom + gap;
        var topAbove = rect.top - gap;

        // 先渲染一次以获取真实高度
        el.style.visibility = 'hidden';
        el.style.display = 'block';
        el.style.top = topBelow + 'px';
        el.style.left = '0px';
        var realHeight = el.offsetHeight || maxHeight;
        el.style.visibility = '';

        // 判断下方是否有足够空间
        var spaceBelow = global.innerHeight - topBelow;
        var spaceAbove = rect.top;

        var placeBelow;
        if (preferBelow) {
            // 优先下方：下方够放就放下方，不够放才翻到上方
            placeBelow = spaceBelow >= realHeight || spaceBelow >= spaceAbove;
        } else {
            placeBelow = false;
        }

        var top;
        if (placeBelow) {
            top = topBelow;
            // 如果下方空间不够但仍然选择下方（因为上方更小），钳制到视口内
            if (top + realHeight > global.innerHeight) {
                top = Math.max(0, global.innerHeight - realHeight - 8);
            }
        } else {
            top = Math.max(0, topAbove - realHeight);
            // 上方空间不够时钳制到顶部
            if (top < 0) {
                top = 0;
            }
        }

        // --- 水平方向 ---
        var left = rect.left;
        // 右边界钳制
        if (left + width > global.innerWidth - 16) {
            left = global.innerWidth - width - 16;
        }
        // 左边界钳制
        if (left < 16) {
            left = 16;
        }

        el.style.top = top + 'px';
        el.style.left = left + 'px';
    }

    global.EditorPosition = { place: place };
})(window);