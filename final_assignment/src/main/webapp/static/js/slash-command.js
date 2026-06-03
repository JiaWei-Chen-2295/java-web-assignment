/**
 * NoteApp — Feishu-style Slash Command Menu
 * Type "/" at the beginning of a line to trigger block insertion.
 */
(function () {
    'use strict';

    // ---------------------------------------------------------------
    // Command definitions (Feishu-style categories)
    // ---------------------------------------------------------------
    var COMMANDS = [
        // -- Basic --
        {
            category: '基础',
            name: 'heading1',
            label: '标题 1',
            desc: '大标题',
            icon: '<span class="slash-icon h1">H1</span>',
            keywords: 'heading h1 标题',
            insert: '# '
        },
        {
            category: '基础',
            name: 'heading2',
            label: '标题 2',
            desc: '中标题',
            icon: '<span class="slash-icon h2">H2</span>',
            keywords: 'heading h2 标题',
            insert: '## '
        },
        {
            category: '基础',
            name: 'heading3',
            label: '标题 3',
            desc: '小标题',
            icon: '<span class="slash-icon h3">H3</span>',
            keywords: 'heading h3 标题',
            insert: '### '
        },
        {
            category: '基础',
            name: 'paragraph',
            label: '正文',
            desc: '普通文本段落',
            icon: '<i class="bi bi-text-paragraph"></i>',
            keywords: 'paragraph text 正文 文本',
            insert: ''
        },
        // -- List --
        {
            category: '列表',
            name: 'bullet-list',
            label: '无序列表',
            desc: '创建无序列表',
            icon: '<i class="bi bi-list-ul"></i>',
            keywords: 'bullet list unordered 无序列表',
            insert: '- '
        },
        {
            category: '列表',
            name: 'ordered-list',
            label: '有序列表',
            desc: '创建有序列表',
            icon: '<i class="bi bi-list-ol"></i>',
            keywords: 'ordered list number 有序列表',
            insert: '1. '
        },
        {
            category: '列表',
            name: 'checklist',
            label: '任务列表',
            desc: '创建待办事项',
            icon: '<i class="bi bi-check2-square"></i>',
            keywords: 'checklist task todo 待办 任务',
            insert: '- [ ] '
        },
        // -- Media / Block --
        {
            category: '块',
            name: 'code',
            label: '代码块',
            desc: '插入代码片段',
            icon: '<i class="bi bi-code-slash"></i>',
            keywords: 'code block 代码块',
            insert: '```\n\n```',
            cursorOffset: -4
        },
        {
            category: '块',
            name: 'quote',
            label: '引用',
            desc: '插入引用文本',
            icon: '<i class="bi bi-quote"></i>',
            keywords: 'quote blockquote 引用',
            insert: '> '
        },
        {
            category: '块',
            name: 'divider',
            label: '分割线',
            desc: '插入水平分割线',
            icon: '<i class="bi bi-hr"></i>',
            keywords: 'divider hr horizontal rule 分割线',
            insert: '\n---\n'
        },
        {
            category: '块',
            name: 'table',
            label: '表格',
            desc: '插入一个简单表格',
            icon: '<i class="bi bi-table"></i>',
            keywords: 'table 表格',
            insert: '| 列1 | 列2 | 列3 |\n| --- | --- | --- |\n|     |     |     |\n'
        },
        {
            category: '块',
            name: 'callout',
            label: '高亮块',
            desc: '插入提示/注意事项',
            icon: '<i class="bi bi-info-circle"></i>',
            keywords: 'callout notice info 高亮 提示',
            insert: '> 💡 '
        },
        {
            category: '块',
            name: 'math',
            label: '数学公式',
            desc: '插入 LaTeX 公式',
            icon: '<i class="bi bi-calculator"></i>',
            keywords: 'math latex formula 公式 数学',
            insert: '$$\n\n$$',
            cursorOffset: -3
        },
        {
            category: '块',
            name: 'image-placeholder',
            label: '图片',
            desc: '插入图片 (拖拽或上传)',
            icon: '<i class="bi bi-image"></i>',
            keywords: 'image picture 图片',
            insert: '![描述]()',
            cursorOffset: -1
        }
    ];

    // ---------------------------------------------------------------
    // Slash Menu UI
    // ---------------------------------------------------------------
    var menuEl = null;
    var filteredCommands = [];
    var activeIndex = 0;
    var slashContext = null; // { textarea, slashPos, lineStart }

    function createMenu() {
        if (menuEl) return;
        menuEl = document.createElement('div');
        menuEl.className = 'slash-menu';
        menuEl.style.display = 'none';
        document.body.appendChild(menuEl);
    }

    function showMenu(context) {
        slashContext = context;
        if (!menuEl) createMenu();
        filteredCommands = COMMANDS.slice();
        activeIndex = 0;
        renderMenu();
        positionMenu(context.textarea);
        menuEl.style.display = 'block';
    }

    function hideMenu() {
        if (menuEl) menuEl.style.display = 'none';
        slashContext = null;
    }

    function renderMenu() {
        if (!menuEl) return;

        if (filteredCommands.length === 0) {
            menuEl.innerHTML =
                '<div class="slash-menu-empty">' +
                '<i class="bi bi-search" style="font-size:18px;opacity:0.4;"></i>' +
                '<span>无匹配命令</span></div>';
            return;
        }

        var html = '';
        var lastCategory = '';
        for (var i = 0; i < filteredCommands.length; i++) {
            var cmd = filteredCommands[i];
            if (cmd.category !== lastCategory) {
                lastCategory = cmd.category;
                html += '<div class="slash-menu-category">' + escapeHtml(lastCategory) + '</div>';
            }
            html += '<div class="slash-menu-item' + (i === activeIndex ? ' active' : '') + '" data-idx="' + i + '">' +
                '<span class="slash-menu-icon">' + cmd.icon + '</span>' +
                '<div class="slash-menu-text">' +
                '<span class="slash-menu-label">' + escapeHtml(cmd.label) + '</span>' +
                '<span class="slash-menu-desc">' + escapeHtml(cmd.desc) + '</span>' +
                '</div></div>';
        }
        menuEl.innerHTML = html;

        // Bind click events
        var items = menuEl.querySelectorAll('.slash-menu-item');
        for (var j = 0; j < items.length; j++) {
            (function (idx) {
                items[idx].addEventListener('mousedown', function (e) {
                    e.preventDefault();
                    executeCommand(filteredCommands[idx]);
                });
            })(j);
        }

        // Ensure active item is visible
        var activeEl = menuEl.querySelector('.slash-menu-item.active');
        if (activeEl) {
            activeEl.scrollIntoView({ block: 'nearest' });
        }
    }

    function positionMenu(textarea) {
        if (!menuEl || !textarea) return;

        // Get caret position in the textarea/contenteditable
        var rect = getCaretCoordinates(textarea);
        if (!rect) {
            hideMenu();
            return;
        }

        var menuWidth = 280;
        var menuHeight = 320;
        var top = rect.bottom + 4;
        var left = rect.left;

        // Prevent overflow right
        if (left + menuWidth > window.innerWidth - 16) {
            left = window.innerWidth - menuWidth - 16;
        }
        // Prevent overflow bottom
        if (top + menuHeight > window.innerHeight - 16) {
            top = rect.top - menuHeight - 4;
        }
        // Prevent overflow left
        if (left < 16) left = 16;

        menuEl.style.top = top + 'px';
        menuEl.style.left = left + 'px';
        menuEl.style.width = menuWidth + 'px';
    }

    function getCaretCoordinates(el) {
        // For Vditor, the editing area may be a contenteditable or textarea
        if (el && el.getBoundingClientRect) {
            // Try selection-based coordinates first
            var sel = window.getSelection();
            if (sel && sel.rangeCount > 0) {
                var range = sel.getRangeAt(0).cloneRange();
                range.collapse(true);
                var r = range.getBoundingClientRect();
                if (r.width === 0 && r.height === 0) {
                    // Fallback: use element rect
                    return { top: r.top, bottom: r.bottom, left: r.left };
                }
                return { top: r.top, bottom: r.bottom, left: r.left };
            }
            // Fallback
            var elRect = el.getBoundingClientRect();
            return { top: elRect.top, bottom: elRect.bottom + 20, left: elRect.left };
        }
        return null;
    }

    // ---------------------------------------------------------------
    // Command execution
    // ---------------------------------------------------------------
    function executeCommand(cmd) {
        if (!slashContext) return;
        hideMenu();

        var editor = window.NoteEditor && window.NoteEditor.getEditor();
        if (!editor) return;

        // Get current markdown value
        var currentValue = editor.getValue();

        // Find the start of the current line
        var cursorPos = getCursorOffset(slashContext.textarea);
        var lineStart = currentValue.lastIndexOf('\n', cursorPos - 1) + 1;
        var lineText = currentValue.substring(lineStart, cursorPos);

        // Only proceed if the line starts with "/"
        if (lineText.charAt(0) === '/') {
            var beforeLine = currentValue.substring(0, lineStart);
            var afterCursor = currentValue.substring(cursorPos);

            // Replace the "/..." line with the command's insert text
            var newValue = beforeLine + cmd.insert + afterCursor;
            editor.setValue(newValue);

            // Position cursor
            var newCursorPos = lineStart + cmd.insert.length + (cmd.cursorOffset || 0);
            try {
                if (typeof editor.setCursor === 'function') {
                    editor.setCursor(newCursorPos);
                }
            } catch (e) {
                // Fallback: just focus the editor
            }
        }

        // Focus the editor area
        var irElement = editor.vditor && editor.vditor.ir && editor.vditor.ir.element;
        if (irElement) {
            irElement.focus();
            irElement.dispatchEvent(new Event('input', { bubbles: true }));
        }

        // Dispatch outline refresh
        document.dispatchEvent(new CustomEvent('editor-content-changed'));
    }

    // ---------------------------------------------------------------
    // Input monitoring — triggered from Vditor's input callback
    // ---------------------------------------------------------------
    var inputBuffer = '';
    var suggestionDebounce = null;

    function onEditorInput() {
        var editor = window.NoteEditor && window.NoteEditor.getEditor();
        if (!editor) return;

        var currentValue = editor.getValue();
        if (!currentValue) return;

        // Get cursor position from selection
        var irElement = editor.vditor && editor.vditor.ir && editor.vditor.ir.element;
        if (!irElement) return;

        var sel = window.getSelection();
        if (!sel || sel.rangeCount === 0) return;

        // Approximate cursor position in markdown
        var cursorPos = getCursorOffset(irElement);

        // Find start of current line
        var lineStart = currentValue.lastIndexOf('\n', cursorPos - 1) + 1;
        var lineText = currentValue.substring(lineStart, cursorPos);

        // Check if line starts with "/"
        if (lineText.charAt(0) === '/') {
            var filterText = lineText.substring(1).toLowerCase();

            if (filterText.length === 0) {
                filteredCommands = COMMANDS.slice();
            } else {
                filteredCommands = COMMANDS.filter(function (cmd) {
                    return cmd.label.toLowerCase().indexOf(filterText) !== -1 ||
                           cmd.name.toLowerCase().indexOf(filterText) !== -1 ||
                           cmd.keywords.toLowerCase().indexOf(filterText) !== -1 ||
                           cmd.desc.toLowerCase().indexOf(filterText) !== -1;
                });
            }

            activeIndex = 0;
            slashContext = {
                textarea: irElement,
                slashPos: lineStart,
                filterEnd: cursorPos
            };
            showMenu(slashContext);
        } else {
            hideMenu();
        }
    }

    function getCursorOffset(el) {
        var editor = window.NoteEditor && window.NoteEditor.getEditor();
        if (!editor) return 0;

        var sel = window.getSelection();
        if (!sel || sel.rangeCount === 0) return 0;

        // Approximate offset by counting text nodes before cursor
        var range = sel.getRangeAt(0);
        var preRange = document.createRange();
        preRange.setStart(el, 0);
        preRange.setEnd(range.startContainer, range.startOffset);
        var text = preRange.toString();
        return text.length;
    }

    // ---------------------------------------------------------------
    // Click outside to dismiss
    // ---------------------------------------------------------------
    document.addEventListener('mousedown', function (e) {
        if (menuEl && menuEl.style.display !== 'none' && !menuEl.contains(e.target)) {
            hideMenu();
        }
    });

    // ---------------------------------------------------------------
    // Keyboard navigation for slash menu
    // ---------------------------------------------------------------
    function onEditorKeydown(e) {
        if (!slashContext) return;

        if (e.key === 'ArrowDown') {
            e.preventDefault();
            activeIndex = (activeIndex + 1) % filteredCommands.length;
            renderMenu();
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            activeIndex = (activeIndex - 1 + filteredCommands.length) % filteredCommands.length;
            renderMenu();
        } else if (e.key === 'Enter' || e.key === 'Tab') {
            if (menuEl && menuEl.style.display !== 'none' && filteredCommands[activeIndex]) {
                e.preventDefault();
                executeCommand(filteredCommands[activeIndex]);
            }
        } else if (e.key === 'Escape') {
            e.preventDefault();
            hideMenu();
        }
    }

    // ---------------------------------------------------------------
    // Boot
    // ---------------------------------------------------------------
    function init() {
        createMenu();

        // Bind keyboard navigation globally
        document.addEventListener('keydown', onEditorKeydown);

        // Wait for Vditor to be ready
        var checkInterval = setInterval(function () {
            var editor = window.NoteEditor && window.NoteEditor.getEditor();
            if (editor && editor.vditor) {
                clearInterval(checkInterval);
                // Bind IR element keyboard events as backup
                var irElement = editor.vditor.ir && editor.vditor.ir.element;
                if (irElement) {
                    irElement.addEventListener('input', onEditorInput);
                }
            }
        }, 500);

        // Hide on Escape globally
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') hideMenu();
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Expose API
    window.SlashCommand = {
        show: showMenu,
        hide: hideMenu,
        onInput: onEditorInput,
        getCommands: function () { return COMMANDS; }
    };

    function escapeHtml(text) {
        var d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }
})();
